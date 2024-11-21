import SwiftUI
import CodeScanner

struct QRCodeScannerView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var scannedCode: String

    var body: some View {
        ZStack {
            // QR Code Scanner
            CodeScannerView(
                codeTypes: [.qr],
                completion: { result in
                    switch result {
                    case .success(let code):
                        scannedCode = code.string
                        dismiss()
                    case .failure:
                        dismiss()
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)

            // Overlay with Corners and Back Button
            GeometryReader { geometry in
                VStack {
                    // Back Button
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "chevron.left")
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
                        let width = geometry.size.width * 0.6 // 60% of the screen width
                        let height = width // Square area
                        let xOffset = (geometry.size.width - width) / 2
                        let yOffset = (geometry.size.height - height) / 2 - 90 // Adjust vertically (-50 moves it upward)

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
    }
}
