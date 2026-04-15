import SwiftUI
import Combine

// Helper to format timestamps
private let chatTimestampFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    df.dateStyle = .none
    return df
}()

// MARK: - Typing dots (pulsing)
private struct TypingDots: View {
    @State private var animate = false

    var body: some View {
        HStack(spacing: 6) {
            Circle().frame(width: 6, height: 6)
                .opacity(animate ? 1.0 : 0.3)
                .animation(.easeInOut(duration: 0.8).repeatForever().delay(0.0), value: animate)
            Circle().frame(width: 6, height: 6)
                .opacity(animate ? 1.0 : 0.3)
                .animation(.easeInOut(duration: 0.8).repeatForever().delay(0.2), value: animate)
            Circle().frame(width: 6, height: 6)
                .opacity(animate ? 1.0 : 0.3)
                .animation(.easeInOut(duration: 0.8).repeatForever().delay(0.4), value: animate)
        }
        .foregroundColor(.white.opacity(0.9))
        .onAppear { animate = true }
    }
}

// MARK: - Theme
private struct ChatTheme {
    static let orange  = Color(red: 210/255, green: 89/255,  blue: 23/255) // #D25917
    static let darkBG  = Color(red:   1/255, green: 31/255,  blue: 53/255) // #011F35
    static let lightBG = Color(white: 0.97)
    static let userBlue = Color(red: 24/255, green: 120/255, blue: 201/255)
}

// MARK: - Bubble tail
private struct BubbleShape: Shape {
    var isUser: Bool
    func path(in rect: CGRect) -> Path {
        return Path(roundedRect: rect, cornerRadius: 22)
    }
}

// MARK: - Bubble
private struct ChatBubble: View {
    let message: ChatMessage

    private var bubbleColor: Color {
        message.isUser ? ChatTheme.orange : ChatTheme.userBlue
    }

    var body: some View {
        HStack(spacing: 0) {
            if message.isUser { Spacer(minLength: 56) }

            Group {
                if message.isUser {
                    Text(message.text)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                } else {
                    if let attributed = try? AttributedString(markdown: message.text) {
                        Text(attributed)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    } else {
                        Text(message.text)
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
            .textSelection(.enabled)
            .padding(.vertical, 14)
            .padding(.horizontal, 18)
            .background(
                BubbleShape(isUser: message.isUser)
                    .fill(message.isUser ? ChatTheme.orange : ChatTheme.userBlue)
            )
            .overlay(
                BubbleShape(isUser: message.isUser)
                    .stroke(.white.opacity(0.12), lineWidth: 0.5)
            )
            .frame(maxWidth: min(UIScreen.main.bounds.width * 0.75, 500), alignment: message.isUser ? .trailing : .leading)
            .contextMenu {
                Button(action: {
                    UIPasteboard.general.string = message.text
                }) {
                    Label("Copy", systemImage: "doc.on.doc")
                }
            }
            .padding(.horizontal, 20)

            if !message.isUser { Spacer(minLength: 56) }
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Keyboard observer
private final class KeyboardObserver: ObservableObject {
    @Published var isVisible = false
    private var cancellables: Set<AnyCancellable> = []

    init() {
        let nc = NotificationCenter.default
        nc.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in self?.isVisible = true }
            .store(in: &cancellables)

        nc.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in self?.isVisible = false }
            .store(in: &cancellables)
    }
}

private extension View {
    func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}

// MARK: - Chat screen
struct ChatBotView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var scheme
    @StateObject private var vm = ChatboxViewModel()
    @StateObject private var kb = KeyboardObserver()

    @State private var showScrollToBottom = false
    @State private var lastVisibleMessageID: UUID?

    private var bg: Color { scheme == .dark ? ChatTheme.darkBG : ChatTheme.lightBG }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if vm.messages.isEmpty {
                    introView
                } else {
                    messagesList
                        .contentShape(Rectangle())
                        .onTapGesture { dismissKeyboard() }
                        .overlay(alignment: .bottomTrailing) {
                            if showScrollToBottom {
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        showScrollToBottom = false
                                    }
                                    NotificationCenter.default.post(name: Notification.Name("ChatBotScrollToBottom"), object: nil)
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundStyle(.white)
                                        .shadow(radius: 2)
                                }
                                .padding(.trailing, 12)
                                .padding(.bottom, 12)
                                .background(
                                    Circle().fill(Color.black.opacity(0.001))
                                )
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .gesture(DragGesture().onChanged { _ in
                            showScrollToBottom = true
                        }.onEnded { _ in
                        })
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            inputBar
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(bg)
        }
        .onChange(of: kb.isVisible) { appeared in
            if appeared { vm.messages = vm.messages }
        }
        .animation(.easeInOut(duration: 0.2), value: vm.messages.count)
    }

    // MARK: Header
    private var header: some View {
        ZStack {
            ChatTheme.orange.ignoresSafeArea(edges: .top)
            HStack {
                Button(action: { dismiss() }){
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                }
                
                Spacer()

                Text("Ask Tito")
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if !vm.messages.isEmpty {
                    Image("tito")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                        .background(
                            Circle()
                                .fill(.orangeButton)
                        )
                        .overlay(
                            Circle()
                                .stroke(.white)
                            )
                        .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                }

            } .padding(.horizontal)
        }
        .frame(height: 50)
    }

    // MARK: Intro Tito view
    private var introView: some View {
        VStack {
            Spacer()
            Image("tito")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .shadow(radius: 6)

            Text("I'm Tito! Ask me any questions\nabout SHPE UF!")
                .font(.system(size: 18, weight: .medium))
                .multilineTextAlignment(.center)
                .foregroundColor(scheme == .dark ? .white : .black)
                .padding(.top, 16)
            Spacer()
        }
    }

    // MARK: Messages list
    private var messagesList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 12)

                    ForEach(vm.messages.indices, id: \.self) { index in
                        let msg = vm.messages[index]
                        let previousSameAuthor: Bool = {
                            guard index > 0 else { return false }
                            return vm.messages[index - 1].isUser == msg.isUser
                        }()
                        VStack(spacing: 0) {
                            ChatBubble(message: msg)
                                .padding(.top, previousSameAuthor ? -2 : 0)
                            Text(chatTimestampFormatter.string(from: msg.date))
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: msg.isUser ? .trailing : .leading)
                                .padding(.horizontal, 28)
                                .padding(.top, 2)
                        }
                    }

                    if vm.isLoading {
                        HStack(spacing: 0) {
                            TypingDots()
                                .frame(height: 18)
                                .padding(.vertical, 16)
                                .padding(.horizontal, 18)
                                .background(
                                    BubbleShape(isUser: false)
                                        .fill(ChatTheme.userBlue)
                                )
                                .overlay(
                                    BubbleShape(isUser: false)
                                        .stroke(.white.opacity(0.12), lineWidth: 0.5)
                                )
                                .padding(.horizontal, 20)

                            Spacer(minLength: 56)
                        }
                        .padding(.vertical, 4)
                        .id("typing-indicator")
                        .transition(.opacity)
                        .zIndex(1)
                    }

                    Color.clear.frame(height: 12)
                    Color.clear.frame(height: 1).id("bottom-anchor").onAppear {
                        showScrollToBottom = false
                    }
                }
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .background(bg)
            .onAppear {
                lastVisibleMessageID = vm.messages.last?.id
            }
            .onChange(of: vm.messages.count) { _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                    showScrollToBottom = false
                }
            }
            .onChange(of: vm.isLoading) { appeared in
                if appeared {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo("typing-indicator", anchor: .bottom)
                    }
                    showScrollToBottom = false
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ChatBotScrollToBottom"))) { _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                }
            }
        }
    }

    // Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask anything", text: $vm.inputText, axis: .vertical)
                .font(.system(size: 17))
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .foregroundColor(.black)
                .background(.white)
                .clipShape(Capsule())

            Button(action: vm.send) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(ChatTheme.orange)
                    .padding(10)
            }
            .background(.white)
            .clipShape(Circle())
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { dismissKeyboard() }
            }
        }
    }

}

#Preview {
    ChatBotView()
}
