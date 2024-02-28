//
//  SHPE_UF_Mobile_SwiftApp.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

@main
struct SHPE_UF_Mobile_SwiftApp: App {
    var body: some Scene {
        WindowGroup {
            PointsView(vm: PointsViewModel(shpeito:
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
}
