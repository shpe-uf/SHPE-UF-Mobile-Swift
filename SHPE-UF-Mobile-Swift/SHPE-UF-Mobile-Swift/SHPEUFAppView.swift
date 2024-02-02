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
        PointsView(vm: PointsViewModel(shpeito: SHPEito(
            id: "650376888bda4600144075e9",
            name: "Ashley Guerra",
            points: 0,
            fallPercentile: 0,
            springPercentile: 0,
            summerPercentile: 0,
            fallPoints: 0,
            springPoints: 0,
            summerPoints: 0,
            username: "ashguerra"
        )))
    }
}


#Preview {
    SHPEUFAppView()
}
