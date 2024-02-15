//
//  PointsView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Jesus Lopez on 10/23/23.
//

import SwiftUI

struct PointsView: View {
    @StateObject var vm:PointsViewModel
    
    var body: some View
    {
        Text("\(vm.shpeito.name) Points")
            .font(.largeTitle)
        Spacer()
        
        Text("\(vm.points)")
        Spacer()
        
        VStack
        {
            // DELETE ME RIGHT AFTER
            HStack
            {
                Button {
                    vm.printEvents()
                } label: {
                    Text("Fetch Events")
                }
                .buttonStyle(.bordered)
                .padding()
            }
            
            HStack
            {
                Button {
                    vm.resetShpeitoPoints()
                } label: {
                    Text("Reset Points")
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button {
                    vm.setShpeitoPoints()
                } label: {
                    Text("Get Points From Server")
                }
                .buttonStyle(.bordered)
                .padding()
                
                Button {
                    vm.add5PointsToShpeito()
                } label: {
                    Text("Add 5 Points")
                }
                .buttonStyle(.bordered)
                .padding()

            }
            .padding()
        }
    }
}

#Preview {
    PointsView(vm: PointsViewModel(shpeito: 
                                    SHPEito(
                                        id: "64f7d5ce08f7e8001456248a",
                                        name: "Daniel Parra",
                                        points: 0)
                                  ))
}
