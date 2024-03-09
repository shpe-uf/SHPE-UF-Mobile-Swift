import SwiftUI
import Foundation

struct CustomTextFieldStyle: ViewModifier {
    let padding: CGFloat
    let cornerRadius: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.leading, padding)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(cornerRadius) // Apply corner radius

    }
}



struct SignInView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var appVM: AppViewModel = AppViewModel.appVM
    @StateObject var viewModel: SignInViewModel
    @State public var username = ""
    @State public var password = ""
    @State private var isHovered = false
    @State private var isPasswordVisible = false
    @State private var signInSuccess = false
    
    var body: some View {
        ZStack {
            
            Color(red: 0.82, green: 0.35, blue: 0.09)
                .ignoresSafeArea()
            
            //gator pic
            Rectangle()
              .foregroundColor(.clear)
              .background(
                Image(colorScheme == .dark ? "Gator" : "Gator2")
                  .resizable()
                  .aspectRatio(contentMode: .fill)
                  .frame(width: 306, height: 197)
                  .clipped()
              )
              .offset(y: colorScheme == .dark ? -UIScreen.main.bounds.height * 0.305 : -UIScreen.main.bounds.height * 0.325)
            
            
            VStack
            {
                // SHPE Logo Image
                Image("shpe_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 93, height: 86)
                    .padding(.top,30)
                                                
                // SIGN IN Text
                Text("SIGN IN")
                    .font(Font.custom("VigaRegular", size: 50))
                    .foregroundColor(Color(red: 0.82, green: 0.35, blue: 0.09))
                    .padding(.top, 20)
                    .padding(.bottom, 50)
                
                
                // Email Text
                VStack(alignment: .leading)
                {
                    Text("Email")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color("whiteText"))
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlepfp")
                            .padding(.horizontal, 12)
                        
                        TextField("", text: $username)
                            .padding(.leading, 3) // Adjust to make space for the image
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                
                // Password Text
                VStack(alignment: .leading)
                {
                    Text("Password")
                      .font(Font.custom("Univers LT Std", size: 16))
                      .foregroundColor(Color("whiteText"))
                    
                    HStack(spacing: 0)
                    {
                        Image("swift.littlelock")
                            .padding(.horizontal, 12)
                        
                        if viewModel.viewPassword
                        {
                            TextField("", text: $password)
                                .frame(height: 38)
                                .padding(.leading, 3) // Adjust to make space for the image
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        else
                        {
                            SecureField("", text: $password)
                                .frame(height: 38)
                                .padding(.leading, 3) // Adjust to make space for the image
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                                .autocorrectionDisabled()
                        }
                        
                        Image(viewModel.viewPassword ? "swift.littlepfp" :"Eye Closed")
                            .frame(width: 22.32634, height: 14.58338)
                            .background(Color.white)
                            .padding(.horizontal, 12)
                            .onTapGesture {
                                viewModel.viewPassword.toggle()
                            }
                    }
                    .padding(.vertical, 2.75)
                    .frame(width: 270, height: 37.64706)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .padding(.bottom, 50)
                
                
                // Sign In Button
                Button(action: {
                    viewModel.signIn(username: username, password: password)
                    viewModel.signInButtonClicked = true
                }) {
                    Text("Sign In")
                        .font(Font.custom("Viga", size: 16))
                        .foregroundColor(Color.white)
                        .frame(width: 267, height: 42)
                        .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                        .cornerRadius(100)
                        .padding()
                }
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
                HStack
                {
                    Text("Don’t have an acccount?")
                      .font(Font.custom("Univers LT Std", size: 14))
                      .foregroundColor(Color("whiteText"))
                      .frame(width:162, height:17)
                    Text("Sign Up")
                        .font(Font.custom("Univers LT Std", size: 14))
                        .foregroundColor(Color("lblue"))
                        .onTapGesture {
                            appVM.setPageIndex(index: 0)
                        }
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.83)
            .background(Color("darkBlue"))
            .padding(.top, UIScreen.main.bounds.height * 0.17)
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(shpeito:
                                SHPEito()
                          ))
    }
}
