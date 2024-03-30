//
//  CheckCore.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/10/24.
//

import SwiftUI

struct CheckCore: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.colorScheme) private var colorScheme
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @StateObject var appVM:AppViewModel = AppViewModel.appVM
    @StateObject var viewModel:CheckCoreViewModel = CheckCoreViewModel()
    
    var body: some View {
        Image("StartScreen")
            .resizable()
            .frame(width: UIScreen.main.bounds.width)
            .aspectRatio(contentMode: .fill)
            .ignoresSafeArea()
            .onAppear(perform: {
//                appVM.darkMode = colorScheme == .dark
                viewModel.checkUserInCore(user: user)
            })
            
    }
}

#Preview {
    CheckCore()
}
