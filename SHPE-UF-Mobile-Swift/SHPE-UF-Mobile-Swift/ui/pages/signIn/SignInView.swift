//
//  LoginView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 10/23/23.
//

import SwiftUI

struct SignInView: View {
    @StateObject var viewModel: SignInViewModel
    @State private var username = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding()
                .autocapitalization(.none)
            SecureField("Password", text: $password)
                .padding()
            
            Button("Sign In") {
                viewModel.signIn()
                viewModel.signInButtonClicked = true
            }
            .padding()
            .disabled(viewModel.signInButtonClicked) 
            
            if viewModel.signInButtonClicked {
                if username.isEmpty || password.isEmpty {
                    Text("Please enter username and password")
                } else {
                    if username == viewModel.shpeito.username && password == viewModel.shpeito.password {
                        Text("Success")
                    } else {
                        Text("Failure")
                    }
                }
            }
        }
        .padding()
    }
}


#Preview {
    SignInView(viewModel: SignInViewModel(shpeito:
                                    SHPEito(
                                        id: "62b90912595e0a0017dd02ee",
                                                           name: "David Vera",
                                                           points: 13,
                                                           fallPercentile: 85,
                                                           springPercentile: 94,
                                                           summerPercentile: 0,
                                                           fallPoints: 9,
                                                           springPoints: 4,
                                                           summerPoints: 0,
                                                           username: "dvera0322",
                                                           password: "test")
                                  ))
}
