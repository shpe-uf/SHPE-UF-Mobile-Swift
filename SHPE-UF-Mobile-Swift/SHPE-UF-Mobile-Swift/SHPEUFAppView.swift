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
                                            id: "5f595bc16b307400179595ab",
                                            name: "David Denis",
                                            points: 23,
                                            fallPercentile: 0,
                                            springPercentile: 56,
                                            summerPercentile: 0,
                                            fallPoints: 0,
                                            springPoints: 0,
                                            summerPoints: 0,
                                            username: "denis_david"
                                        )
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
