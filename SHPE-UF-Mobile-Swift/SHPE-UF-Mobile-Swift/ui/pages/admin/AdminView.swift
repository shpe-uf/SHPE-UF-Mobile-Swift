import SwiftUI

// Main admin panel screen
struct AdminView: View {
    @Environment(\.dismiss) private var dismiss  // Close this view

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.darkdarkBlue)  // Background color
                    .ignoresSafeArea(edges: .all)

                VStack {
                    // ── HEADER: Back button and title ──────────────────
                    HStack {
                        Button {
                            // Return to previous view
                            dismiss()
                        } label: {
                            Image("Back")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(.trailing, UIScreen.main.bounds.width * 0.10)
                        }

                        Text("Admin Panel")  // Screen title
                            .font(.custom("Viga-Regular", size: 28))
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                            .padding(.trailing, UIScreen.main.bounds.width * 0.20)
                    }
                    .padding(UIScreen.main.bounds.width * 0.05)

                    // ── GRID OF ADMIN OPTIONS ─────────────────────────
                    ButtonGrid()
                }
            }
        }
    }
}

// Grid layout for admin action buttons
struct ButtonGrid: View {
    var body: some View {
        ScrollView {
            VStack(spacing: UIScreen.main.bounds.height * 0.035) {
                // Two buttons per row
                HStack {
                    AdminButton(symbol: "Event", label: "Events", color: .adminBlue, enabled: true)
                    Spacer()
                    AdminButton(symbol: "dark_customer", label: "Members", color: .adminBlue)
                }
                HStack {
                    AdminButton(symbol: "Resources", label: "Resources", color: .adminOrange)
                    Spacer()
                    AdminButton(symbol: "Requests", label: "Requests", color: .adminOrange)
                }
                HStack {
                    AdminButton(symbol: "Stat", label: "Statistics", color: .adminBlue)
                    Spacer()
                    AdminButton(symbol: "Database", label: "Corporate Database", color: .adminBlue)
                }
                HStack {
                    AdminButton(symbol: "Money", label: "Reimburse", color: .adminOrange)
                    Spacer()
                    AdminButton(symbol: "Key", label: "SHPE Rentals", color: .adminOrange)
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.070)
        }
    }
}

// Styled button representing an admin action
struct AdminButton: View {
    var symbol: String   // Icon image name
    var label: String    // Button text
    var color: Color     // Background color
    var enabled: Bool = false  // If true, navigates on tap

    // Layout dimensions
    var recWidth:  CGFloat = UIScreen.main.bounds.width  * 0.40
    var recHeight: CGFloat = UIScreen.main.bounds.height * 0.17
    var frameWidth:  CGFloat = UIScreen.main.bounds.width  * 0.1
    var frameHeight: CGFloat = UIScreen.main.bounds.height * 0.05

    var body: some View {
        if enabled {
            // Enabled button uses NavigationLink
            NavigationLink(destination: destinationSelector(label: label)) {
                buttonContent
            }
        } else {
            // Disabled button is dimmed
            buttonContent
                .opacity(0.4)
        }
    }

    // Common button content
    private var buttonContent: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: recWidth, height: recHeight)
            VStack {
                Image(symbol)  // Icon
                    .resizable()
                    .frame(width: frameWidth, height: frameHeight)
                    .padding(.top, UIScreen.main.bounds.height * 0.015)

                Text(label)  // Label text
                    .font(.custom("Viga-Regular", size: 26))
                    .foregroundColor(.white)
            }
        }
    }
}

// Selects destination view based on button label
@ViewBuilder
func destinationSelector(label: String) -> some View {
    switch label {
    case "Events":
        EventCreatorView()  // Shows event creation form
    default:
        AdminView()  // Fallback to admin panel
    }
}

#Preview {
    AdminView()
}
