import SwiftUI
import Combine

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
        var path = Path(roundedRect: rect, cornerRadius: 22)
        let w: CGFloat = 10, h: CGFloat = 8
        if isUser {
            path.move(to: CGPoint(x: rect.maxX - 18, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.maxX - 18 - w, y: rect.maxY - h))
            path.addLine(to: CGPoint(x: rect.maxX - 34, y: rect.maxY))
        } else {
            path.move(to: CGPoint(x: rect.minX + 18, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 18 + w, y: rect.maxY - h))
            path.addLine(to: CGPoint(x: rect.minX + 34, y: rect.maxY))
        }
        path.closeSubpath()
        return path
    }
}

// MARK: - Bubble
private struct ChatBubble: View {
    let message: ChatMessage

    var body: some View {
        HStack(spacing: 0) {
            if message.isUser { Spacer(minLength: 56) }

            Text(message.text)
                .font(.system(size: 18))
                .foregroundColor(.white)
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
                .background(
                    BubbleShape(isUser: message.isUser)
                        .fill(message.isUser ? ChatTheme.orange : ChatTheme.userBlue)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22)
                        .stroke(.white.opacity(0.12), lineWidth: 0.5)
                )
                .frame(maxWidth: .infinity, alignment: message.isUser ? .trailing : .leading)
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
    @Environment(\.colorScheme) private var scheme
    @StateObject private var vm = ChatboxViewModel()
    @StateObject private var kb = KeyboardObserver()

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
            if appeared { vm.messages = vm.messages } // trigger scroll after keyboard shows
        }
        .animation(.easeInOut(duration: 0.2), value: vm.messages.count) // fade avatar/intro changes
    }

    // MARK: Header (title always centered; small Tito appears after first prompt)
    private var header: some View {
        ZStack {
            ChatTheme.orange.ignoresSafeArea(edges: .top)

            Text("Ask Tito")
                .font(.system(size: 22, weight: .semibold))
                .foregroundColor(.white)

            HStack {
                Spacer()
                if !vm.messages.isEmpty {
                    Image("tito")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .transition(.opacity)
                        .padding(.trailing, 12)
                } else {
                    // reserve space so the centered title doesn't shift
                    Color.clear.frame(width: 32, height: 32).padding(.trailing, 12)
                }
            }
        }
        .frame(height: 50)
    }

    // MARK: Intro Tito view (shown before first prompt)
    private var introView: some View {
        VStack {
            Spacer()
            Image("tito")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .shadow(radius: 6)

            Text("I’m Tito! Ask me any questions\nabout SHPE UF!")
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

                    ForEach(vm.messages) { msg in
                        ChatBubble(message: msg).id(msg.id)
                    }

                    if vm.messages.count >= 2 {
                        HStack {
                            Spacer(minLength: 56)
                            Button {} label: {
                                Text("Follow up with EBoard")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 18)
                                    .background(
                                        RoundedRectangle(cornerRadius: 28).fill(ChatTheme.orange)
                                    )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.vertical, 8)
                    }

                    Color.clear.frame(height: 12)
                }
            }
            .background(bg)
            .onChange(of: vm.messages.count) { _ in
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                }
            }
        }
    }


    // Input bar (capsule + send button)
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
        // extra keyboard toolbar with a dismiss button (nice UX)
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
