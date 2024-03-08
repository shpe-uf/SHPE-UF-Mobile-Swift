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
    @StateObject var viewModel: SignInViewModel
    @State public var username = ""
    @State public var password = ""
    @State private var isHovered = false
    @State private var isPasswordVisible = false
    @State private var signInSuccess = false
    
    
    
    var body: some View {
        NavigationView{
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
                        Rectangle()
                            .frame(width: 173, height: 34)
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                            .padding(.leading,-140)
                        
                        TextField("", text: $username)
                            .modifier(CustomTextFieldStyle(padding: 40, cornerRadius: 10))
                        //.background(Color.white)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 38)
                            .frame(width: 310, height: 38)
                            .padding(.leading, 3)
                            .foregroundColor(.black)
                            .autocapitalization(.none)
                        Image("Profile Circle")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .padding(.leading, -145)
                        Text("Username")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 13.47059, alignment: .topLeading)
                            .padding(.top,-40)
                        
                        
                    }
                    .padding(.bottom,30)
                    
                    
                    ZStack {
                        Rectangle()
                            .frame(width: 173, height: 34)
                            .cornerRadius(10)
                            .foregroundColor(Color.white)
                            .padding(.leading,-140)
                        if isPasswordVisible{
                            TextField("", text: $password)
                                .modifier(CustomTextFieldStyle(padding: 40, cornerRadius: 10))
                                //.background(Color.white)
                                .frame(height: 38)
                                .frame(width: 310, height: 38)
                                .padding(.leading, 3)
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                            Image("Lock 3")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(.leading, -145)
                            
                            
                        }else{
                            SecureField("", text: $password)
                                .modifier(CustomTextFieldStyle(padding: 40, cornerRadius: 10))
                                //.background(Color.white)
                                .frame(height: 38)
                                .frame(width: 310, height: 38)
                                .padding(.leading, 3)
                                .foregroundColor(.black)
                                .autocapitalization(.none)
                            Image("Lock 3")
                                .resizable()
                                .frame(width: 22, height: 22)
                                .padding(.leading, -145)
                        }
                        
                        HStack {
                            Image(systemName: isPasswordVisible ? "eye.slash.fill" : "eye.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 22.32634, height: 14.58338)
                                .padding(.leading, 250)
                                .onTapGesture {
                                    isPasswordVisible.toggle()
                                }
                        }
                        
                        
                        // Email Text
                        Text("Password")
                            .font(Font.custom("Univers LT Std", size: 16))
                            .foregroundColor(Color.white)
                            .frame(width: 300, height: 13.47059, alignment: .topLeading)
                            .padding(.top,-40)
                        
                        
                    }
                    .padding(.bottom,38)
                    
                    ZStack {
                        Rectangle()
                            .fill(isHovered ? Color(red: 147/255, green: 56/255, blue: 21/255) : Color(red: 0.82, green: 0.35, blue: 0.09))
                            .frame(width: 267, height: 42)
                            .cornerRadius(100)
                            .padding()
                        
                        Button(action: {
                            viewModel.signIn(username: username, password: password)
                            viewModel.signInButtonClicked = true
                            
                            // Reset the signInButtonClicked flag after signIn method is called
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                viewModel.signInButtonClicked = false
                            }
                        }) {
                            Text("Sign In")
                                .font(Font.custom("Viga", size: 16))
                                .foregroundColor(Color.white)
                        }


                    }
                    .disabled(viewModel.signInButtonClicked)
                    .onHover { hovering in
                        isHovered = true
                        isHovered = hovering
                    }
                    
                    HStack {
                        Text("Don’t have an account? ")
                            .font(Font.custom("Univers LT Std", size: 14))
                            .foregroundColor(Color.white)
                        //change to register page later
                        NavigationLink(destination: exampleView()) {
                            Text("Sign Up")
                                .font(Font.custom("Univers LT Std", size: 14))
                                .foregroundColor(Color(red: 0.58, green: 0.88, blue: 1))
                        }
                    }
                    .frame(width: 260, height: 17)


                }
                .padding(.top, 130)
            }
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView(viewModel: SignInViewModel(shpeito:
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
