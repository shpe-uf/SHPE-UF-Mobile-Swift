//
//  TempSignOutView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/10/24.
//

import SwiftUI

struct TempSignOutView: View {
    @EnvironmentObject var manager: DataManager
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @StateObject var viewModel:CheckCoreViewModel = CheckCoreViewModel()
    var body: some View {
        VStack
        {
            Text("Profile Page")
            Text("Sign Out")
                .padding()
                .foregroundStyle(.red)
                .onTapGesture {
                    if !user.isEmpty
                    {
                        viewModel.deleteUserItemToCore(viewContext: viewContext, user: user[0])
                        AppViewModel.appVM.setPageIndex(index: 0)
                    }
                    else
                    {
                        print("Expected User in Core")
                    }
                }
        }
    }
}

#Preview {
    TempSignOutView()
}
