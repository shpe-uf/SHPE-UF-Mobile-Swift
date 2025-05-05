import SwiftUI

struct EventCreatorView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var eventVM = EventCreatorViewModel()
    @StateObject var appVM: AppViewModel = AppViewModel.appVM

    @State private var showPopup: Bool = false
    @State private var didAttemptSave: Bool = false

    var body: some View {
        ZStack {
            VStack {
                // ── HEADER ─────────────────────────────────────────────────────
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

                    Image("EVENTS")
                        .resizable()
                        .frame(
                            width: UIScreen.main.bounds.width * 0.375,
                            height: UIScreen.main.bounds.height * 0.036
                        )

                    Image("Edit Event")
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

                // ── FORM ───────────────────────────────────────────────────────
                ScrollView {
                    InputGrid(vm: eventVM, didAttemptSave: didAttemptSave)
                        .padding(.leading, UIScreen.main.bounds.width * 0.05)
                        .frame(width: UIScreen.main.bounds.width)
                        .padding(.bottom, 10)
                }

                // ── BUTTONS ─────────────────────────────────────────────────────
                HStack(spacing: 0) {
                    // Cancel
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

                    // Save → dry‐run uniqueness and only then show Confirm
                    Button {
                        didAttemptSave = true
                        eventVM.validateFields()
                        guard eventVM.fieldErrors.isEmpty else { return }

                        // Dry‐run check on server (request:"false")
                        eventVM.createEvent(requestFlag: "false") {
                            showPopup = true
                        }
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
                }
                .padding(.bottom, 30)
                .zIndex(10)
            }
            .ignoresSafeArea()
            .background(Color("Profile-Background"))
            .preferredColorScheme(appVM.darkMode ? .dark : .light)
            .blur(radius: showPopup ? 5 : 0)

            // ── CONFIRM POP-UP ─────────────────────────────────────────────
            if showPopup {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showPopup = false } }

                ConfirmPopUp(isShowing: $showPopup, vm: eventVM)
                    .zIndex(20)
            }
        }
        .navigationBarBackButtonHidden(true)
        // ── QR SHEET ────────────────────────────────────────────────────
        .sheet(isPresented: $eventVM.showingQR) {
            VStack(spacing: 24) {
                // Close + pop to admin
                HStack {
                    Spacer()
                    Button {
                        eventVM.showingQR = false
                        dismiss()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color.black)
                                .frame(width: 28, height: 28)
                            Image("xMark")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // QR image
                if let qr = eventVM.qrImage {
                    Image(uiImage: qr)
                        .resizable()
                        .interpolation(.none)
                        .frame(width: 200, height: 200)
                }

                // Download
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
// ConfirmPopUp
// ConfirmPopUp
struct ConfirmPopUp: View {
    @Binding var isShowing: Bool
    @ObservedObject var vm: EventCreatorViewModel

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("profile-orange"))
                .frame(width: 300, height: 400)

            VStack(spacing: 16) {
                HStack {
                    Spacer()
                    Button {
                        isShowing = false
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

                Text("Create Event?")
                    .font(Font.custom("Viga-Regular", size: 28))
                    .foregroundColor(.white)
                    .bold()

                Text("Are you sure you wish to create this event, and that all the info is accurate?")
                    .font(Font.custom("Viga-Regular", size: 16))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .frame(width: 260)
                    .fixedSize(horizontal: false, vertical: true)

                Image("DefaultPFPL")
                    .resizable()
                    .frame(width: 100, height: 100)

                // Real‐write on confirm
                Button {
                    vm.createEvent(requestFlag: "true") {
                        isShowing = false
                    }
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("buttonColor"))
                            .frame(width: 140, height: 40)
                        Text("Create")
                            .font(Font.custom("Viga-Regular", size: 25))
                            .foregroundColor(.white)
                    }
                }
                .padding(.top, 8)

                Spacer()
            }
            .padding(.top, 16)
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────────
// InputGrid (with didAttemptSave, updated widths & error logic)
struct InputGrid: View {
    let Categories = [
        "General Body Meeting",
        "Cabinet Meeting",
        "Workshop",
        "Form/Survey",
        "Social",
        "Corporate Event",
        "Fundraising",
        "Tabling",
        "Volunteering",
        "Miscellaneous"
    ]
    let ExpiresIn = [
        "1 hour",
        "2 hours",
        "3 hours",
        "4 hours"
    ]

    @ObservedObject var vm: EventCreatorViewModel
    let didAttemptSave: Bool

    var body: some View {
        VStack(spacing: UIScreen.main.bounds.height * 0.06) {
            // ── TITLE + ERROR ─────────────────────────────
            // ── TITLE + ERROR ─────────────────────────────
            // ── TITLE + ERROR ─────────────────────────────
            VStack(spacing: 4) {
                TextBox(
                    inputText: $vm.eventTitle,
                    name: "TITLE",
                    imageName: "list",
                    width: UIScreen.main.bounds.width * 0.7
                )

                // only after Save was tapped...
                if didAttemptSave {
                    // collect all errors that apply to Title
                    let titleErrors = vm.fieldErrors.filter { err in
                        let lower = err.lowercased()
                        return lower.contains("title")
                            || lower.contains("name")
                            || lower.contains("exists")
                    }

                    // render each one under the box
                    ForEach(titleErrors, id: \.self) { msg in
                        Text(msg)
                            .foregroundColor(.red)
                            .font(.caption)
                    }
                }
            }




            // ── CODE + ERROR ──────────────────────────────
            VStack(spacing: 4) {
                TextBox(
                    inputText: $vm.eventCode,
                    name: "CODE",
                    imageName: "lock",
                    width: UIScreen.main.bounds.width * 0.7
                )
                if didAttemptSave,
                   let msg = vm.fieldErrors.first(where: {
                       $0.lowercased().contains("code")
                   }) {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // ── CATEGORY + ERROR ──────────────────────────
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
                   let msg = vm.fieldErrors.first(where: {
                       $0.contains("Category")
                   }) {
                    Text(msg)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }

            // ── POINTS (no error) ─────────────────────────
            TextBox(
                inputText: $vm.eventPoints,
                name: "POINTS",
                imageName: "list",
                width: UIScreen.main.bounds.width * 0.3
            )

            // ── EXPIRES IN + ERROR ────────────────────────
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
                   let msg = vm.fieldErrors.first(where: {
                       $0.contains("Expires")
                   }) {
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
// Reusable TextBox (unchanged)
struct TextBox: View {
    @Binding var inputText: String
    var name: String
    var imageName: String
    var width: CGFloat

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(imageName)
                    .renderingMode(.original)
                    .resizable()
                    .frame(
                        width: UIScreen.main.bounds.width * 0.080,
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
                        .frame(width: width, height: 1),
                    alignment: .bottomLeading
                )
        }
    }
}

// ────────────────────────────────────────────────────────────────────────────────
// Reusable AdminDropDown (with extra label padding)
struct AdminDropDown: View {
    @Binding var selection: String
    let options: [String]
    let width: CGFloat
    var name: String
    var imageName: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            // Label with extra bottom padding
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

            // Selection “text field” look
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
            .onTapGesture { withAnimation { isExpanded.toggle() } }
            .overlay(
                Rectangle().frame(height: 1),
                alignment: .bottom
            )

            // Dropdown list
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
                                        selection = opt
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

// ────────────────────────────────────────────────────────────────────────────────
#Preview {
    EventCreatorView()
}
