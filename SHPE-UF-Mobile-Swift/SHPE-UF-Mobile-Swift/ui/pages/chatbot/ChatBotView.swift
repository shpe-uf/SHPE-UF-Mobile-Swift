import SwiftUI

/// Formats bubble timestamps as time-only (e.g. "2:45 PM").
private let chatTimestampFormatter: DateFormatter = {
    let df = DateFormatter()
    df.timeStyle = .short
    df.dateStyle = .none
    return df
}()

/// Three pulsing dots shown while waiting for the bot's response.
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

/// Shared color palette for the chatbot screen.
private struct ChatTheme {
    static let orange  = Color(red: 210/255, green: 89/255,  blue: 23/255) // #D25917
    static let darkBG  = Color(red:   1/255, green: 31/255,  blue: 53/255) // #011F35
    static let lightBG = Color(white: 0.97)
    static let userBlue = Color(red: 24/255, green: 120/255, blue: 201/255)
    static let errorRed = Color(red: 200/255, green: 50/255, blue: 50/255)
}

// MARK: - Bubble shape
private let bubbleShape = RoundedRectangle(cornerRadius: 22)

/// A single chat bubble in the message list.
///
/// This view:
/// 1. Renders user messages with bold white text on an orange background
/// 2. Renders bot messages with inline markdown (bold, italic, links) on a blue background
/// 3. Shows a tap-to-retry error label when a message fails to send
///
/// ## Key Components
/// - Markdown parsing via `AttributedString` with per-run font application
/// - Context menu with Copy and Share actions
/// - VoiceOver accessibility labels for each bubble
private struct ChatBubble: View {
    let message: ChatMessage
    let persona: ChatPersona
    let maxBubbleWidth: CGFloat
    var onRetry: (() -> Void)?

    private var isFailed: Bool {
        if case .failed = message.status { return true }
        return false
    }

    private var failedMessage: String? {
        if case .failed(let msg) = message.status { return msg }
        return nil
    }

    /// Applies `.body`-relative font to every run in an `AttributedString`, preserving bold/italic from markdown parsing.
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
                                .tint(Color(red: 1.0, green: 0.85, blue: 0.4)) // Yellow links visible on blue bubble
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
                    bubbleShape
                        .fill(isFailed ? ChatTheme.errorRed : (message.isUser ? ChatTheme.orange : ChatTheme.userBlue))
                )
                .overlay(
                    bubbleShape
                        .stroke(isFailed ? Color.red.opacity(0.4) : .white.opacity(0.12), lineWidth: isFailed ? 1.5 : 0.5)
                )
                .frame(maxWidth: maxBubbleWidth, alignment: message.isUser ? .trailing : .leading)
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
                    ShareLink(item: message.text) {
                        Label("Share", systemImage: "square.and.arrow.up")
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

/// The main chatbot screen for interacting with the SHPE UF AI assistant.
///
/// This view:
/// 1. Presents a persona picker (Tito/Tina) on the intro screen
/// 2. Displays a scrollable message list with user and bot bubbles
/// 3. Provides a text input bar with send-on-tap and send-on-Return
/// 4. Shows a typing indicator while waiting for the server response
/// 5. Offers an info sheet describing the bot's capabilities
///
/// ## Key Components
/// - Floating avatar that animates from intro center to header corner on first send
/// - ``ChatBubble`` with inline markdown rendering, context menu (copy/share), and tap-to-retry
/// - ``TypingDots`` pulsing indicator during loading
/// - ``ChatTheme`` shared color palette
///
/// ## Data Flow
/// - Uses ``ChatBotViewModel`` as state object for messages, sending, and persistence
/// - Persona selection persisted via `@AppStorage("selectedPersona")`
/// - Conversations stored in `UserDefaults` (up to 100 messages)
///
/// ## Example Usage
/// ```swift
/// ChatBotView()
/// ```
struct ChatBotView: View {
    @Environment(\.colorScheme) private var scheme
    @StateObject private var vm = ChatBotViewModel()

    @AppStorage("selectedPersona") private var selectedPersonaRaw: String = ChatPersona.tito.rawValue
    @State private var isNearBottom = true
    @State private var scrollProxy: ScrollViewProxy?
    @State private var showClearAlert = false
    @State private var showInfoSheet = false

    private var persona: ChatPersona {
        ChatPersona(rawValue: selectedPersonaRaw) ?? .tito
    }

    private let sendHaptic = UIImpactFeedbackGenerator(style: .light)
    private let receiveHaptic = UINotificationFeedbackGenerator()

    private var bg: Color { scheme == .dark ? ChatTheme.darkBG : ChatTheme.lightBG }

    private var sendDisabled: Bool {
        vm.inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || vm.isLoading
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                bg.ignoresSafeArea()

                VStack(spacing: 0) {
                    header

                    if vm.messages.isEmpty {
                        introView
                            .contentShape(Rectangle())
                            .onTapGesture { dismissKeyboard() }
                    } else {
                        messagesList(screenWidth: geometry.size.width, screenHeight: geometry.size.height)
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

                // Single floating avatar — animates between intro center and header top-right
                floatingAvatar
            }
            .safeAreaInset(edge: .bottom) {
                inputBar
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(bg)
            }
            .animation(.easeInOut(duration: 0.8), value: vm.messages.count)
            .sheet(isPresented: $showInfoSheet) {
                infoSheet
            }
        }
    }

    private func performSend() {
        vm.send(persona: persona.serverValue)
        dismissKeyboard()
    }

    /// Scrolls the message list to the bottom anchor, optionally animated.
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

    /// Returns `true` if a timestamp divider should appear above the message at `index` (5-minute gap threshold).
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
                Button(action: {
                    showInfoSheet = true
                }) {
                    Image(systemName: "info.circle")
                        .foregroundColor(.white.opacity(0.85))
                        .frame(width: 36, height: 36)
                }
                .accessibilityLabel("About \(persona.displayName), opens info sheet")

                if !vm.messages.isEmpty {
                    Button(action: {
                        showClearAlert = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.white.opacity(0.85))
                            .frame(width: 36, height: 36)
                    }
                    .accessibilityLabel("Clear conversation")
                    .alert("Clear Conversation", isPresented: $showClearAlert) {
                        Button("Clear", role: .destructive) {
                            withAnimation {
                                vm.messages.removeAll()
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Are you sure you want to clear this conversation?")
                    }
                }

                Spacer()

                Text(persona.headerTitle)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.white)

                Spacer()

                // Balance left side: info (36) always + trash (36) when messages exist
                // Right side: avatar (36) when messages exist
                // Extra clear space to keep title centered
                if !vm.messages.isEmpty {
                    Color.clear.frame(width: 72, height: 36)
                } else {
                    Color.clear.frame(width: 36, height: 36)
                }

            } .padding(.horizontal)
        }
        .frame(height: 50)
    }

    /// Whether the intro screen (no messages yet) is showing.
    private var isIntro: Bool { vm.messages.isEmpty }

    /// Single avatar that animates between the intro center (160pt) and the header top-right (36pt).
    private var floatingAvatar: some View {
        let size: CGFloat = isIntro ? 160 : 36
        return Image(persona.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: size, height: size)
            .clipShape(Circle())
            .shadow(radius: isIntro ? 6 : 0)
            .overlay(
                Circle()
                    .stroke(.white, lineWidth: isIntro ? 0 : 1)
                    .opacity(isIntro ? 0 : 1)
            )
            .background(
                Circle()
                    .fill(Color(.orangeButton))
                    .opacity(isIntro ? 0 : 1)
            )
            .shadow(color: .black.opacity(isIntro ? 0 : 0.3), radius: 8, x: 0, y: 4)
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: isIntro ? .center : .topTrailing)
            .offset(y: isIntro ? -60 : 7)
            .padding(.trailing, isIntro ? 0 : 16)
            .accessibilityHidden(true)
            .allowsHitTesting(false)
    }

    // MARK: Intro view
    private var introView: some View {
        VStack {
            Spacer()
            // Avatar space — actual image is in the floating overlay
            Color.clear.frame(width: 160, height: 160)

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
    private func messagesList(screenWidth: CGFloat, screenHeight: CGFloat) -> some View {
        let maxBubbleWidth = min(screenWidth * 0.75, 500)
        return ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 12)

                    ForEach(Array(vm.messages.enumerated()), id: \.element.id) { index, msg in
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

                            ChatBubble(message: msg, persona: persona, maxBubbleWidth: maxBubbleWidth) {
                                sendHaptic.impactOccurred()
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
                                    bubbleShape
                                        .fill(ChatTheme.userBlue)
                                )
                                .overlay(
                                    bubbleShape
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
                let nearBottomThreshold: CGFloat = 10
                let newNearBottom = bottomY < screenHeight + nearBottomThreshold
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
                // Auto-scroll when the user sends a message and dismiss keyboard
                guard let last = vm.messages.last, last.isUser else { return }
                dismissKeyboard()
                withAnimation(.easeOut(duration: 0.2)) {
                    proxy.scrollTo("bottom-anchor", anchor: .bottom)
                }
            }
            .onChange(of: vm.isLoading) {
                if vm.isLoading {
                    withAnimation(.easeOut(duration: 0.2)) {
                        proxy.scrollTo("typing-indicator", anchor: .bottom)
                    }
                } else {
                    // Bot reply just arrived
                    receiveHaptic.notificationOccurred(.success)
                }
            }
        }
    }

    // Input bar
    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask anything", text: $vm.inputText, axis: .vertical)
                .font(.body)
                .lineLimit(1...5)
                .padding(.vertical, 10)
                .padding(.horizontal, 14)
                .foregroundColor(.primary)
                .background(scheme == .dark ? Color(.systemGray5) : .white)
                .clipShape(Capsule())
                .onChange(of: vm.inputText) {
                    // Send on Return key (detect newline insertion)
                    if vm.inputText.contains("\n") {
                        vm.inputText = vm.inputText.replacingOccurrences(of: "\n", with: "")
                        guard !sendDisabled else { return }
                        sendHaptic.impactOccurred()
                        performSend()
                        return
                    }
                    if vm.inputText.count > 500 {
                        vm.inputText = String(vm.inputText.prefix(500))
                    }
                }

            Button(action: {
                sendHaptic.impactOccurred()
                performSend()
            }) {
                Image(systemName: "paperplane.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(sendDisabled ? Color.gray : ChatTheme.orange)
                    .padding(10)
            }
            .disabled(sendDisabled)
            .accessibilityLabel("Send message")
            .background(scheme == .dark ? Color(.systemGray5) : .white)
            .clipShape(Circle())
        }
    }

    // MARK: Info sheet
    private var infoSheet: some View {
        let name = persona.displayName
        return NavigationStack {
            ZStack {
                bg.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // Persona avatar centered at top
                        HStack {
                            Spacer()
                            Image(persona.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(ChatTheme.orange, lineWidth: 2))
                                .shadow(radius: 4)
                            Spacer()
                        }
                        .padding(.top, 8)

                        Text("About \(name)")
                            .font(.title2.bold())
                            .foregroundColor(scheme == .dark ? .white : .primary)

                        Text("Your SHPE UF assistant — chapter info, career help, and life at UF.")
                            .foregroundColor(scheme == .dark ? .white.opacity(0.85) : .primary)

                        infoSection(title: "What I can do:", items: [
                            "Look up events from the official calendar",
                            "Link you to SHPE docs, Linktree, and Instagram",
                            "Help with resumes, interviews, networking, and picking a major"
                        ])

                        infoSection(title: "What I can't do:", items: [
                            "Code, math, or homework",
                            "Essays, translations, or creative writing",
                            "Anything outside SHPE, UF, or careers"
                        ])

                        Text("Tap the trash icon to clear your chat.")
                            .foregroundColor(.secondary)
                            .font(.footnote)
                    }
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                }
            }
            .navigationTitle("About \(name)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showInfoSheet = false
                    }
                }
            }
        }
    }

    private func infoSection(title: String, items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.body.bold())
                .foregroundColor(ChatTheme.orange)
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 8) {
                    Text("•")
                        .foregroundColor(ChatTheme.orange)
                    Text(item)
                        .foregroundColor(scheme == .dark ? .white.opacity(0.85) : .primary)
                }
            }
        }
    }

}

/// Tracks the bottom anchor's Y position in the scroll coordinate space to detect near-bottom state.
private struct BottomVisiblePreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    ChatBotView()
}
