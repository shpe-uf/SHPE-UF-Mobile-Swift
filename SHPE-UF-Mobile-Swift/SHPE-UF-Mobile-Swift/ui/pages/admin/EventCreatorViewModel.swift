import Foundation
import SwiftUI
import CoreImage.CIFilterBuiltins

class EventCreatorViewModel:ObservableObject {
    
    @Published var eventTitle:    String = ""
    @Published var eventCode:     String = ""
    @Published var eventCategory: String = ""
    @Published var eventPoints:   String = ""
    @Published var eventDate:     String = ""
    @Published var qrImage: UIImage? = nil
    
    func SaveEvent(){
        print("EventSaved")
    }
    
    func CreateEvent(){
       qrImage = QrCodeGenerator(eventCode: eventCode)
    }

}

func QrCodeGenerator(eventCode: String) -> UIImage {
    // Contatenate string
    let qrString = "[SHPEUF]:" + eventCode
    
    // sets up the qr code stuff
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
