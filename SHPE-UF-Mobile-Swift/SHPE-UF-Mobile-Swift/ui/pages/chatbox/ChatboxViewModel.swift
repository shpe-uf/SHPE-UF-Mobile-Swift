//
//  ChatboxViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Mazin Saleh on 9/19/25.
//

import SwiftUI

class ChatboxViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage(text: "I’m Tito! Ask me any questions about SHPE UF!", isUser: false)
    ]
    @Published var inputText: String = ""

    func sendMessage() {
        guard !inputText.isEmpty else { return }
        messages.append(ChatMessage(text: inputText, isUser: true))
        inputText = ""
        // TODO: Add bot reply logic here later
    }
}
