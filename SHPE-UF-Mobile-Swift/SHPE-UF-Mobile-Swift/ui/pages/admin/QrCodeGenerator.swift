//
//  Untitled.swift
//  SHPEsettingthingsup
//
//  Created by Evan Schroeder on 2/9/25.
//
import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins


// Testing the Qr Code
struct QRTestView: View {
    var code: String
    
    var body: some View {
        Image(uiImage: QrCodeGenerator(eventCode: code))
            .interpolation(.none)
            .resizable()
            .frame(width: 150, height: 150, alignment: .center)            
            
    }
}


func QrCodeGenerator(eventCode: String) -> UIImage {
    // Contatenate string
    let qrString = "[SHPEUF]:" + eventCode
    
    // This actually sets up teh qr code stuff
    let qrCodeGenerator = CIFilter.qrCodeGenerator()
    let data = qrString.data(using:.ascii)!
    let context = CIContext()
    qrCodeGenerator.setValue(data, forKey: "inputMessage")
    
    //Generates the image
    if let qrCodeImage = qrCodeGenerator.outputImage{
        if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent){
            return UIImage(cgImage: qrCodeCGImage)
        }
    }
    return UIImage(systemName: "xmark") ?? UIImage()
}

#Preview{
    QRTestView(code: "Meow")
}

