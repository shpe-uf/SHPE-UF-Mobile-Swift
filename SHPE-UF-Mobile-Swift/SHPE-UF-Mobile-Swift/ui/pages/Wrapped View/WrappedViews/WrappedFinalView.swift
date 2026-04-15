

import SwiftUI

struct WrappedFinalView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var route: AppRoute
    
    
    var body: some View {
        VStack {
            Spacer()
            // Title
            Text("That’s a wrap 🎉")
                .font(.custom("Viga", size: 42, relativeTo: .title))
                .foregroundColor(.primary)
                .multilineTextAlignment(.center)
            
            Text("Thanks for being part of SHPE this year.")
                .font(.custom("Viga", size: 18, relativeTo: .body))
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            
            AsyncImage(url: URL(string: "https://shpeuf.s3.amazonaws.com/public/home/home-1.jpg"), scale: 3) { image in
                image
                    .resizable()
                    .scaledToFit()
                
            } placeholder: {
                ProgressView()
            }
            .frame(height: 233)
            .clipShape(.rect(cornerRadius: 25))
            
            Spacer()
            
            // Done Button
            Button {
                withAnimation(.linear) {
                    route = .home
                }
                
            } label: {
                Text("Done")
                    .font(.custom("Viga", size: 25, relativeTo: .body))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.profileOrange)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                
            }
            .padding()
            
        }
        .background(colorScheme == .dark ? Constants.darkModeBackground : Constants.BackgroundColor)
       
    }
}

#Preview {
    WrappedFinalView(route: .constant(.wrapped(.finale)))
        .preferredColorScheme(.light)
}
