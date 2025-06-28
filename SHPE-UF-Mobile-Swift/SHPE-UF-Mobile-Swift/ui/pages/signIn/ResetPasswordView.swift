import SwiftUI

struct ResetPasswordView: View {
    @State private var newPassword: String = ""
    @State private var confirmPassword: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                Color(red: 7/255, green: 26/255, blue: 47/255)
                    .edgesIgnoringSafeArea(.all)

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
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.top ,100)

                    // Subtitle centered
                    Text("Enter a new password.\nIt must not be the same as your last.")
                        .font(.body)
                        .foregroundColor(.white)
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
                            .background(Color(red: 185/255, green: 84/255, blue: 33/255))
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
