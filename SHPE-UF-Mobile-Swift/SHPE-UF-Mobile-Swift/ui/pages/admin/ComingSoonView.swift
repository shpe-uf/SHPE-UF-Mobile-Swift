import SwiftUI

struct ComingSoonView: View{
    var body: some View{
        VStack{
            Text("Coming Soon!")
                .font(Font.custom("UniversLTStd", size: 48))
                .foregroundColor(.lorange)
        }
    }
}


#Preview{
    ComingSoonView()
}
