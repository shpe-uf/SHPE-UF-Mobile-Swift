import SwiftUI

// Main view for creating and submitting new events
struct EventCreatorView: View {
    @Environment(\.dismiss) private var dismiss  // Dismisses this view when called
    @StateObject private var eventVM = EventCreatorViewModel()  // Manages form state and actions
    @StateObject var appVM: AppViewModel = AppViewModel.appVM  // Shared app settings (e.g., dark mode)

    @State private var didAttemptSave = false  // Tracks if user tapped Save for validation
    @State private var showingConfirm = false  // Controls display of confirmation alert

    var body: some View {
        ZStack {
            VStack {
                // ── HEADER: Logo and curved background ─────────────────
                ZStack {
                    Image(appVM.darkMode ? "Gator" : "Gator2")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(
                            width: UIScreen.main.bounds.width * 0.5,
                            height: UIScreen.main.bounds.height * 0.15
                        )
                        .offset(
                            x: -UIScreen.main.bounds.width * 0.42,
                            y: appVM.darkMode ? 40 : 30
                        )

                    CurvedTopRectangle(cornerRadius: 10, curveHeight: 100)
                        .fill(Color("Profile-Background"))
                        .frame(
                            width: UIScreen.main.bounds.width * 1.9,
                            height: UIScreen.main.bounds.height * 0.2
                        )
                        .padding(.top, UIScreen.main.bounds.height * 0.17)

                    Image("EVENTS")  // Title image
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.375,
                            height: UIScreen.main.bounds.height * 0.036
                        )

                    Image("Edit Event")  // Subtitle image
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.35,
                            height: UIScreen.main.bounds.width * 0.065
                        )
                        .padding(.top, UIScreen.main.bounds.height * 0.225)
                        .padding(.trailing, UIScreen.main.bounds.width * 0.52)
                }
                .frame(maxWidth: .infinity)
                .background(Color("profile-orange"))

                // ── FORM: Scrollable input fields ────────────────────────
                ScrollView {
                    InputGrid(vm: eventVM, didAttemptSave: didAttemptSave)
                        .padding(.leading, UIScreen.main.bounds.width * 0.05)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 10)
                }

                // ── BUTTONS: Cancel and Save ─────────────────────────────
                HStack(spacing: 0) {
                    // Cancel button returns to previous screen
                    Button {
                        dismiss()
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("buttonColor"))
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 160, height: 50)
                                .padding()
                            Text("Cancel")
                                .font(Font.custom("Viga-Regular", size: 25))
                                .foregroundColor(.white)
                        }
                    }

                    // Save button triggers validation and confirmation
                    Button {
                        didAttemptSave = true
                        eventVM.validateFields()  // Check for errors
                        guard eventVM.fieldErrors.isEmpty else { return }
                        showingConfirm = true
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color("buttonColor"))
                                .stroke(.white, lineWidth: 2)
                                .frame(width: 160, height: 50)
                                .padding()
                            Text("Save")
                                .font(Font.custom("Viga-Regular", size: 25))
                                .foregroundColor(.white)
                        }
                    }
                    .alert("Create Event?", isPresented: $showingConfirm) {
                        Button("Cancel", role: .cancel) {}
                        Button("Create") {
                            eventVM.createEvent()  // Call view model to send mutation
                        }
                    } message: {
                        Text("Are you sure you wish to create this event, and that all the info is accurate?")
                    }
                }
                .padding(.bottom, 30)
                .zIndex(10)
            }
            .ignoresSafeArea()
            .background(Color("Profile-Background"))  // Main background color
            .preferredColorScheme(appVM.darkMode ? .dark : .light)  // Switch theme
        }
        .navigationBarBackButtonHidden(true)  // Hide default back button
        
        // ── QR SHEET: Shows QR code after event creation ─────────────────
        .sheet(isPresented: $eventVM.showingQR) {
            VStack(spacing: 24) {
                HStack {
                    Spacer()
                    Button {
                        eventVM.showingQR = false
                        dismiss()
                    } label: {
                        ZStack {
                            Circle().fill(Color.black).frame(width: 28, height: 28)
                            Image("xMark")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                Spacer()
                
                if let qr = eventVM.qrImage {
                    Image(uiImage: qr)
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 250, height: 250)
                }

                Button("Download QR") {
                    guard let img = eventVM.qrImage else { return }
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
                .font(.headline)

                Spacer()
            }
            .padding()
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────────
// InputGrid: Lays out labeled inputs and error messages
struct InputGrid: View {
    let Categories = [
        "General Body Meeting", "Cabinet Meeting", "Workshop",
        "Form/Survey", "Social", "Corporate Event",
        "Fundraising", "Tabling", "Volunteering", "Miscellaneous"
    ]
    let ExpiresIn = ["1 hour", "2 hours", "3 hours", "4 hours"]

    @ObservedObject var vm: EventCreatorViewModel  // Shares data and errors
    let didAttemptSave: Bool  // Flag to show validation messages

    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.06) {
            // Title input and error display
            VStack(spacing: 4) {
                TextBox(
                    inputText: $vm.eventTitle,
                    name: "TITLE",
                    imageName: "list",
                    width: UIScreen.main.bounds.width * 0.7
                )
                if didAttemptSave {
                    // Show only title-related errors
                    let titleErrors = vm.fieldErrors.enumerated().filter { _, err in
                        let lower = err.lowercased()
                        return lower.contains("title")
                            || lower.contains("name")
                            || lower.contains("exists")
                    }
                    ForEach(titleErrors, id: \.offset) { _, msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }

            // Code input and error message
            VStack(spacing: 4) {
                TextBox(
                    inputText: $vm.eventCode,
                    name: "CODE",
                    imageName: "lock",
                    width: UIScreen.main.bounds.width * 0.7
                )
                if didAttemptSave,
                   let msg = vm.fieldErrors.first(where: { $0.lowercased().contains("code") }) {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // Category dropdown and validation
            VStack(spacing: 4) {
                AdminDropDown(
                    selection: $vm.eventCategory,
                    options: Categories,
                    width: UIScreen.main.bounds.width * 0.7,
                    name: "CATEGORY",
                    imageName: "list"
                )
                .zIndex(999)
                if didAttemptSave,
                   let msg = vm.fieldErrors.first(where: { $0.contains("Category") }) {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // Points input (optional)
            TextBox(
                inputText: $vm.eventPoints,
                name: "POINTS",
                imageName: "list",
                width: UIScreen.main.bounds.width * 0.3
            )

            // Expiration dropdown and error handling
            VStack(spacing: 4) {
                AdminDropDown(
                    selection: $vm.eventDate,
                    options: ExpiresIn,
                    width: UIScreen.main.bounds.width * 0.3,
                    name: "EXPIRES IN",
                    imageName: "list"
                )
                .zIndex(998)
                if didAttemptSave,
                   let msg = vm.fieldErrors.first(where: { $0.contains("Expires") }) {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
        }
        .padding(.bottom, 10)
    }
}

// ────────────────────────────────────────────────────────────────────────────────
// TextBox: Custom text field with a title label and bottom border
struct TextBox: View {
    @Binding var inputText: String  // Two-way binding to view model
    var name: String  // Field label
    var imageName: String  // Icon name
    var width: CGFloat  // Field width

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(imageName)
                    .renderingMode(.original)
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width * 0.08,
                        height: UIScreen.main.bounds.height * 0.035
                    )
                    .padding(.trailing, 4)
                Text(name)
                    .font(Font.custom("Viga-Regular", size: 26))
                    .foregroundStyle(Color("profile-orange"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            TextField("", text: $inputText)
                .frame(width: width)
                .overlay(
                    Rectangle()
                        .frame(width: width, height: 1),  // Underline
                    alignment: .bottomLeading
                )
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────────
// AdminDropDown: Expandable list for selecting one option
struct AdminDropDown: View {
    @Binding var selection: String  // Current selection
    let options: [String]  // Items to choose from
    let width: CGFloat  // Dropdown width
    var name: String  // Label above dropdown
    var imageName: String  // Icon next to label
    @State private var isExpanded = false  // Controls list visibility

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Image(imageName)
                    .renderingMode(.original)
                    .resizable()
                    .frame(width: 24, height: 24)
                Text(name)
                    .font(Font.custom("Viga-Regular", size: 26))
                    .foregroundStyle(Color("profile-orange"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 8)

            HStack {
                Text(selection.isEmpty ? "" : selection)
                    .foregroundStyle(selection.isEmpty ? Color.gray : Color.primary)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(isExpanded ? .degrees(180) : .zero)
                    .foregroundColor(.gray)
            }
            .frame(width: width)
            .contentShape(Rectangle())
            .onTapGesture { withAnimation(.easeInOut) { isExpanded.toggle() } }
            .overlay(
                Rectangle().frame(height: 1),
                alignment: .bottom
            )

            if isExpanded {
                ScrollView {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("lightGray"))
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(options, id: \.self) { opt in
                                Text(opt)
                                    .font(.system(size: 16))
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 12)
                                    .onTapGesture {
                                        selection = opt  // Update selected value
                                        isExpanded = false
                                    }
                            }
                        }
                    }
                }
                .frame(width: width, height: min(CGFloat(options.count) * 45, 165))
                .cornerRadius(10)
            }
        }
    }
}

#Preview {
    EventCreatorView()
}
