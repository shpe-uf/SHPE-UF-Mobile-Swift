import SwiftUI
import Foundation

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        ZStack {
            
            // Dark Blue Background
            Color(red: 1/255, green: 31/255, blue: 53/255)
                .edgesIgnoringSafeArea(.all)
            
            // Image and Sign In Text
            VStack {
                    // SHPE Logo Image
                    Image("SHPE Logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 93, height: 86)
                        .clipped()
                    
                    // SIGN IN Text
                    Text("SIGN IN")
                        .font(Font.custom("VigaRegular", size: 50))
                        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .frame(width: 200, height: 42, alignment: .topLeading)
            }
                .padding(.top, -300)
            GeometryReader { geometry in
                ZStack {
                    Rectangle()
                        .frame(width: 393, height: 93)
                        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09)) // Orange color
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 46)
                    
                    Image("Gator")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 306, height: 197)
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 220 / 2)
                        .overlay(
                            Rectangle()
                                .frame(width: 393, height: 93)
                                .foregroundColor(Color.clear)
                                .clipped()
                        )
                }
            }
            .edgesIgnoringSafeArea(.top)

            
            VStack {
                
                // Email Text
                Text("Email")
                  .font(Font.custom("Univers LT Std", size: 16))
                  .foregroundColor(Color.white)
                  .frame(width: 95.59007, height: 16.47059, alignment: .topLeading)
                
                // Email Text Box
                TextField("Email", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color(red: 49/255, green: 49/255, blue: 49/255))
                    .padding()
                    .autocapitalization(.none)
                
                
                
                // Password Text
                Text("Password")
                    .font(Font.custom("Univers LT Std", size: 16))
                    .foregroundColor(Color.white)
                
                // Password Text Box
                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .background(Color.white)
                    .cornerRadius(10)
                    .padding()
                
                // Sign In Button
                Button(action: {
                    viewModel.signIn()
                    viewModel.signInButtonClicked = true
                }) {
                    Text("Sign In")
                        .font(Font.custom("Viga", size: 16))
                        .foregroundColor(Color.white)
                }
                .frame(width: 267, height: 42)
                .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                .cornerRadius(10)
                .padding()
                .disabled(viewModel.signInButtonClicked)
                
                if viewModel.signInButtonClicked {
                    if username.isEmpty || password.isEmpty {
                        Text("Please enter username and password")
                            .foregroundColor(.white)
                    } else {
                        if username == viewModel.shpeito.username && password == viewModel.shpeito.password {
                            Text("Success")
                                .foregroundColor(.white)
                        } else {
                            Text("Failure")
                                .foregroundColor(.white)
                        }
                    }
                }
                Text("Don’t have an acccount?")
                  .font(Font.custom("Univers LT Std", size: 14))
                  .foregroundColor(Color.white)
                  .frame(width:162, height:17)
            }
            .padding()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(shpeito:
                                SHPEito(
                                    username: "dvera0322",
                                    password: "",
                                    remember: "false")
                          ))
    }
}
