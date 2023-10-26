//
//  SignInViewModel.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import Foundation

final class SignInViewModel: ObservableObject {
    @Published var usernameInput:String = ""
    @Published var passwordInput:String = ""
}
