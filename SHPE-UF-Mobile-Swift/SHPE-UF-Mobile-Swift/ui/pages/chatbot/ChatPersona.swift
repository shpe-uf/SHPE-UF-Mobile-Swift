import Foundation

enum ChatPersona: String, CaseIterable {
    case tito
    case tina

    var displayName: String {
        switch self {
        case .tito: return "Tito"
        case .tina: return "Tina"
        }
    }

    var imageName: String {
        switch self {
        case .tito: return "tito"
        case .tina: return "shpe_logo" // Filler — replace with real Tina asset later
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
