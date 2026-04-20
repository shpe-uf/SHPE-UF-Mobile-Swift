//
//  ProfileView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by victoria dib on 3/7/24.
//

import SwiftUI
/// A view that displays and manages a user's profile information in the SHPE app.
///
/// `ProfileView` serves as the central hub for user profile management, allowing users to:
/// - View and edit personal information (name, email, gender, ethnicity)
/// - Manage educational details (major, year, classes, internships)
/// - Customize appearance settings (light/dark mode)
/// - Perform account actions (sign out, delete account)
///
/// The view is organized into distinct sections with a consistent visual style:
/// - Header section with profile picture and name
/// - Account information section
/// - Education information section
/// - Appearance settings section
/// - Account management options
///
/// `ProfileView` uses a dedicated ``ProfileViewModel`` to manage its state and business logic,
/// separating view rendering from data management.
///
/// # Example
/// ```swift
/// ProfileView(vm: ProfileViewModel(shpeito: SHPEito()))
/// ```
struct ProfileView: View
{
    /// The environment-provided color scheme for adapting UI based on light/dark mode
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    
    /// The app's data manager for handling profile data and persistence
    @EnvironmentObject var manager: DataManager

    /// The managed object context for Core Data operations
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CalendarEvent>
    @FetchRequest(sortDescriptors: []) private var userEvents: FetchedResults<CoreUserEvent>
    @StateObject var coreVM:CheckCoreViewModel = CheckCoreViewModel()
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    
    @StateObject var vm:ProfileViewModel
    
    @State var validUsername:Bool = true
    @State var clickedDeleteAccount:Bool = false
    @State var loadingDelete:Bool = false
    @State var errorDeleting:Bool = false
    
    var body: some View {
        ZStack {
            Constants.profileGradient.ignoresSafeArea()

            VStack(spacing: 0) {

                // MARK: Header
                ZStack(alignment: .top) {
                    let profilePFP = appVM.darkMode ? "DefaultPFPD" : "DefaultPFPL"

                    // Centered column: photo → name → action buttons
                    VStack(spacing: 12) {
                        Spacer().frame(height: UIScreen.main.bounds.height * 0.02)

                        // Profile photo with optional edit overlay
                        ZStack {
                            if let selectedImage = vm.selectedImage, vm.isEditing {
                                Image(uiImage: selectedImage)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("profile-orange"), lineWidth: 4))
                                    .padding(.top, UIScreen.main.bounds.height * 0.10)
                            } else if let profileImage = vm.shpeito.profileImage {
                                Image(uiImage: profileImage)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("profile-orange"), lineWidth: 4))
                                    .padding(.top, UIScreen.main.bounds.height * 0.10)
                            } else {
                                Image(profilePFP)
                                    .renderingMode(.original)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 110, height: 110)
                                    .clipShape(Circle())
                                    .padding(.top, UIScreen.main.bounds.height * 0.10)
                            }

                            if vm.isEditing {
                                Image("imageIcon")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 28, height: 28)
                                    .padding(.top, UIScreen.main.bounds.height * 0.10)
                                    .background(Color("gray"))
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color("profile-orange"), lineWidth: 4))
                                    .offset(x: 40, y: 38)
                                    .onTapGesture { vm.showImagePicker.toggle() }
                                    .sheet(isPresented: $vm.showImagePicker, onDismiss: {}) {
                                        ImagePicker(selectedImage: $vm.selectedImage, sourceType: .photoLibrary)
                                            .ignoresSafeArea()
                                    }
                            }
                        }

                        // Name
                        Text(vm.isEditing ? vm.newName : vm.shpeito.name)
                            .font(Font.custom("Viga-Regular", size: 24))
                            .foregroundColor(.white)

                        // Edit Profile / Save + Cancel
                        if !vm.isEditing {
                            Button {
                                vm.isEditing = true
                            } label: {
                                HStack(spacing: 8) {
                                    Text("Edit Profile")
                                        .foregroundStyle(Color.white)
                                        .padding(.vertical, 10)
                                    Image("pencil")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 18, height: 18)
                                }
                                .padding(.horizontal, 20)
                                .background(Color("orangeButton"))
                                .cornerRadius(50)
                            }
                        } else {
                            HStack(spacing: 16) {
                                Button {
                                    vm.saveEditsToProfile(user: user, viewContext: viewContext)
                                } label: {
                                    Text("Save")
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Viga-Regular", size: 18))
                                        .frame(width: 120)
                                        .padding(.vertical, 10)
                                        .background(Color("orangeButton"))
                                        .cornerRadius(50)
                                        .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.white, lineWidth: 1))
                                }
                                Button {
                                    vm.clearFields()
                                    vm.isEditing = false
                                } label: {
                                    Text("Cancel")
                                        .foregroundStyle(Color.white)
                                        .font(Font.custom("Viga-Regular", size: 18))
                                        .frame(width: 120)
                                        .padding(.vertical, 10)
                                        .background(Color("orangeButton"))
                                        .cornerRadius(50)
                                        .overlay(RoundedRectangle(cornerRadius: 50).stroke(Color.white, lineWidth: 1))
                                }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)

                    // Back button — top leading
                    Button { dismiss() } label: {
                        Image("Back")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, maxHeight: 100, alignment: .topLeading)
                    .padding(.leading, 20)
                    .padding(.top, 56)

                    // Title — top center
                    Text("Profile")
                        .font(Font.custom("Viga-Regular", size: 24))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 60)
                }

                // MARK: Form fields
                ScrollView {
                    VStack(spacing: 0) {

                        // ACCOUNT INFO
                        Text("ACCOUNT INFO")
                            .font(Font.custom("Viga-Regular", size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 8)

                        ProfileFieldRow(icon: "person", label: "NAME") {
                            if vm.isEditing {
                                TextField(vm.newName, text: $vm.newName)
                                    .autocorrectionDisabled()
                                    .textInputAutocapitalization(.never)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                                    .onSubmit { vm.validateName() }
                                if vm.invalidFirstName {
                                    Text("First name must be at least 1 character, no special characters or numbers")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                                if vm.invalidLastName {
                                    Text("Last name must be at least 1 character, no special characters or numbers")
                                        .font(.caption)
                                        .foregroundColor(.red)
                                }
                            } else {
                                Text(vm.shpeito.name)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }

                        ProfileFieldRow(icon: "at", label: "USERNAME") {
                            Text(vm.shpeito.username)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }

                        ProfileFieldRow(icon: "envelope", label: "EMAIL") {
                            Text(vm.shpeito.email)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                        }

                        ProfileFieldRow(icon: "person.2", label: "GENDER") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newGender, options: vm.genderoptions, width: 120)
                            } else {
                                Text(vm.shpeito.gender)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(6)

                        ProfileFieldRow(icon: "globe", label: "ETHNICITY") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newEthnicity, options: vm.ethnicityoptions, width: 240)
                            } else {
                                Text(vm.shpeito.ethnicity)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(5)

                        ProfileFieldRow(icon: "map", label: "ORIGIN COUNTRY") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newOriginCountry, options: vm.originoptions, width: 240)
                            } else {
                                Text(vm.shpeito.originCountry)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(4)

                        // EDUCATION INFO
                        Text("EDUCATION INFO")
                            .font(Font.custom("Viga-Regular", size: 18))
                            .foregroundColor(.white.opacity(0.8))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 8)

                        ProfileFieldRow(icon: "graduationcap", label: "MAJOR") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newMajor, options: vm.majorOptions, width: 200)
                            } else {
                                Text(vm.shpeito.major)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(3)

                        ProfileFieldRow(icon: "calendar", label: "YEAR") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newYear, options: vm.yearoptions, width: 200)
                            } else {
                                Text(vm.shpeito.year)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(2)

                        ProfileFieldRow(icon: "flag.checkered", label: "GRADUATION YEAR") {
                            if vm.isEditing {
                                DropDown(vm: vm, change: $vm.newGradYear, options: vm.gradoptions, width: 100)
                            } else {
                                Text(vm.shpeito.graduationYear)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                        }
                        .zIndex(1)

                        ProfileFieldRow(icon: "books.vertical", label: "CLASSES") {
                            if vm.isEditing {
                                MultipleLabels(placeholder: "Add your classes here", change: $vm.newClasses, validationFunction: { _ in true })
                                    .frame(height: {
                                        var count: CGFloat = 0
                                        let padding: CGFloat = 12.5 * CGFloat(vm.newClasses.count)
                                        for item in vm.newClasses { count += CGFloat(item.count) }
                                        return ceil((count * 2.5 + padding) / 100.0) * 50 + 70
                                    }())
                            } else {
                                VStack(alignment: .leading) {
                                    ForEach(vm.shpeito.classes, id: \.self) { classStr in
                                        Text(classStr)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }

                        ProfileFieldRow(icon: "briefcase", label: "INTERNSHIPS") {
                            if vm.isEditing {
                                MultipleLabels(placeholder: "Add your internships here", change: $vm.newInternships, validationFunction: { _ in true })
                                    .frame(height: {
                                        var count: CGFloat = 0
                                        let padding: CGFloat = 12.5 * CGFloat(vm.newInternships.count)
                                        for item in vm.newInternships { count += CGFloat(item.count) }
                                        return ceil((count * 2.5 + padding) / 100.0) * 50 + 70
                                    }())
                            } else {
                                VStack(alignment: .leading) {
                                    ForEach(vm.shpeito.internships, id: \.self) { internship in
                                        Text(internship)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                    }
                                }
                            }
                        }

                        ProfileFieldRow(icon: "link", label: "LINKS") {
                            if vm.isEditing {
                                MultipleLabels(placeholder: "Add your links here", change: $vm.newLinks, validationFunction: { urlString in
                                    if let url = URL(string: urlString) {
                                        return UIApplication.shared.canOpenURL(url)
                                    }
                                    return false
                                })
                                .frame(height: {
                                    var count: CGFloat = 0
                                    let padding: CGFloat = 12.5 * CGFloat(vm.newLinks.count)
                                    for item in vm.newLinks { count += CGFloat(item.count) }
                                    return ceil((count * 2.5 + padding) / 100.0) * 50 + 70
                                }())
                            } else {
                                VStack(alignment: .leading) {
                                    ForEach(vm.shpeito.links, id: \.self) { link in
                                        Text(link.absoluteString)
                                            .font(.system(size: 16))
                                            .foregroundColor(.white)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                            .onTapGesture { UIApplication.shared.open(link) }
                                    }
                                }
                            }
                        }

                        Spacer().frame(height: 100)
                    }
                }
            }
            .ignoresSafeArea(edges: .top)
            .preferredColorScheme(appVM.darkMode ? .dark : .light)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }

            // MARK: Delete Account Overlay
            if clickedDeleteAccount {
                VisualEffectBlur(blurStyle: .systemUltraThinMaterial)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    HStack {
                        Spacer()
                        Image("x_mark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .padding(5)
                            .background(Color.black.opacity(0.1))
                            .cornerRadius(20)
                            .onTapGesture {
                                withAnimation(.easeInOut(duration: 0.2)) {
                                    errorDeleting = false
                                    clickedDeleteAccount = false
                                    loadingDelete = false
                                }
                            }
                    }

                    Spacer()

                    Text("Delete Account?")
                        .foregroundStyle(Color.white)
                        .font(Font.custom("Viga-Regular", size: 24))
                        .padding(.bottom, 10)

                    Text("Deleting your account will remove all your personal data permanently.")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.white)
                        .font(Font.custom("", size: 16))

                    let profilePFP = appVM.darkMode ? "DefaultPFPD" : "DefaultPFPL"

                    if let profileImage = vm.shpeito.profileImage {
                        Image(uiImage: profileImage)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 130, height: 130)
                            .cornerRadius(100)
                            .overlay(RoundedRectangle(cornerRadius: 100).stroke(Color("Profile-Background"), lineWidth: 5))
                            .padding(.vertical, 20)
                    } else {
                        Image(profilePFP)
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 130, height: 130)
                            .padding(.vertical, 20)
                    }

                    Button {
                        loadingDelete = true
                        vm.deleteAccount { data in
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if data["error"] != nil {
                                    errorDeleting = true
                                } else {
                                    errorDeleting = false
                                    NotificationViewModel.instance.clearPendingNotifications(fetchedEvents: coreEvents, viewContext: viewContext)
                                    CoreFunctions().clearCore(events: coreEvents, users: user, userEvents: userEvents, viewContext: viewContext)
                                    appVM.toastMessage = "Account deleted successfully"
                                    appVM.showToast = true
                                    appVM.shpeito = SHPEito()
                                    appVM.setPageIndex(index: 3)
                                }
                                loadingDelete = false
                            }
                        }
                    } label: {
                        HStack {
                            Text("Delete")
                                .foregroundStyle(Color.white)
                                .font(Font.custom("Viga-Regular", size: 24))
                                .padding(.trailing, 5)
                            if loadingDelete {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .padding(5)
                            }
                        }
                        .padding(.vertical, 5)
                        .padding(.horizontal, 30)
                        .background(Color.darkdarkBlue)
                        .cornerRadius(12)
                    }
                    .padding(.bottom, errorDeleting ? 10 : 20)

                    if errorDeleting {
                        Text("Could not delete account at the moment. Try again later...")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(Color.white)
                            .font(Font.custom("", size: 16))
                            .padding(.bottom, 20)
                    }
                }
                .padding()
                .frame(width: 309, height: errorDeleting ? 470 : 406, alignment: .center)
                .background(Color.profileOrange)
                .cornerRadius(30)
                .zIndex(999)
            }
        }
    }
}

// MARK: - Profile Field Row

private struct ProfileFieldRow<Content: View>: View {
    let icon: String
    let label: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundColor(Color("profile-orange"))
                    .frame(width: 20)
                Text(label)
                    .font(Font.custom("Viga-Regular", size: 16))
                    .foregroundColor(Color("profile-orange"))
            }
            content()
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.white.opacity(0.4))
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Visual Effect Blur

struct VisualEffectBlur: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}

// MARK: - Dropdown

struct DropDown: View {
    @StateObject var vm: ProfileViewModel
    @Binding var change: String

    let options: [String]
    let width: CGFloat
    @State private var toggle: Bool = false

    var body: some View {
        VStack {
            HStack {
                Text(change)
                Spacer()
                Image(systemName: "chevron.down")
                    .rotationEffect(vm.dropdownPressed == change ? .degrees(180) : .zero)
            }
            .frame(width: width)
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .onTapGesture {
                withAnimation(.easeInOut) {
                    vm.dropdownPressed = vm.dropdownPressed != change ? change : ""
                }
            }

            if vm.dropdownPressed == change {
                ScrollView {
                    VStack(alignment: .leading) {
                        ForEach(options, id: \.self) { option in
                            Text(option)
                                .font(.system(size: 16))
                                .foregroundStyle(Color.black)
                                .padding(5)
                                .frame(width: width - 10, alignment: .leading)
                                .onTapGesture { change = option }
                        }
                    }
                    .padding(.vertical, 10)
                }
                .frame(width: width, height: options.count > 4 ? 165 : 45 * CGFloat(options.count))
                .background(Color("lightGray"))
                .clipped(antialiased: false)
                .cornerRadius(10)
            }
        }
        .padding(.top, vm.dropdownPressed == change ? options.count > 4 ? 175 : 45 * CGFloat(options.count) + 10 : 0)
        .frame(height: 35)
    }
}

// MARK: - Multiple Labels

typealias ValidationFunction = (String) -> Bool

struct MultipleLabels: View {
    let placeholder: String
    @Binding var change: [String]
    let validationFunction: ValidationFunction

    @State private var input: String = ""
    @State private var invalidInputMessage: String = ""

    var body: some View {
        VStack {
            HStack {
                TextField(placeholder, text: $input)
                    .limitInputLength(value: $input, length: 100)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(TextInputAutocapitalization(.none))
                    .font(.system(size: 16))
                    .padding(.top, 5)
                    .frame(width: 270)
                    .overlay(Rectangle().frame(height: 1).padding(.top, 35))

                Spacer()

                Button {
                    if change.contains(input) {
                        invalidInputMessage = "Input already exists"
                    } else if validationFunction(input) {
                        invalidInputMessage = ""
                        change.append(input)
                    } else {
                        invalidInputMessage = "Invalid Input"
                    }
                    input = ""
                } label: {
                    Image("addButton")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 30, height: 30)
                        .opacity(input.isEmpty ? 0.5 : 1)
                }
                .disabled(input.isEmpty)
            }

            Text(invalidInputMessage)
                .foregroundStyle(Color.red)
                .frame(maxWidth: .infinity, alignment: .leading)

            GeometryReader { geometry in
                self.generateContent(in: geometry, list: change)
            }
        }
        .padding(.vertical, 20)
    }

    private func generateContent(in g: GeometryProxy, list: [String]) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return VStack {
            ZStack(alignment: .topLeading) {
                ForEach(list, id: \.self) { item in
                    self.item(for: item)
                        .padding([.horizontal, .vertical], 4)
                        .alignmentGuide(.leading, computeValue: { d in
                            if abs(width - d.width) > g.size.width {
                                width = 0
                                height -= d.height
                            }
                            let result = width
                            if item == list.last! { width = 0 } else { width -= d.width }
                            return result
                        })
                        .alignmentGuide(.top, computeValue: { d in
                            let result = height
                            if item == list.last! { height = 0 }
                            return result
                        })
                }
            }
        }
        .padding(.top, 20)
    }

    func item(for text: String) -> some View {
        HStack {
            Text(text)
                .font(Font.custom("Manrope-Light", size: 16))
                .padding(.all, 5)
                .padding(.leading, 5)
                .font(.body)
            Image("xMark")
                .resizable()
                .frame(width: 16, height: 16)
                .padding(.all, 5)
                .onTapGesture {
                    var index = 0
                    for interest in change {
                        if text == interest { change.remove(at: index) }
                        index += 1
                    }
                }
        }
        .background(Color("buttonColor"))
        .foregroundColor(Color.white)
        .cornerRadius(20)
    }
}

// MARK: - Image Picker

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    var sourceType: UIImagePickerController.SourceType
    @Environment(\.presentationMode) var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        init(parent: ImagePicker) { self.parent = parent }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image.resize()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    ProfileView(vm: ProfileViewModel(shpeito: SHPEito()))
}
