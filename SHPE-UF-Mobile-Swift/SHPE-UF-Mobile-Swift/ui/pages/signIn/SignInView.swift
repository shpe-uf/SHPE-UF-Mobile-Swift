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
                    Image("Gator")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 306, height: 197) // Adjust the size here
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 46 + 125 / 2) // Adjust the y position to center the image within the rectangle
                    
                    Rectangle()
                        .frame(width: 393, height: 120)
                        .foregroundColor(Color(red: 1/255, green: 31/255, blue: 53/255)) // Orange color
                        .position(x: geometry.size.width / 2, y: geometry.safeAreaInsets.top + 150)
                    
                    // SHPE Logo Image
                    Image("SHPE Logo")
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
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        Image("Message 35")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.leading, -145) // Adjust as needed to position the image inside the text box
                    // Email Text
                    Text("Email")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 300, height: 13.47059, alignment: .topLeading)
                      .padding(.top,-40)
                        
                        
                    }
                .padding(.bottom,30)
                
                
                ZStack {
                    
                    SecureField("", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .background(Color(red: 49/255, green: 49/255, blue: 49/255))
                        .frame(height: 38)
                        .frame(width: 310, height: 38)
                        .padding(.leading, 3) // Adjust to make space for the image
                        .foregroundColor(.black)
                        .autocapitalization(.none)
                        Image("Lock 3")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.leading, -145) // Adjust as needed to position the image inside the text box
            
                    // Email Text
                    Text("Password")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color.white)
                      .frame(width: 300, height: 13.47059, alignment: .topLeading)
                      .padding(.top,-40)
                        
                        
                    }
                .padding(.bottom,38)
                
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
                  .foregroundColor(Color.white)
                  .frame(width:162, height:17)
            }
            .padding(.top, 130)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(shpeito:
                                SHPEito(
                                    username: "dvera0322",
                                        password: "",
                                        remember: "true",
                                        photo: "",
                                        firstName: "David",
                                        lastName: "Vera",
                                        year: "2",
                                        major: "Computer Science",
                                        id: "",
                                        token: "",
                                        confirmed: true,
                                        updatedAt: "",
                                        createdAt: "",
                                        email: "david.vera@ufl.edu",
                                        fallPoints: 2,
                                        summerPoints: 2,
                                        springPoints: 2)
                          ))
    }
}
