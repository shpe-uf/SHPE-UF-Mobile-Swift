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
                                                id: "642b9e6a12ab890014580b5c",
                                                name: "David Denis",
                                                points: 23,
                                                fallPercentile: 23,
                                                springPercentile: 0,
                                                summerPercentile: 56,
                                                fallPoints: 90,
                                                springPoints: 0,
                                                summerPoints: 0,
                                                username: "dparra1"
                                            )
                                          ))
        }
    }
}
