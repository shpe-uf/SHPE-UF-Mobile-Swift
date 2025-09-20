import Foundation
import SwiftUI

struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

final class ChatboxViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []   // 👈 start EMPTY now
    @Published var inputText: String = ""

    func send() {
        guard !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        // user message
        let userMsg = ChatMessage(text: inputText, isUser: true)
        messages.append(userMsg)

        inputText = ""

        // fake Tito reply (you can replace with API later)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            let reply = ChatMessage(text: "Got it! (frontend only right now)", isUser: false)
            self.messages.append(reply)
        }
    }
}
