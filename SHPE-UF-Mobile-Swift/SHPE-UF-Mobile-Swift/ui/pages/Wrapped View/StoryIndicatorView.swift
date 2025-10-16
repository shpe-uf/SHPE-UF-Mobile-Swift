import SwiftUI

struct StoryIndicatorView: View {
    @Binding var showView: String
    let total: Int = 12
    let currentIndex: Int
    

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                Rectangle()
                    .fill(index == currentIndex ? Color.white : Color.gray.opacity(0.4))
                    .frame(height: 4)
                    .cornerRadius(2)
            }
        }
        .padding(.horizontal)
    }
}
