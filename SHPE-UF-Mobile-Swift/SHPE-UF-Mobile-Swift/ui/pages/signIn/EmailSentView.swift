import SwiftUI

struct EmailSentView: View {
    @StateObject var viewModel: ForgetPasswordViewModel
    
    // The email we show the user
    var userEmail: String
    
    @State private var goBack = false
    @State private var resendEmailMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        goBack = true
                    } label: {
                        Image("Back")
                            .frame(height: 75, alignment: .bottomLeading)
                    }
                    .fullScreenCover(isPresented: $goBack) {
                        // Where to go on "Back"?
                        // Perhaps back to ForgetPasswordView(viewModel: viewModel).
                        ForgetPasswordView(viewModel: viewModel)
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
                    .foregroundColor(.white)
                
                Text("We've sent password reset instructions to \(userEmail).")
                    .padding(.top, 28)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                
                // Resend Email
                Button(action: {
                    // If you want to re-use the same forgotPassword logic:
                    // viewModel.forgotPassword(email: userEmail)
                    // or do a simpler approach:
                    
                    resendEmailMessage = "Email resent successfully"
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                                    to: nil, from: nil, for: nil)
                }) {
                    Text(viewModel.isCommunicating ? "Loading..." : "Resend Email")
                        .font(Font.custom("Viga-Regular", size: 16))
                        .foregroundColor(.white)
                        .frame(width: 267, height: 42)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .cornerRadius(10)
                        .padding()
                }
                
                // Confirmation text
                Text(resendEmailMessage)
                    .padding(.top, 2)
                    .font(Font.custom("Univers LT Std", size: 16))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
            }
            .padding(.all, 43)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color("darkdarkBlue"))
    }
}
