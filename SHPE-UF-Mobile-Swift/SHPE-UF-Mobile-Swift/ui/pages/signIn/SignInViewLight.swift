import SwiftUI
import Foundation



struct SignInViewLight: View {
    @StateObject var viewModel: SignInViewModel
    @State public var username = ""
    @State public var password = ""
    @State private var isHovered = false
    @State private var isPasswordVisible = false
    @State private var signInSuccess = false
    
    
    
    var body: some View {
        ZStack {
            
            // Dark Blue Background
            Color(red: 0.93, green: 0.93, blue: 0.93)
                .edgesIgnoringSafeArea(.all)
            
            
            // Image and Sign In Text
            VStack {
                
                    // shpe_logo Image
                    Image("shpe_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 93, height: 86)
                        .opacity(0)
                        .padding(.top,20)
                    
                    //.clipped()
                    
                    // SIGN IN Text
                    Text("SIGN IN")
                        .font(Font.custom("VigaRegular", size: 50))
                        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .frame(width: 200, height: 42, alignment: .topLeading)
                }
                .padding(.top, -300)
            // Orange Rectangle with Gator Image
            GeometryReader { geometry in
                ZStack {
                    
                    Rectangle()
                        .frame(width: 393, height: 93)
                        .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09)) // Orange color
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 46)
                    
                    // Gator Image
                    Image("Gator2")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 306, height: 197) // Adjust the size here
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 46 + 125 / 2) // Adjust the y position to center the image within the rectangle
                    
                    Rectangle()
                        .frame(width: 393, height: 140)
                        .foregroundColor(Color(red: 0.93, green: 0.93, blue: 0.93)) // Orange color
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 150)
                    
                    // shpe_logo Image
                    Image("shpe_logo")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 93, height: 86)
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 115 + 125 / 2)
                        
                }
            }
            .edgesIgnoringSafeArea(.top)

            
            VStack {
                ZStack {
                    
                    TextField("", text: $username)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color(red: 49/255, green: 49/255, blue: 49/255))
                        .frame(height: 38)
                        .frame(width: 310, height: 38)
                        .padding(.leading, 3) // Adjust to make space for the image
                        .autocapitalization(.none)
                        Image("Message 35")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.leading, -145) // Adjust as needed to position the image inside the text box
                    // Email Text
                    Text("Email")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color(red:0,green:0.12,blue:0.21))
                      .frame(width: 300, height: 13.47059, alignment: .topLeading)
                      .padding(.top,-40)
                        
                        
                    }
                .padding(.bottom,30)
                
                
                ZStack {
                    
                    SecureField("", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color(red:0,green:0.12,blue:0.21))
                        .frame(height: 38)
                        .frame(width: 310, height: 38)
                        .padding(.leading, 3) // Adjust to make space for the image
                        .autocapitalization(.none)
                        Image("Lock 3")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.leading, -145) // Adjust as needed to position the image inside the text box
            
                    // Email Text
                    Text("Password")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color(red:0,green:0.12,blue:0.21))
                      .frame(width: 300, height: 13.47059, alignment: .topLeading)
                      .padding(.top,-40)
                        
                        
                    }
                .padding(.bottom,38)
                
                // Sign In Button
                Button(action: {
                    viewModel.signIn(username: username, password: password)
                    viewModel.signInButtonClicked = true
                }) {
                    Text("Sign In")
                        .font(Font.custom("Viga", size: 16))
                        .foregroundColor(Color.white)
                }
                .frame(width: 267, height: 42)
                .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                .cornerRadius(100)
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
                  .foregroundColor(Color(red:0,green:0.12,blue:0.21))
                  .frame(width:162, height:17)
            }
        }
    }
}


struct SignInViewLight_Previews: PreviewProvider {
    static var previews: some View {
        SignInViewLight(viewModel: SignInViewModel(shpeito:
                                SHPEito(
                                    username: "",
                                    password: "",
                                        remember: "true",
                                        photo: "",
                                        firstName: "",
                                        lastName: "",
                                        year: "",
                                        major: "",
                                        id: "",
                                        token: "",
                                        confirmed: true,
                                        updatedAt: "",
                                        createdAt: "",
                                        email: "",
                                        fallPoints: 0,
                                        summerPoints: 0,
                                        springPoints: 0)
                          ))
    }
}

