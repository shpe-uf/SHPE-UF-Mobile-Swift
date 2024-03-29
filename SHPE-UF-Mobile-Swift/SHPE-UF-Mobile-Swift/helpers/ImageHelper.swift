//
//  ImageHelper.swift
//  SHPE-UF-Mobile-Swift
//
//  Created by Daniel Parra on 3/28/24.
//

import Foundation
import UIKit

extension UIImage {
    
    func sizeInBytes() -> Int? {
            guard let data = self.jpegData(compressionQuality: 1) else {
                return nil
            }
            return data.count
        }
    
    func resize() -> UIImage? {
            let newSize = CGSize(width: self.size.width / 16, height: self.size.height / 16)
            let renderer = UIGraphicsImageRenderer(size: newSize)
            return renderer.image { (context) in
                self.draw(in: CGRect(origin: .zero, size: newSize))
            }
        }
    
    func cropToSquare() -> UIImage? {
            print(self.size)
            // Calculate the crop rectangle
            let imageSize = self.size
            let smallestSide = min(imageSize.width, imageSize.height)
            let cropRect = CGRect(x: (imageSize.width) / 2,
                                  y: (imageSize.height) / 2,
                                  width: smallestSide,
                                  height: smallestSide)
            
            // Perform the crop
            if let cgImage = self.cgImage?.cropping(to: cropRect) {
                print(UIImage(cgImage: cgImage).size)
                return UIImage(cgImage: cgImage)
            } else {
                return nil
            }
        }
    
    func convertToRGB() -> UIImage? {
        // Ensure the image is in the correct orientation
        guard let cgImage = self.cgImage else { return nil }
        
        // Create a bitmap context with RGB color space
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipFirst.rawValue)
        guard let context = CGContext(data: nil,
                                      width: cgImage.width,
                                      height: cgImage.height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: cgImage.bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        
        // Draw the image into the context
        let rect = CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height)
        context.rotate(by: .pi / 2)
        context.draw(cgImage, in: rect)
        
        // Create a new CGImage from the context
        guard let newCGImage = context.makeImage() else { return nil }
        
        // Convert the CGImage back to UIImage
        let newUIImage = UIImage(cgImage: newCGImage)
        print("RGB Conversion: \(String(describing: newUIImage.sizeInBytes()))")
        return newUIImage
    }
}
