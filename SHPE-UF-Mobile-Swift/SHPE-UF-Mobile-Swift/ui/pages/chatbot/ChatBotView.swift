import SwiftUI

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
    static let errorRed = Color(red: 200/255, green: 50/255, blue: 50/255)
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
    let persona: ChatPersona
    var onRetry: (() -> Void)?

    private var isFailed: Bool {
        if case .failed = message.status { return true }
        return false
    }

    private var failedMessage: String? {
        if case .failed(let msg) = message.status { return msg }
        return nil
    }

    // Applies semantic .body-relative font on every run, preserving bold/italic from markdown
    static func applySemanticFont(_ attributed: inout AttributedString) {
        for run in attributed.runs {
            let intent = run.inlinePresentationIntent ?? []
            let isBold = intent.contains(.stronglyEmphasized)
            let isItalic = intent.contains(.emphasized)
            let weight: Font.Weight = isBold ? .bold : .regular
            var font: Font = .body.weight(weight)
            if isItalic {
                font = font.italic()
            }
            attributed[run.range].font = font
        }
    }

    private var bubbleAccessibilityLabel: String {
        let sender = message.isUser ? "You said" : persona.bubbleSenderLabel
        let status = isFailed ? ", failed to send" : ""
        return "\(sender): \(message.text)\(status)"
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 0) {
                if message.isUser { Spacer(minLength: 56) }

                Group {
                    if message.isUser {
                        Text(message.text)
                            .font(.body.bold())
                            .foregroundColor(.white)
                    } else {
                        if var attributed = try? AttributedString(
                            markdown: message.text,
                            options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)
                        ) {
                            let _ = Self.applySemanticFont(&attributed)
                            Text(attributed)
                                .foregroundColor(.white)
                        } else {
                            Text(message.text)
                                .font(.body)
                                .foregroundColor(.white)
                        }
                    }
                }
                .textSelection(.enabled)
                .padding(.vertical, 14)
                .padding(.horizontal, 18)
                .background(
                    BubbleShape(isUser: message.isUser)
                        .fill(isFailed ? ChatTheme.errorRed : (message.isUser ? ChatTheme.orange : ChatTheme.userBlue))
                )
                .overlay(
                    BubbleShape(isUser: message.isUser)
                        .stroke(isFailed ? Color.red.opacity(0.4) : .white.opacity(0.12), lineWidth: isFailed ? 1.5 : 0.5)
                )
                .frame(maxWidth: min(UIScreen.main.bounds.width * 0.75, 500), alignment: message.isUser ? .trailing : .leading)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(bubbleAccessibilityLabel)
                .accessibilityHint(isFailed ? "Double tap to retry sending" : "")
                .accessibilityAddTraits(isFailed ? .isButton : [])
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

            // Error label with tap-to-retry
            if let errorMsg = failedMessage {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.caption)
                    Text(errorMsg)
                        .font(.caption)
                }
                .foregroundColor(.red)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.horizontal, 28)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(errorMsg)
                .accessibilityHint("Tap to retry")
                .accessibilityAddTraits(.isButton)
                .onTapGesture {
                    onRetry?()
                }
            }
        }
        .padding(.vertical, 4)
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

    @AppStorage("selectedPersona") private var selectedPersonaRaw: String = ChatPersona.tito.rawValue
    @State private var isNearBottom = true
    @State private var scrollProxy: ScrollViewProxy?

    private var persona: ChatPersona {
        ChatPersona(rawValue: selectedPersonaRaw) ?? .tito
    }

    private let sendHaptic = UIImpactFeedbackGenerator(style: .light)

    private var bg: Color { scheme == .dark ? ChatTheme.darkBG : ChatTheme.lightBG }

    private var sendDisabled: Bool {
        vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isLoading
    }

    var body: some View {
        ZStack {
            bg.ignoresSafeArea()

            VStack(spacing: 0) {
                header

                if vm.messages.isEmpty {
                    introView
                        .contentShape(Rectangle())
                        .onTapGesture { dismissKeyboard() }
                } else {
                    messagesList
                        .contentShape(Rectangle())
                        .onTapGesture { dismissKeyboard() }
                        .overlay(alignment: .bottomTrailing) {
                            if !isNearBottom {
                                Button(action: {
                                    scrollToBottom(animated: true)
                                }) {
                                    Image(systemName: "arrow.down.circle.fill")
                                        .font(.title)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 2)
                                }
                                .accessibilityLabel("Scroll to bottom")
                                .padding(.trailing, 12)
                                .padding(.bottom, 12)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                }
            }
        }
        .safeAreaInset(edge: .bottom) {
            inputBar
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(bg)
        }
        .animation(.easeInOut(duration: 0.2), value: vm.messages.count)
    }

    // MARK: Scroll helper
    private func scrollToBottom(animated: Bool) {
        guard let proxy = scrollProxy else { return }
        if animated {
            withAnimation(.easeOut(duration: 0.2)) {
                proxy.scrollTo("bottom-anchor", anchor: .bottom)
            }
        } else {
            proxy.scrollTo("bottom-anchor", anchor: .bottom)
        }
    }

    // Returns true if a timestamp should be shown above the message at the given index
    private func shouldShowTimestamp(at index: Int) -> Bool {
        guard index > 0 else { return true } // Always show on first message
        let current = vm.messages[index].date
        let previous = vm.messages[index - 1].date
        return current.timeIntervalSince(previous) >= 300 // 5 minutes
    }

    // MARK: Header
    private var header: some View {
        ZStack {
            ChatTheme.orange.ignoresSafeArea(edges: .top)
            HStack {
                Spacer()

                Text(persona.headerTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.white)

                Spacer()

                if !vm.messages.isEmpty {
                    Image(persona.imageName)
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
                        .accessibilityHidden(true)
                }

            } .padding(.horizontal)
        }
        .frame(height: 50)
    }

    // MARK: Intro view
    private var introView: some View {
        VStack {
            Spacer()
            Image(persona.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .shadow(radius: 6)
                .accessibilityHidden(true)

            Text(persona.introMessage)
                .font(.body.weight(.medium))
                .multilineTextAlignment(.center)
                .foregroundColor(scheme == .dark ? .white : .black)
                .padding(.top, 16)

            // Persona picker
            Picker("Persona", selection: $selectedPersonaRaw) {
                ForEach(ChatPersona.allCases, id: \.rawValue) { p in
                    Text(p.displayName).tag(p.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, 60)
            .padding(.top, 20)

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
                            // Timestamp with 5-minute gap grouping
                            if shouldShowTimestamp(at: index) {
                                Text(chatTimestampFormatter.string(from: msg.date))
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding(.vertical, 6)
                            }

                            ChatBubble(message: msg, persona: persona) {
                                vm.retry(messageID: msg.id, persona: persona.serverValue)
                            }
                            .padding(.top, previousSameAuthor ? -2 : 0)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))
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
                        .accessibilityLabel(persona.typingAccessibilityLabel)
                    }

                    Color.clear.frame(height: 12)

                    // Near-bottom detector
                    GeometryReader { geo in
                        Color.clear
                            .preference(key: BottomVisiblePreferenceKey.self,
                                        value: geo.frame(in: .named("chatScroll")).minY)
                    }
                    .frame(height: 1)
                    .id("bottom-anchor")
                }
                .frame(maxWidth: 700)
                .frame(maxWidth: .infinity)
            }
            .scrollDismissesKeyboard(.interactively)
            .coordinateSpace(name: "chatScroll")
            .onPreferenceChange(BottomVisiblePreferenceKey.self) { bottomY in
                let scrollViewHeight = UIScreen.main.bounds.height
                let nearBottomThreshold: CGFloat = 100
                let newNearBottom = bottomY < scrollViewHeight + nearBottomThreshold
                if newNearBottom != isNearBottom {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        isNearBottom = newNearBottom
                    }
                }
            }
            .background(bg)
            .onAppear {
                scrollProxy = proxy
            }
            .onChange(of: vm.messages.count) {
                if isNearBottom {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo("bottom-anchor", anchor: .bottom)
                    }
                }
            }
            .onChange(of: vm.isLoading) {
                if vm.isLoading && isNearBottom {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo("typing-indicator", anchor: .bottom)
                    }
                }
            }
        }
    }

    // Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask anything", text: $vm.inputText, axis: .vertical)
                .font(.body)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .foregroundColor(.black)
                .background(.white)
                .clipShape(Capsule())

            Button(action: {
                sendHaptic.impactOccurred()
                vm.send(persona: persona.serverValue)
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(sendDisabled ? Color.gray : ChatTheme.orange)
                    .padding(10)
            }
            .disabled(sendDisabled)
            .accessibilityLabel("Send message")
            .background(.white)
            .clipShape(Circle())
        }
    }

}

// Preference key to track the bottom anchor's Y position in the scroll coordinate space
private struct BottomVisiblePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ChatBotView()
}
