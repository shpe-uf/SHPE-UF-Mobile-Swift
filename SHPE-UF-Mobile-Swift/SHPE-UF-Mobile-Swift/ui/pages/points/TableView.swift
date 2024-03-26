//
//  TableView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 2/15/24.
//

import SwiftUI


struct TableView: View {
    
    var body: some View {
        NavigationView {
            
            VStack {
                ZStack(alignment: .topLeading) {
                    
                    
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 370, height: 350)
                        .background(Color(red: 0.93, green: 0.93, blue: 0.93))
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color(red: 0, green: 0.12, blue: 0.21), lineWidth: 1)
                        )
                    
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 370, height: 70)
                      .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                      .cornerRadius(15)
                      .overlay(
                        RoundedRectangle(cornerRadius: 15)
                          .inset(by: 0.5)
                          .stroke(Color(red: 0, green: 0.12, blue: 0.21), lineWidth: 1)
                      )
                    
                    VStack(spacing: 0) {
                        HStack {
                            Text("EVENT")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .frame(width: 80, height: 50)
                                .padding(.horizontal, 15)
                                
                            
                            
                            Text("DATE")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .frame(width: 90, height: 50)
                                .padding(.horizontal, 15)
                            
                            Text("POINTS")
                                .font(Font.custom("Univers LT Std", size: 23))
                                .foregroundColor(Color(red: 0, green: 0.18, blue: 0.31))
                                .padding(.horizontal, 15)
                            
                        }
                        
                       
                        
                        SingleEventView()
                        SingleEventView()
                        SingleEventView()
                        
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TableView()
    }
}
