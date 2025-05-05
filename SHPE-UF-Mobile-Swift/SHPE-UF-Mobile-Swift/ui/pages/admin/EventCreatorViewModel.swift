//import Foundation
//import UIKit
//import CoreImage.CIFilterBuiltins
//
//class EventCreatorViewModel: ObservableObject {
//
//    // MARK: – Inputs
//    @Published var eventTitle:    String = ""
//    @Published var eventCode:     String = ""
//    @Published var eventCategory: String = ""
//    @Published var eventPoints:   String = ""
//    @Published var eventDate:     String = ""
//
//    // MARK: – Outputs
//    @Published var fieldErrors:   [String] = []
//    @Published var qrImage:       UIImage? = nil
//    @Published var showingQR:     Bool     = false
//
//    private let requestHandler = RequestHandler()
//
//    // MARK: – Validation Regex
//    private let validNamePattern = #"^[A-Za-z0-9\s\-\/]{6,50}$"#
//    private let validCodePattern = #"^[A-Za-z0-9]{6,50}$"#
//
//    /// Validate required + regex only (no server check here)
//    func validateFields() {
//        fieldErrors = []
//
//        // Required
//        if eventTitle.isEmpty    { fieldErrors.append("Title is required.") }
//        if eventCode.isEmpty     { fieldErrors.append("Code is required.") }
//        if eventCategory.isEmpty { fieldErrors.append("Category is required.") }
//        if eventDate.isEmpty     { fieldErrors.append("Expires in is required.") }
//
//        // Regex
//        if !eventTitle.isEmpty,
//           eventTitle.range(of: validNamePattern, options: .regularExpression) == nil {
//            fieldErrors.append(
//                "Event name must be at least 6 characters, max 50. No special characters, except for hyphens (-) and dashes (/)."
//            )
//        }
//        if !eventCode.isEmpty,
//           eventCode.range(of: validCodePattern, options: .regularExpression) == nil {
//            fieldErrors.append(
//                "Event code must be at least 6 characters, max 50. No special characters."
//            )
//        }
//    }
//
//    /// Performs a GraphQL mutation.
//    /// - When `requestFlag=="false"` it only does a duplicate‐check dry‐run.
//    /// - When `requestFlag=="true"` it actually writes and then generates the QR.
//    func createEvent(
//        requestFlag: String,
//        onSuccess: @escaping ()->Void
//    ) {
//        // build input
//        let pts = Int(eventPoints) ?? 0
//        let gqlInput = SHPESchema.CreateEventInput(
//            name:       eventTitle,
//            code:       eventCode,
//            category:   eventCategory,
//            points:     String(pts),
//            expiration: eventDate,
//            request:    requestFlag
//        )
//
//        // send mutation
//        requestHandler.createEvent(input: gqlInput) { [weak self] result in
//            DispatchQueue.main.async {
//                if let err = result["error"] as? String {
//                    // duplicate‐title or other server error
//                    let msg = err.lowercased().contains("exists")
//                        ? "An event with that name already exists."
//                        : err
//                    self?.fieldErrors = [msg]
//                    return  // pop-up stays open
//                }
//
//                // on real write, generate QR + show it
//                if requestFlag == "true" {
//                    self?.qrImage     = QrCodeGenerator(eventCode: self?.eventCode ?? "")
//                    self?.showingQR   = true
//                }
//
//                onSuccess()  // hides ConfirmPopUp
//            }
//        }
//    }
//}
//
//// QrCodeGenerator remains unchanged
//
//
//func QrCodeGenerator(eventCode: String, size: CGFloat = 200) -> UIImage {
//    // 1) Build the raw QR CIImage
//    let qrString = "[SHPEUF]:" + eventCode
//    let data = qrString.data(using: .ascii)!
//    let filter = CIFilter.qrCodeGenerator()
//    filter.setValue(data, forKey: "inputMessage")
//    guard let outputImage = filter.outputImage else {
//        return UIImage(systemName: "xmark")!
//    }
//
//    // 2) Scale it up so its pixels match your desired size
//    let originalSize = outputImage.extent.size
//    let scaleX = size / originalSize.width
//    let scaleY = size / originalSize.height
//    let scaledImage = outputImage.transformed(
//        by: CGAffineTransform(scaleX: scaleX, y: scaleY)
//    )
//
//    // 3) Render that into a CGImage
//    let context = CIContext()
//    guard let cgImg = context.createCGImage(scaledImage, from: scaledImage.extent) else {
//        return UIImage(systemName: "xmark")!
//    }
//
//    // 4) Return a UIImage with no further interpolation
//    return UIImage(cgImage: cgImg, scale: 1, orientation: .up)
//}
// EventCreatorViewModel.swift

import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

class EventCreatorViewModel: ObservableObject {

    // MARK: – Inputs
    @Published var eventTitle:    String = ""
    @Published var eventCode:     String = ""
    @Published var eventCategory: String = ""
    @Published var eventPoints:   String = ""
    @Published var eventDate:     String = ""

    // MARK: – Outputs
    @Published var fieldErrors:   [String] = []
    @Published var qrImage:       UIImage?   = nil
    @Published var showingQR:     Bool       = false

    private let requestHandler = RequestHandler()

    func validateFields() {
        fieldErrors = []

        // Regex
        let validNamePattern = "^[A-Za-z0-9\\-\\/]{6,50}$"
        if !eventTitle.isEmpty,
           eventTitle.range(of: validNamePattern, options: .regularExpression) == nil {
            fieldErrors.append(
                "Event name must be at least 6 characters, max 50. No special characters, except for hyphens (-) and slashes (/)."
            )
        }
        let validCodePattern = "^[A-Za-z0-9]{6,50}$"
        if !eventCode.isEmpty,
           eventCode.range(of: validCodePattern, options: .regularExpression) == nil {
            fieldErrors.append(
                "Event code must be at least 6 characters, max 50. No special characters."
            )
        }

        // (Optional) local duplicate check, if you want to prevent the round-trip:
        // if existingTitles.contains(eventTitle) {
        //     fieldErrors.append("This title already exists")
        // }
    }

    func createEvent(requestFlag: String, onSuccess: @escaping ()->Void) {
        // build input
        let pts = Int(eventPoints) ?? 0
        let gqlInput = SHPESchema.CreateEventInput(
            name:       eventTitle,
            code:       eventCode,
            category:   eventCategory,
            points:     String(pts),
            expiration: eventDate,
            request:    requestFlag
        )

        // send mutation
        requestHandler.createEvent(input: gqlInput) { [weak self] result in
            DispatchQueue.main.async {
                // 1) Check specifically for the "exists" error first
                if let err = result["error"] as? String,
                   err.lowercased().contains("exists") {
                    var errs = self?.fieldErrors ?? []
                    errs.append("This title already exists")
                    self?.fieldErrors = errs
                    return
                }
                // 2) Any other server error
                if let err = result["error"] as? String {
                    self?.fieldErrors = [err]
                    return
                }

                // 3) on real write, generate QR + show it
                if requestFlag == "true" {
                    self?.qrImage     = QrCodeGenerator(eventCode: self?.eventCode ?? "")
                    self?.showingQR   = true
                }

                onSuccess()  // hides ConfirmPopUp
            }
        }
    }
}

// QrCodeGenerator remains unchanged
func QrCodeGenerator(eventCode: String, size: CGFloat = 200) -> UIImage {
    let qrString = "[SHPEUF]:" + eventCode
    let data = qrString.data(using: .ascii)!
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(data, forKey: "inputMessage")
    guard let outputImage = filter.outputImage else {
        return UIImage(systemName: "xmark")!
    }
    let originalSize = outputImage.extent.size
    let scaleX = size / originalSize.width
    let scaleY = size / originalSize.height
    let scaledImage = outputImage.transformed(
        by: CGAffineTransform(scaleX: scaleX, y: scaleY)
    )
    let context = CIContext()
    guard let cgImg = context.createCGImage(scaledImage, from: scaledImage.extent) else {
        return UIImage(systemName: "xmark")!
    }
    return UIImage(cgImage: cgImg, scale: 1, orientation: .up)
}
