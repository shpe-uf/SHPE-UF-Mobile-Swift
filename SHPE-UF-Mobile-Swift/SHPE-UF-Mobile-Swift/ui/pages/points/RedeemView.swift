import SwiftUI

struct RedeemView: View {
    
    @State var code: String = "" // Stores event code
    @State private var numberOfGuests = 0 // Track number of guests
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @Namespace private var nameSpace
    
    @State private var isPresentingScanner = false // State for presenting the QR code scanner
    @StateObject var vm: PointsViewModel
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: []) private var user: FetchedResults<User>
    @FetchRequest(sortDescriptors: []) private var coreEvents: FetchedResults<CoreUserEvent>
    
    var body: some View {
        
        
        VStack {
            Spacer()
            
            // Title
            Text("REDEEM POINTS")
                .font(Font.custom("Viga-Regular", size: 30)).italic().bold()
                .multilineTextAlignment(.center)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .frame(alignment: .top)
            
            // Event Code Text Field
            HStack {
                if #available(iOS 26.0, *) {
                    Button {
                        isPresentingScanner = true // Open QR Code scanner
                    }
                    label: {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .matchedTransitionSource(id: "qr", in: nameSpace)
                    .padding()
                    .buttonStyle(.automatic)
                    
                } else {
                    Button {
                        isPresentingScanner = true // Open QR Code scanner
                    }
                    label: {
                        Image(systemName: "qrcode.viewfinder")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                    }
                    .padding()
                }
                
                // TextField for Event Code
                TextField("", text: $code, prompt: Text("Event Code").foregroundColor(.gray))
                    .font(Font.custom("Viga-Regular", size: 20))
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.trailing, 70)
            }
            .frame(height: 55)
            .background(Color.white)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            
            if vm.invalidCode && !code.isEmpty {
                Text("The event code provided is either invalid or has expired!")
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
            }
            
            Text("Guests")
                .padding(.top, 30)
                .font(Font.custom("Viga-Regular", size: 20)).italic().bold()
            
            // Guests Container
            ZStack {
                
                HStack {
                    // Subtract Button
                    Button {
                        if numberOfGuests > 0 {
                            withAnimation {
                                numberOfGuests -= 1
                            }
                        }
                    } label: {
                        Image(systemName: "minus")
                            .font(.system(size: 30)).bold()
                            .foregroundStyle(numberOfGuests > 0 ? colorScheme == .dark ? .white : .black : .gray.opacity(0.2))
                        
                    }
                    .disabled(numberOfGuests == 0)
                    
                    // Left Divider
                    Image("Line 6")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    
                    // "Guests"
                    Text("\(numberOfGuests)")
                        .contentTransition(.numericText())
                        .font(Font.custom("Viga-Regular", size: 30)).italic().bold()
                        .frame(width: 50, height: 50)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(colorScheme == .dark ? .white : .black)
                    
                    // Right Divider
                    Image("Line 6")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 55)
                    
                    // Add Guests Button
                    Button {
                        withAnimation {
                            if numberOfGuests <= 4 {
                                numberOfGuests += 1
                            }
                        }
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 30)).bold()
                            .foregroundStyle(numberOfGuests < 5 ? colorScheme == .dark ? .white : .black : .gray.opacity(0.2))
                    }
                    .disabled(numberOfGuests == 5)
                }
            }
            .padding(.bottom, 30)
            
            if #available(iOS 26.0, *) {
                Button {
                    vm.redeemCode(code: code, guests: numberOfGuests, coreEvents: coreEvents, viewContext: viewContext, dismiss: dismiss)
                } label: {
                    ZStack {
                        Text("Redeem Code")
                            .font(Font.custom("Viga-Regular", size: 20)).bold()
                            .foregroundStyle(.white)
                    }
                    
                }
                .frame(width: 250, height: 50)
                .glassEffect(.clear.tint(Constants.orange).interactive(), in: .rect(cornerRadius: 16))
                
                .padding(.top, 25)
                
            } else {
                Button {
                    vm.redeemCode(code: code, guests: numberOfGuests, coreEvents: coreEvents, viewContext: viewContext, dismiss: dismiss)
                } label: {
                    ZStack {
                        Text("Redeem Code")
                            .font(Font.custom("Viga-Regular", size: 20)).bold()
                            .foregroundStyle(.white)
                    }
                    
                }
                .frame(width: 250, height: 50)
                .padding(.top, 25)
            }
            
            Spacer()
        }
        .sheet(isPresented: $isPresentingScanner) {
            if #available(iOS 26.0, *) {
                QRCodeScannerView(scannedCode: $code) // Present QR Code scanner
                    .navigationTransition(.zoom(sourceID: "qr", in: nameSpace))
            } else {
                // Fallback on earlier versions
                QRCodeScannerView(scannedCode: $code) // Present QR Code scanner
            }
        }
        .onDisappear(perform: {
            vm.invalidCode = false
        })
    }
}

#Preview {
    RedeemView(vm: PointsViewModel(shpeito: SHPEito()))
}
