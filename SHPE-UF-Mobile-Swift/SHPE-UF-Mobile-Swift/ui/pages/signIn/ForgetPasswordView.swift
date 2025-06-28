import SwiftUI

//shake effect for errors
struct ShakeEffect: GeometryEffect {
    var amount: CGFloat = 8
    var shakesPerUnit: CGFloat = 5
    var animatableData: CGFloat

    func effectValue(size: CGSize) -> ProjectionTransform {
        let displacement = amount * sin(animatableData * .pi * shakesPerUnit)
        return ProjectionTransform(CGAffineTransform(translationX: displacement, y: 0))
    }
}



struct ForgetPasswordView: View {
    @Environment(\.dismiss) private var dismiss   // For back button
    @Environment(\.colorScheme) private var colorScheme
    @StateObject var viewModel: ForgetPasswordViewModel
    @State public var Email = ""
    @State private var foundEmail = false
    @State private var shakeTrigger: Int = 0
    
    var body: some View {
        ZStack {
            // Top bar with back button
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(colorScheme == .dark ? "Back" : "lightmode_back").frame(height: 75, alignment: .bottomLeading)
                            
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            // Main content
            VStack {
                Text("Forgot your password?")
                    .font(Font.custom("Univers LT Std-Bold", size: 30))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Color(.white): Color(red: 0.82, green: 0.35, blue: 0.09))
                
                Text("Enter your email and we will send you \ninstructions to reset your password.")
                    .padding(.top, 15)
                    .padding(.bottom, 30)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Color(.white): Color(red: 0.82, green: 0.35, blue: 0.09))
                
                TextField("Email address", text: $Email)
                    .onChange(of: Email) { _ in
                        // Clear error immediately when user starts editing
                        viewModel.error = ""
                    }
                    .padding()
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .frame(maxWidth: UIScreen.main.bounds.width > 600 ? 500 : .infinity, maxHeight: 45)
                    .background(Color.white)
                    .cornerRadius(10)
                    .colorScheme(.light)
                
                Text(viewModel.error.isEmpty ? " " : viewModel.error)
                    .padding(.top, 10)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .modifier(ShakeEffect(animatableData: CGFloat(shakeTrigger)))
                    .animation(.easeInOut(duration: 0.4), value: viewModel.error)

                Button(action: {
                    if Email.contains("@") {
                        viewModel.forgotPassword(email: Email) { success in
                            if success {
                                foundEmail = true
                            } else {
                                // any server side error ends up here
                                shakeTrigger = (shakeTrigger + 1) % 1000
                            }
                        }


                    } else {
                        viewModel.error = "Please enter a valid email."
                        shakeTrigger = (shakeTrigger + 1) % 1000
                        foundEmail = false
                    }

                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }) {
                    Text(viewModel.isCommunicating ? "Loading..." : "Continue")
                        .font(Font.custom("Viga-Regular", size: 18))
                        .foregroundColor(.white)
                        .frame(maxWidth: UIScreen.main.bounds.width > 600 ? 500 : .infinity, maxHeight: 45)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .cornerRadius(10)
                }
                
                .fullScreenCover(isPresented: $foundEmail) {
                    EmailSentView(
                        viewModel: self.viewModel,
                        userEmail: Email
                    )
                }
            }
            .padding(43)
            .frame(alignment: .leading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("darkBlue"))
    }
}
#Preview {
    ForgetPasswordView(viewModel: ForgetPasswordViewModel())
}
