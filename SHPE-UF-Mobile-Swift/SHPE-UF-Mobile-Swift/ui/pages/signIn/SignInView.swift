//
//  LoginView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 10/23/23.
//

import SwiftUI

struct SignInView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @StateObject var signInViewModel = SignInViewModel()
    var body: some View 
    {
        ZStack
        {
            if user.isEmpty
            {
                ZStack
                {
                    VStack
                    {
                        Image("shpe_logo")
                            .resizable()
                            .frame(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.width * 0.6)
                        TextField("Username", text: $signInViewModel.usernameInput)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                            .padding(.top, 60)
                        SecureField("Password", text: $signInViewModel.passwordInput)
                            .textFieldStyle(.roundedBorder)
                            .padding(.horizontal)
                        if let forgotPasswordURL = URL(string: "https://www.shpeuf.com/forgot")
                        {
                            Link("Forgot password?", destination: forgotPasswordURL)
                                .foregroundColor(.white)
                                .fontWeight(.light)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .multilineTextAlignment(.trailing)
                                .padding(.horizontal)
                        }
                        Button {
                            print("Finding you in our system...")
                        } label: {
                            HStack
                            {
                                Text("Log In")
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .fontWeight(.light)
                            }
                            .frame(maxWidth: .infinity)
                            .background(.black.opacity(0.5))
                            .cornerRadius(10)
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        Spacer()
                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width, height: 1)
                            .foregroundColor(.white)
                        HStack
                        {
                            Text("Not a Member?")
                                .foregroundColor(.white)
                                .fontWeight(.light)
                            Text("Register")
                                .foregroundColor(.white)
                                .fontWeight(.bold)
                                .onTapGesture {
                                    print("Taking you to registration page...")
                                }
                            Button(
                                action:
                                {
                                    signInViewModel.addUserItemToCore(viewContext: viewContext)
                                }, label: {
                                    Image(systemName: "plus")
                                })
                        }
                        .padding(.top, 20)

                    }
                    .zIndex(10)
                    .padding(.vertical, 80)
                    
                    //Gradient Background
                    LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
                    LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]), startPoint: .topLeading, endPoint: .bottom)
                }
                .ignoresSafeArea()
            }
            else
            {
                VStack
                {
                    Text(user[0].firstName ?? "Whoops")
                    Text(user[0].lastName ?? "Whoops Again")
                    Button(
                        action:
                        {
                            signInViewModel.deleteUserItemToCore(viewContext: viewContext, user: user[0])
                        }, label: {
                            Text("DELETE ME!!!")
                                .foregroundStyle(Color.red)
                        })
                }
            }
        }
        .onAppear
        {
            print(user)
            // Check core memory for presence of user
        }
    }
}

#Preview {
    SignInView()
}
