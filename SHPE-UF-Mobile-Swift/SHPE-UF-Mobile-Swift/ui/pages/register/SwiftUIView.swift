
import Foundation
import SwiftUI


struct AcademicView : View
{
    @Environment(\.presentationMode) var isPresented
    @StateObject var viewModel: RegisterViewModel
    
    var body: some View
    {
        ZStack
        {
            Color(red: 0, green: 0.12, blue: 0.21)
                .ignoresSafeArea()
            VStack
            {
                
                HStack
                {
                    Button
                    {
                        isPresented.wrappedValue.dismiss()
                        
                    }
                    label:
                    {
                        Image(systemName: "arrowshape.turn.up.left.fill")
                            .foregroundStyle(Color.gray)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .cornerRadius(30)
                    }
                    .padding(.horizontal)

                    
                    NavigationLink(destination: ConfirmationView(viewModel: self.viewModel), isActive: $viewModel.shouldNavigate2)
                    {
                        Button(action:
                        {
                           
                            if viewModel.isAcademicValid()
                            {
                                viewModel.registerUser()
                                viewModel.shouldNavigate2 = true
                            }
                        })
                        {
                            Text("Complete Registration")
                              .font(Font.custom("Univers LT Std", size: 16))
                              .foregroundColor(.white)
                              .frame(width: 250, height: 42)
                              .background(Color(red: 0.82, green: 0.35, blue: 0.09))
                              .cornerRadius(20)
                        }
                    }
                   .isDetailLink(false)
                }
                .padding(.bottom, 40)
            
            }
            .background(Color(red: 0, green: 0.12, blue: 0.21))
        }
        .onAppear
        {
            viewModel.viewIndex = 2
        }

    }
}

