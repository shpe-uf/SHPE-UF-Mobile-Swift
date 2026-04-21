import Foundation
import SwiftUI

enum MessageStatus {
    case sent
    case failed(String) // Carries the error description for display
}

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let date: Date
    var status: MessageStatus = .sent
}

final class ChatboxViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    private let request = RequestHandler()
    @Published var isLoading: Bool = false

    func send(persona: String? = nil) {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let userMsg = ChatMessage(text: trimmed, isUser: true, date: Date())
        messages.append(userMsg)

        inputText = ""
        sendQuestion(trimmed, userMessageID: userMsg.id, persona: persona)
    }

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
