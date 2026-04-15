import Foundation
import SwiftUI
import Combine

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let text: String
    let isUser: Bool
    let date: Date
}

final class ChatboxViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    private let request = RequestHandler()
    @Published var isLoading: Bool = false

    private var cancellable: AnyCancellable?
    private let storageKey = "chat_messages_storage_v1"

    private func save(_ messages: [ChatMessage]) {
        do {
            let data = try JSONEncoder().encode(messages)
            UserDefaults.standard.set(data, forKey: storageKey)
        } catch {
            print("❌ Failed to save chat messages:", error)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey) else { return }
        do {
            let decoded = try JSONDecoder().decode([ChatMessage].self, from: data)
            self.messages = decoded
        } catch {
            print("❌ Failed to load chat messages:", error)
        }
    }

    init() {
        load()
        // Save whenever messages change
        cancellable = $messages
            .sink { [weak self] msgs in
                self?.save(msgs)
            }
    }

    func send() {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        // Append user message with timestamp
        let userMsg = ChatMessage(text: trimmed, isUser: true, date: Date())
        messages.append(userMsg)

        // Clear input and set loading
        inputText = ""
        isLoading = true

        // Call GraphQL backend
        request.askChatBot(question: trimmed) { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                self.isLoading = false

                if let error = result["error"] as? String {
                    print("❌ ChatBot error:", error)
                    self.messages.append(ChatMessage(text: "Sorry, I ran into an issue. Please try again.", isUser: false, date: Date()))
                    return
                }

                let raw = (result["answer"] as? String) ?? "No answer received."
                // Normalize leading/trailing whitespace and excessive blank lines
                let removedLeadingBlanks = raw.replacingOccurrences(of: #"^\s*\n+"#, with: "", options: .regularExpression)
                let trimmed = removedLeadingBlanks.trimmingCharacters(in: .whitespacesAndNewlines)
                let collapsed = trimmed.replacingOccurrences(of: #"(?:\n\s*){3,}"#, with: "\n\n", options: .regularExpression)

                self.messages.append(ChatMessage(text: collapsed, isUser: false, date: Date()))
            }
        }
    }
}
