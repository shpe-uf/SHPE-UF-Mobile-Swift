//
//  MarqueeView.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by David Denis on 12/17/25.
//

import SwiftUI

struct MarqueeView : View {
    private let text: String
    
    private let font: UIFont
    
    private let separation: String
    
    private let scrollDurationFactor: CGFloat
    
    @State private var animate = false
    
    @State private var size = CGSize.zero
    
    private var scrollDuration: CGFloat {
        stringWidth * scrollDurationFactor
    }
    
    private var stringWidth: CGFloat {
        (text + separation).widthOfString(usingFont: font)
    }
    
    private func shouldAnimated(_ width: CGFloat) -> Bool {
        width < stringWidth
    }
    
    static private let defaultSeparation = " "
    
    static private let defaultScrollDurationFactor: CGFloat = 0.01
    
    init(_ text: String,
         font: UIFont = UIFont.preferredFont(forTextStyle: .body, compatibleWith: .current),
         separation: String = defaultSeparation,
         scrollDurationFactor: CGFloat = defaultScrollDurationFactor)         {
        self.text = text
        self.font = font
        self.separation = separation
        self.scrollDurationFactor = scrollDurationFactor
        self.animate = animate
    }
    
    init(_ text: String,
         textStyle: UIFont.TextStyle,
         separation: String = defaultSeparation,
         scrollDurationFactor: CGFloat = defaultScrollDurationFactor)
    {
        self.init(text, font: UIFont.preferredFont(forTextStyle: textStyle, compatibleWith: .current), separation: separation, scrollDurationFactor: scrollDurationFactor)
    }
    
    var body : some View {
        GeometryReader { geometry in
            let shouldAnimated = shouldAnimated(geometry.size.width)
            
            scrollItem(offset: self.animate ? -stringWidth : 0)
                .task {
                    size = geometry.size
                    if shouldAnimated  {
                        self.animate = true
                    }
                }
            
            if shouldAnimated{
                scrollItem(offset: self.animate ? 0 : stringWidth)
            }
        }
    }
    
    private func scrollItem(offset: CGFloat) -> some View {
        Text(text + separation)
                .lineLimit(1)
                .font(Font(uiFont: font))
                .offset(x: -offset)
                .animation(
                    Animation.linear(duration: scrollDuration)
                        .repeatForever(autoreverses: false),
                    value: animate
                )
                .fixedSize(horizontal: true, vertical: false)
                .frame(minWidth: 0, maxWidth: .infinity,
                       minHeight: 0, maxHeight: .infinity,
                       alignment: .center)
           
    }
}

private extension String {
    
    func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
}

private extension Font {
    init(uiFont: UIFont) {
        self = Font(uiFont as CTFont)
    }
}


#Preview {
    MarqueeView("SHPE")
}
