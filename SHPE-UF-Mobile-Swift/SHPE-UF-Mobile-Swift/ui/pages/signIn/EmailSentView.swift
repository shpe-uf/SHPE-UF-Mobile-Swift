import SwiftUI

struct EmailSentView: View {
    @StateObject var viewModel: ForgetPasswordViewModel
    @Environment(\.dismiss) private var dismiss   // For back button
    var userEmail: String // The email we show the user
    @State private var resendEmailMessage = ""
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(colorScheme == .dark ? "Back" : "lightmode_back")
                            .frame(height: 75, alignment: .bottomLeading)
                            
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            VStack {
                Text("Check your inbox")
                    .font(Font.custom("Univers LT Std-Bold", size: 28))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Color(.white): Color(red: 0.82, green: 0.35, blue: 0.09))
                
                Text("We've sent password reset instructions to \(userEmail)")
                    .padding(.top, 28)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(colorScheme == .dark ? Color(.white): Color(red: 0.82, green: 0.35, blue: 0.09))
                
                Button {
                    // clear previous states
                    resendEmailMessage = ""
                    viewModel.error     = ""

                    viewModel.forgotPassword(email: userEmail) { success in
                        if success {
                            resendEmailMessage = "Email resent successfully."
                        } else {
                            // show a friendlier fallback if .error is empty
                            resendEmailMessage = viewModel.error.isEmpty
                                ? "Couldn’t resend email. Please try again."
                                : viewModel.error
                        }
                    }

                    // dismiss keyboard just in case
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                } label: {
                    Text(viewModel.isCommunicating ? "Loading…" : "Resend Email")
                        .font(Font.custom("Viga-Regular", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 267, height: 42)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .cornerRadius(10)
                        .padding()
                }
                .disabled(viewModel.isCommunicating) // stops double tapping
                
                // Confirmation text
                Text(resendEmailMessage)
                    .padding(.top, 2)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("lblue"))
            }
            .padding(.all, 43)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("darkBlue"))
    }
}
#Preview {
    EmailSentView(viewModel: ForgetPasswordViewModel(), userEmail: "test@example.com")
}

