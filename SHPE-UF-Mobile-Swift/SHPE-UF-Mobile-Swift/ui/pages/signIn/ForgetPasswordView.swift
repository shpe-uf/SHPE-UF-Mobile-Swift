import SwiftUI

struct ForgetPasswordView: View {
    @Environment(\.dismiss) private var dismiss   // ✅ This is needed!

    @StateObject var viewModel: ForgetPasswordViewModel
    
    @State public var Email = ""
    @State private var emailMessage = ""
    @State private var foundEmail = false
    
    var body: some View {
        ZStack {
            // 1) Top bar with back button
            VStack {
                HStack {
                    Button {
                        dismiss()  // ✅ This now works
                    } label: {
                        Image("Back")
                            .frame(height: 75, alignment: .bottomLeading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            // 2) Main content
            VStack {
                Text("Forgot your password?")
                    .font(Font.custom("Univers LT Std-Bold", size: 28))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                Text("Enter your email and we will send you \ninstructions to reset your password.")
                    .padding(.top, 28)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                TextField("Email address", text: $Email)
                    .padding()
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .modifier(CustomTextFieldStyle(padding: 12, cornerRadius: 10))
                    .frame(maxWidth: 525, alignment: .center)
                
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .padding(.top, 8)
                        .font(Font.custom("Univers LT Std", size: 16))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
                
                Button(action: {
                    if Email.contains("@") {
                        viewModel.forgotPassword(email: Email)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            if viewModel.error.isEmpty {
                                foundEmail = true
                            }
                        }
                    } else {
                        emailMessage = "Please enter a valid email."
                        foundEmail = false
                    }

                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }) {
                    Text(viewModel.isCommunicating ? "Loading..." : "Continue")
                        .font(Font.custom("Viga-Regular", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 267, height: 42)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .cornerRadius(10)
                        .padding()
                }
                .frame(alignment: .center)
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
        .background(Color("darkdarkBlue"))
    }
}
