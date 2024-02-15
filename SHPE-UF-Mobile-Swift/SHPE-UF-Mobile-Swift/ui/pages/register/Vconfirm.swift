//import Foundation
//import SwiftUI
//struct ConfirmationView: View
//{
//    @Environment(\.presentationMode) var isPresented
//    @StateObject var viewModel: RegisterViewModel
//    
//    var body: some View
//    {
//        ZStack
//        {
//            // Background Gradients
//            LinearGradient(gradient: Gradient(colors: [Color("rblue"), Color("rorange")]), startPoint: .topLeading, endPoint: .bottomTrailing)
//                .ignoresSafeArea()
//
//            LinearGradient(gradient: Gradient(colors: [Color("lorange").opacity(0.1), Color("lblue").opacity(0.4)]), startPoint: .bottomLeading, endPoint: .topTrailing)
//                .ignoresSafeArea()
//
//            VStack(spacing: 30) { // Increased spacing for better layout
//                // SHPE Logo Image (Made larger)
//                Image("shpe_logo")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit) // Maintain aspect ratio
//                    .frame(width: UIScreen.main.bounds.width * 0.5) // Increase width to 50% of screen width
//
//                // Text with enhanced design
//                Text("Check your email for confirmation")
//                    .font(.largeTitle) // Large title font
//                    .fontWeight(.bold) // Bold font weight
//                    .foregroundColor(Color.white) // White color for contrast
//                    .multilineTextAlignment(.center) // Center alignment for multiline text
//                    .padding()
//                    .shadow(color: Color.black.opacity(0.7), radius: 10, x: 5, y: 5) // Shadow for depth
//                    .scaleEffect(1.1) // Slightly larger scale for emphasis
//                    .animation(Animation.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: UUID()) // Gentle scaling animation
//            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity) // VStack takes the full size of the parent view
//            .padding(.vertical) // Padding to ensure content does not touch the screen edges
//        }
//    }
//}
