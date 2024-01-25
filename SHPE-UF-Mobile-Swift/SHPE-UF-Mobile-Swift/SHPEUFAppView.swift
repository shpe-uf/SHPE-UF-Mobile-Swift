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
        PointsView(vm: PointsViewModel(shpeito: SHPEito(id: "64f7d5ce08f7e8001456248a", name: "Daniel Parra", points: 0)))
    }
}


#Preview {
    SHPEUFAppView()
}
