import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var scannedCode: String
    @State private var showAlert = false
    @State private var isScannerActive = true // Controls the visibility of the scanner

    var body: some View {
        ZStack {
            if isScannerActive {
                // QR Code Scanner
                CodeScannerView(
                    codeTypes: [.qr],
                    completion: { result in
                        switch result {
                        case .success(let code):
                            if code.string.starts(with: "[shpeuf]:") {
                                // Extract the portion after the prefix
                                let validCode = code.string.replacingOccurrences(of: "[shpeuf]:", with: "")
                                scannedCode = validCode
                                dismiss()
                            } else {
                                showAlert = true
                                isScannerActive = false // Deactivate scanner
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

                    // Corner Images Overlay
                    ZStack {
                        // Scanning Area Dimensions
                        let width = geometry.size.width * 0.6
                        let height = width
                        let xOffset = (geometry.size.width - width) / 2
                        let yOffset = (geometry.size.height - height) / 2 - 90

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
                    }
                }
            }
        }
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
