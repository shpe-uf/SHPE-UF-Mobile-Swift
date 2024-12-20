import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var scannedCode: String
    @State private var showAlert = false
    @State private var isScannerActive = true // Controls the visibility of the scanner
    @State private var corners: [CGPoint] = []
    @State private var image:UIImage? = nil

    var body: some View {
        ZStack {
            if isScannerActive {
                // QR Code Scanner
                CodeScannerView(
                    codeTypes: [.qr],
                    completion: { result in
                        switch result {
                        case .success(let code):
                            /// Take the corners from the code message
                            corners = code.corners
                            image = code.image
                            /// Place the corners over those points in the image and wait 2 seconds to check if the QR code is valid
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1)
                            {
                                if code.string.starts(with: "[SHPEUF]:") {
                                    // Extract the portion after the prefix
                                    let validCode = code.string.replacingOccurrences(of: "[SHPEUF]:", with: "")
                                    scannedCode = validCode
                                    image = nil
                                    dismiss()
                                } else {
                                    showAlert = true
                                    isScannerActive = false // Deactivate scanner
                                    image = nil
                                }
                            }
                        case .failure:
                            isScannerActive = false // Reset scanner on failure
                        }
                    }
                )
                .edgesIgnoringSafeArea(.all)
            }

            // Overlay with Corners and Back Button
            GeometryReader { geometry in
                VStack {
                    // Back Button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image("Back")
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                        }
                        .padding(.leading, 20)

                        Spacer()
                    }
                    .padding(.top, 40)

                    Spacer()
                }
                .zIndex(999)
                
                let width = geometry.size.width * 0.6
                let height = width
                let xOffset = (geometry.size.width - width) / 2
                let yOffset = (geometry.size.height - height) / 2

                // Top-Left Corner
                Image("qr_code_top_left_corner")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(x: xOffset, y: yOffset)

                // Top-Right Corner
                Image("qr_code_top_right_corner")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(x: xOffset + width, y: yOffset)

                // Bottom-Left Corner
                Image("qr_code_bottom_left_corner")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(x: xOffset, y: yOffset + height)

                // Bottom-Right Corner
                Image("qr_code_bottom_right_corner")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .position(x: xOffset + width, y: yOffset + height)
                
                // Corner Images Overlay
                if image != nil
                {
                    // Calculate scaling factors to fit the image within the screen
                    let imageAspectRatio = image!.size.width / image!.size.height
                    let screenAspectRatio = geometry.size.width / geometry.size.height
                    
                    let scale: CGFloat = imageAspectRatio > screenAspectRatio ? geometry.size.height / image!.size.height : geometry.size.width / image!.size.width
                    let offsetX: CGFloat = imageAspectRatio > screenAspectRatio ? (geometry.size.width - (image!.size.width * scale)) / 2 :  0
                    let offsetY: CGFloat = imageAspectRatio > screenAspectRatio ? 0 : (geometry.size.height - (image!.size.height * scale)) / 2
                    
                    
                    ZStack {
                        // Scanning Area Dimensions
                        // Display the image
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        
                        // Place corners on image
                        let width:CGFloat = geometry.size.width
                        let height:CGFloat = geometry.size.height
                        
                        let cornerAttributes: [String] = ["qr_code_top_left_corner", "qr_code_bottom_left_corner", "qr_code_bottom_right_corner", "qr_code_top_right_corner"]
                        
                        ForEach(corners.indices, id:\.self)
                        {
                            corner_i in
                            
                            let rescale_factor = 1.04
                            let x = (1-corners[corner_i].y) * (image!.size.width * scale) * rescale_factor
                            let y = (corners[corner_i].x) * (image!.size.height * scale) * rescale_factor
                            
                            Image(cornerAttributes[corner_i])
                                .resizable()
                                .frame(width: 10, height: 10)
                                .position(x: x, y: y)
                        }
                    }
                    .zIndex(100)
                }
            }
        }
        .background(Color.black)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Invalid Code"),
                message: Text("The scanned QR code is invalid."),
                dismissButton: .default(Text("OK"), action: {
                    isScannerActive = true // Reactivate scanner after dismissing the alert
                })
            )
        }
    }
}
