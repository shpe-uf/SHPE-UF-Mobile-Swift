//
//  ChatBotView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Mazin Saleh on 9/19/25.
//

// ChatBotView.swift

import SwiftUI

// MARK: - Chat Message Model
struct ChatMessage: Identifiable {
    let id = UUID()
    let text: String
    let isUser: Bool
}

// MARK: - Chat Bubble
struct ChatBubble: View {
    let message: ChatMessage
    let colorScheme: ColorScheme

    var body: some View {
        HStack {
            if message.isUser { Spacer() }
            Text(message.text)
                .padding(12)
                .background(message.isUser ? Color("AccentOrange") : Color("AccentBlue"))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .frame(maxWidth: UIScreen.main.bounds.width * 0.7,
                       alignment: message.isUser ? .trailing : .leading)
            if !message.isUser { Spacer() }
        }
        .id(message.id) // for auto-scroll
    }
}

// MARK: - ChatBotView
struct ChatBotView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var vm = ChatboxViewModel()

    var body: some View {
        VStack(spacing: 0) {
            
            // Header
            HStack {
                Button(action: {
                    // Optional: handle tab switch back if needed
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                Spacer()
                Text("Ask Tito")
                    .font(.headline)
                    .foregroundColor(.white)
                Spacer()
                Image("tito_avatar") // Replace with your asset
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
            .padding()
            .background(Color("AccentOrange"))
            
            // Messages
            ScrollView {
                ScrollViewReader { proxy in
                    VStack(spacing: 12) {
                        ForEach(vm.messages) { message in
                            ChatBubble(message: message, colorScheme: colorScheme)
                                .padding(message.isUser ? .leading : .trailing, 60)
                                .padding(.horizontal, 10)
                        }
                    }
                    .padding(.vertical)
                    .onChange(of: vm.messages.count) { _ in
                        withAnimation {
                            proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                        }
                    }
                }
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            
            // Input Bar
            HStack {
                TextField("Ask anything", text: $vm.inputText, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(10)
                    .background(Color(.systemGray6))
                    .clipShape(Capsule())

                Button(action: vm.sendMessage) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color("AccentOrange"))
                }
                .padding(.leading, 8)
            }
            .padding()
            .background(colorScheme == .dark ? Color.black : Color.white)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ChatBotView()
}
