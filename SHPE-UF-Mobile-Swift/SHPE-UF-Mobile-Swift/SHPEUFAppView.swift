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
        PointsViewDark(vm: PointsViewModel(shpeito:
                                            SHPEito(
                                                username: "dvera0322",
                                                    password: "",
                                                    remember: "true",
                                                    photo: "",
                                                    firstName: "David",
                                                    lastName: "Denis",
                                                    year: "2",
                                                    major: "Computer Science",
                                                    id: "642f7f80e8839f0014e8be9b",
                                                    token: "",
                                                    confirmed: true,
                                                    updatedAt: "",
                                                    createdAt: "",
                                                    email: "denisdavid@ufl.edu",
                                                    fallPoints: 20,
                                                    summerPoints: 17,
                                                    springPoints: 30,
                                                    points: 67,
                                                    fallPercentile: 93,
                                                    springPercentile: 98,
                                                    summerPercentile: 78)))
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
