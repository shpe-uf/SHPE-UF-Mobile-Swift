import Foundation

/// The chatbot's selectable persona identity.
///
/// This enum:
/// 1. Defines the two available personas (Tito and Tina)
/// 2. Provides display strings for the UI (header, intro, accessibility labels)
/// 3. Maps to the asset catalog image name for each persona's avatar
/// 4. Supplies the exact server value sent in the GraphQL `persona` parameter
///
/// ## Data Flow
/// - Stored as a raw `String` in `@AppStorage("selectedPersona")`
/// - Read by ``ChatBotView`` to configure the UI and by ``ChatBotViewModel`` for server requests
enum ChatPersona: String, CaseIterable {
    case tito
    case tina

    /// User-facing name shown in the header, intro screen, and info sheet.
    var displayName: String {
        switch self {
        case .tito: return "Tito"
        case .tina: return "Tina"
        }
    }

    /// Asset catalog image name for the persona's avatar.
    var imageName: String {
        switch self {
        case .tito: return "tito"
        case .tina: return "tina"
        }
    }

    var headerTitle: String {
        "Ask \(displayName)"
    }

    var introMessage: String {
        "I'm \(displayName)! Ask me any questions\nabout SHPE UF!"
    }

    var typingAccessibilityLabel: String {
        "\(displayName) is typing"
    }

    var bubbleSenderLabel: String {
        "\(displayName) said"
    }

    /// Exact string the server expects ("Tito" or "Tina")
    var serverValue: String { displayName }

}
