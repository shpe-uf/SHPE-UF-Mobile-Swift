import SwiftUI

struct ResetPasswordView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? Constants.darkGradient : Constants.lightGradient)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    
                    HStack {
                        Button(action: {
                            
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.leading)
                        Spacer()
                    }

                   

                    // Title centered
                    Text("Create a new password")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(colorScheme == .dark ? .white : Color.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top ,100)

                    // Subtitle centered
                    Text("Enter a new password.\nIt must not be the same as your last.")
                        .font(.body)
                        .foregroundColor(colorScheme == .dark ? .white : Color.primary)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top ,5)

                    // Text Fields
                    VStack(spacing: 25) {
                        SecureField("New password", text: $newPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal)

                        SecureField("Confirm password", text: $confirmPassword)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }.padding(.top, 10)

                    // Submit Button
                    Button(action: {
                        // Submit logic goes here
                    }) {
                        Text("Submit")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Constants.orange)
                            .cornerRadius(15)
                    }
                    .padding(.horizontal)
                    

                    Spacer()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    ResetPasswordView()
}
