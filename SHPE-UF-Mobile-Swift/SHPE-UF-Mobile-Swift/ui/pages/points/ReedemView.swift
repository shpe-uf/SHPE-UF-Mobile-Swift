//
//  ReedemView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 11/16/23.
//

import SwiftUI

struct ReedemView: View {
    
    @State var code: String = "" // stores event code
    @State private var numberOfGuests = 0 // track number of guests
    @Environment(\.dismiss) var dismiss
    
    @StateObject var vm : PointsViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CoreUserEvent>
    
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                  .foregroundColor(.clear)
                  .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                
                VStack {
                    
                    Rectangle()
                        .foregroundStyle(Color.white)
                        .frame(width: 100, height: 4)
                        .cornerRadius(5)
                        .padding(.top, 20)
                    
                    Spacer()
                    
                    // Title
                    Text("REDEEM POINTS")
                      .font(.system(size: 35)).italic().bold()
                      .multilineTextAlignment(.center)
                      .foregroundColor(Color(red: 0.93, green: 0.93, blue: 0.93))
                      .frame(alignment: .top)
                    
                    // Event Code Text Field
                    TextField("Event Code", text: $code)
                        .frame(height: 55)
                        .background(Color.white)
                        .font(Font.custom("Univers LT Std 55 Oblique", size: 20))
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                    
                    if vm.invalidCode && !code.isEmpty
                    {
                        Text("The event code provided is either invalid or has expired!")
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                            .foregroundStyle(Color(red: 0, green: 0.12, blue: 0.21))
                    }
    
                    Text("Guests")
                        .padding(.top, 30)
                        .foregroundStyle(.white)

                    // Guests Container
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: 200, maxHeight: 70)
                            .background(Color.white)
                            .cornerRadius(10)
                            .padding(5)
                        
                        HStack {
                            // Subtract Button
                            Button(action: {
                                if numberOfGuests > 0 {
                                    numberOfGuests -= 1
                                }
                            })
                            {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 45, height: 8)
                                    .background(Color(red: 0, green: 0.12, blue: 0.21))
                            }
                            .padding(.trailing, 3)

                            // Left Divider
                            Image("Line 6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55)
                            
                            // "Guests"
                            Text("\(numberOfGuests)")
                              .font(
                                Font.custom("Inter", size: 30)
                                  .weight(.medium)
                              )
                              .frame(width: 50, height: 50)

                              .multilineTextAlignment(.center)
                              .foregroundColor(Color(red: 0.28, green: 0.27, blue: 0.27).opacity(0.71))
                            
                            // Right Divider
                            Image("Line 6")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 55)
                            
                            // Add Guests Button
                            Button {
                                if numberOfGuests <= 4 {
                                    numberOfGuests += 1
                                }
                            } label: {
                                Image("plus")
                                    .resizable()
                                    .padding(.leading, 5)
                                    .frame(width: 45, height: 45)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Redeem Button
                    Button {
                        vm.redeemCode(code: code, guests: numberOfGuests, coreEvents: coreEvents, viewContext: viewContext, dismiss: dismiss)
                    } label: {
                        Text("Redeem")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .font(Font.custom("Univers LT Std 45 Light", size: 20))
                            .background(Color(red: 0, green: 0.12, blue: 0.21))
                            .foregroundColor(.white)
                            .cornerRadius(22)
                    }
                    .padding(.leading, 30)
                    .padding(.trailing, 30)
                    Spacer()
                }
            }
            .ignoresSafeArea()
            .navigationTitle("")
            .onDisappear(perform: {
                vm.invalidCode = false
            })
        }
    }
}

#Preview {
    ReedemView(vm: PointsViewModel(shpeito:
                                    SHPEito()
                                  ))
}
