import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

/// ViewModel for the “Create Event” screen:
/// Manages form inputs, validation, GraphQL mutation, and QR generation.
class EventCreatorViewModel: ObservableObject {
    // MARK: - User Inputs (bound to form fields)
    @Published var eventTitle    = ""  // Name of the event
    @Published var eventCode     = ""  // Unique code identifier
    @Published var eventCategory = ""  // Selected category
    @Published var eventPoints   = ""  // Points awarded
    @Published var eventDate     = ""  // Expiration selection

    // MARK: - Outputs (observed by the view)
    @Published var fieldErrors: [String] = []  // Validation or server errors
    @Published var qrImage: UIImage?         // Generated QR code
    @Published var showingQR = false         // Controls QR sheet display

    private let requestHandler = RequestHandler()  // Handles network calls

    // MARK: - Validation Patterns
    private let validNamePattern = #"^[A-Za-z0-9\s\-\/]{6,50}$"#  // Title rules
    private let validCodePattern = #"^[A-Za-z0-9]{6,50}$"#            // Code rules

    /// Validates all form fields:
    /// • Checks required inputs
    /// • Applies regex for title and code formats
    func validateFields() {
        fieldErrors = []  // Reset errors

        // Required-field checks
        if eventTitle.isEmpty    { fieldErrors.append("Title is required.") }
        if eventCode.isEmpty     { fieldErrors.append("Code is required.") }
        if eventCategory.isEmpty { fieldErrors.append("Category is required.") }
        if eventDate.isEmpty     { fieldErrors.append("Expires in is required.") }

        // Regex checks
        if !eventTitle.isEmpty,
           eventTitle.range(of: validNamePattern, options: .regularExpression) == nil {
            fieldErrors.append(
                "Event name must be 6–50 chars; letters, numbers, hyphens, or slashes only."
            )
        }
        if !eventCode.isEmpty,
           eventCode.range(of: validCodePattern, options: .regularExpression) == nil {
            fieldErrors.append(
                "Event code must be 6–50 alphanumeric characters."
            )
        }
    }

    /// Creates the event via GraphQL mutation:
    /// 1. Re-validates fields
    /// 2. Sends mutation on success
    /// 3. Handles duplicate-name errors
    /// 4. Generates and displays QR on success
    func createEvent(onSuccess: @escaping ()->Void = {}) {
        validateFields()
        guard fieldErrors.isEmpty else { return }  // Abort if errors exist

        // Convert points to int (default 0)
        let pts = Int(eventPoints) ?? 0
        let input = SHPESchema.CreateEventInput(
            name:       eventTitle,
            code:       eventCode,
            category:   eventCategory,
            points:     String(pts),
            expiration: eventDate,
            request:    "true"
        )

        // Perform network call
        requestHandler.createEvent(input: input) { [weak self] result in
            DispatchQueue.main.async {
                // Handle server-side error
                if let err = result["error"] as? String {
                    let message = err.lowercased().contains("exists")
                        ? "An event with that name already exists."  // Friendly duplicate message
                        : err
                    self?.fieldErrors = [message]
                    return
                }
                // On success, generate QR and show sheet
                self?.qrImage   = QrCodeGenerator(eventCode: self?.eventCode ?? "")
                self?.showingQR = true
                onSuccess()
            }
        }
    }
}

/// Generates a QR code image from the given event code:
/// • Prepends a fixed tag
/// • Scales to desired size without interpolation
func QrCodeGenerator(eventCode: String, size: CGFloat = 200) -> UIImage {
    let raw = "[SHPEUF]:" + eventCode  // Payload format
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(raw.data(using: .ascii), forKey: "inputMessage")

    guard let output = filter.outputImage else {
        return UIImage(systemName: "xmark")!  // Fallback icon
    }

    // Scale QR to target size
    let scaleX = size / output.extent.width
    let scaleY = size / output.extent.height
    let scaled = output.transformed(by: .init(scaleX: scaleX, y: scaleY))

    // Render CIImage to CGImage
    let context = CIContext()
    guard let cg = context.createCGImage(scaled, from: scaled.extent) else {
        return UIImage(systemName: "xmark")!  // Fallback on render failure
    }
    return UIImage(cgImage: cg, scale: 1, orientation: .up)
}
