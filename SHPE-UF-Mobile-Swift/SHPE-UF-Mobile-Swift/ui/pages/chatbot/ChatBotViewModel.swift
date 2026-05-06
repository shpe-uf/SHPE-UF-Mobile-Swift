import Foundation
import SwiftUI

/// Delivery status of a ``ChatMessage``.
enum MessageStatus: Codable {
    case sent
    /// Includes a user-facing error description (e.g. "Network error — tap to retry.").
    case failed(String)
}

/// A single message in the chat conversation, persisted to `UserDefaults` via `Codable`.
struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let text: String
    let isUser: Bool
    let date: Date
    var status: MessageStatus

    init(text: String, isUser: Bool, date: Date, status: MessageStatus = .sent) {
        self.id = UUID()
        self.text = text
        self.isUser = isUser
        self.date = date
        self.status = status
    }
}

/// View model that manages the chatbot's message state, networking, and local persistence.
///
/// This view model:
/// 1. Sends user questions to the server via ``RequestHandler/askChatBot(question:persona:completion:)``
/// 2. Appends bot responses with normalized markdown formatting
/// 3. Marks failed messages with a user-facing error and supports tap-to-retry
/// 4. Persists the conversation to `UserDefaults` (capped at 100 messages)
///
/// ## Data Flow
/// - Messages are encoded to `UserDefaults` on every change via `didSet`
/// - On init, messages are restored from storage; failed statuses reset to `.sent`
/// - Clearing messages writes an empty array to storage
///
/// ## Example Usage
/// ```swift
/// @StateObject private var vm = ChatBotViewModel()
/// vm.send(persona: "Tito")
/// ```
final class ChatBotViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [] {
        didSet { saveMessages() }
    }
    @Published var inputText: String = ""
    private let request = RequestHandler()
    @Published var isLoading: Bool = false

    private static let messagesKey = "chatbot_messages"

    init() {
        messages = Self.loadMessages()
    }

    private static let maxPersistedMessages = 100

    private func saveMessages() {
        let toSave = messages.suffix(Self.maxPersistedMessages)
        guard let data = try? JSONEncoder().encode(Array(toSave)) else { return }
        UserDefaults.standard.set(data, forKey: Self.messagesKey)
    }

    private static func loadMessages() -> [ChatMessage] {
        guard let data = UserDefaults.standard.data(forKey: messagesKey),
              var loaded = try? JSONDecoder().decode([ChatMessage].self, from: data) else { return [] }
        // Reset any failed messages to sent on relaunch
        for i in loaded.indices {
            if case .failed = loaded[i].status {
                loaded[i].status = .sent
            }
        }
        return loaded
    }

    /// Sends the current ``inputText`` as a user message and triggers the server request.
    /// - Parameter persona: The persona value to pass to the GraphQL query (e.g. "Tito").
    func send(persona: String? = nil) {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMsg = ChatMessage(text: trimmed, isUser: true, date: Date())
        messages.append(userMsg)

        inputText = ""
        sendQuestion(trimmed, userMessageID: userMsg.id, persona: persona)
    }

    /// Re-sends a previously failed user message.
    /// - Parameters:
    ///   - messageID: The `id` of the failed ``ChatMessage`` to retry.
    ///   - persona: The persona value to pass to the server.
    func retry(messageID: UUID, persona: String? = nil) {
        guard let index = messages.firstIndex(where: { $0.id == messageID }),
              messages[index].isUser,
              case .failed = messages[index].status else { return }

        // Reset status to sent and re-send
        messages[index].status = .sent
        let question = messages[index].text
        sendQuestion(question, userMessageID: messageID, persona: persona)
    }

    private func sendQuestion(_ question: String, userMessageID: UUID, persona: String? = nil) {
        isLoading = true

        request.askChatBot(question: question, persona: persona) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                if let error = result["error"] as? String {
                    #if DEBUG
                    print("ChatBot error:", error)
                    #endif
                    // Mark the user message as failed with a descriptive error
                    if let index = self.messages.firstIndex(where: { $0.id == userMessageID }) {
                        let errorMessage = self.classifyError(error)
                        self.messages[index].status = .failed(errorMessage)
                    }
                    return
                }

                let raw = (result["answer"] as? String) ?? "No answer received."
                let normalized = Self.normalizeForMarkdown(raw)

                self.messages.append(ChatMessage(text: normalized, isUser: false, date: Date()))
            }
        }
    }

    private func classifyError(_ error: String) -> String {
        let lower = error.lowercased()
        if lower.contains("network") || lower.contains("offline") ||
           lower.contains("timed out") || lower.contains("not connected") ||
           lower.contains("nsurlerror") || lower.contains("connection") {
            return "Network error — check your connection and tap to retry."
        } else {
            return "Server error — tap to retry."
        }
    }

    /// Cleans up the server's raw response for proper markdown rendering — trims blank lines, fixes bullet spacing, and collapses excessive newlines.
    static func normalizeForMarkdown(_ raw: String) -> String {
        // 1. Strip leading blank lines and trailing whitespace
        let removedLeadingBlanks = raw.replacingOccurrences(of: #"^\s*\n+"#, with: "", options: .regularExpression)
        let trimmedAnswer = removedLeadingBlanks.trimmingCharacters(in: .whitespacesAndNewlines)
        // 2. Insert a newline before bullet characters that aren't already preceded by one
        let bulletsFixed = trimmedAnswer.replacingOccurrences(of: #"(?<!\n)•"#, with: "\n•", options: .regularExpression)
        // 3. Collapse 3+ consecutive newlines into exactly two
        return bulletsFixed.replacingOccurrences(of: #"(?:\n\s*){3,}"#, with: "\n\n", options: .regularExpression)
    }
}
