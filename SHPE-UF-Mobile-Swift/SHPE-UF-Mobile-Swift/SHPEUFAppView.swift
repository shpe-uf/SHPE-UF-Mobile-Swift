//
//  ContentView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/19/23.
//

import SwiftUI

struct SHPEUFAppView: View {
    let requestHandler = RequestHandler()
    var body: some View {
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


#Preview {
    SHPEUFAppView()
}


/*
 PointsView(vm: PointsViewModel(shpeito:
                                 SHPEito(id: "642f7f80e8839f0014e8be9b",
                                         name: "David Denis",
                                         points: 0,
                                         fallPoints: 0,
                                         springPoints: 0,
                                         summerPoints: 0,
                                         fallPercentile: 0,
                                         springPercentile: 0,
                                         summerPercentile: 0)
                               ))
 */
