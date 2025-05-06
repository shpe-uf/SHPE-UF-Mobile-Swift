import Foundation
import UIKit
import CoreImage.CIFilterBuiltins

/// ViewModel for the “Create Event” screen:
/// holds form state, runs validation, performs the GraphQL mutation,
/// and generates the QR on success.
class EventCreatorViewModel: ObservableObject {
    // MARK: - Inputs
    @Published var eventTitle    = ""
    @Published var eventCode     = ""
    @Published var eventCategory = ""
    @Published var eventPoints   = ""
    @Published var eventDate     = ""

    // MARK: - Outputs
    @Published var fieldErrors: [String] = []
    @Published var qrImage: UIImage?
    @Published var showingQR = false

    private let requestHandler = RequestHandler()

    // MARK: - Validation Regex
    private let validNamePattern = #"^[A-Za-z0-9\s\-\/]{6,50}$"#
    private let validCodePattern = #"^[A-Za-z0-9]{6,50}$"#

    /// Clears and repopulates `fieldErrors` based on:
    /// • required-field checks
    /// • regex checks for title/code
    func validateFields() {
        fieldErrors = []
        if eventTitle.isEmpty    { fieldErrors.append("Title is required.") }
        if eventCode.isEmpty     { fieldErrors.append("Code is required.") }
        if eventCategory.isEmpty { fieldErrors.append("Category is required.") }
        if eventDate.isEmpty     { fieldErrors.append("Expires in is required.") }

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

    /// Sends the `CreateEvent` mutation if no validation errors.
    /// On server error (e.g. duplicate name) populates `fieldErrors`.
    /// On success, generates the QR image and sets `showingQR = true`.
    func createEvent(onSuccess: @escaping ()->Void = {}) {
        validateFields()
        guard fieldErrors.isEmpty else { return }

        let pts = Int(eventPoints) ?? 0
        let input = SHPESchema.CreateEventInput(
            name:       eventTitle,
            code:       eventCode,
            category:   eventCategory,
            points:     String(pts),
            expiration: eventDate,
            request:    "true"
        )

        requestHandler.createEvent(input: input) { [weak self] result in
            DispatchQueue.main.async {
                if let err = result["error"] as? String {
                    let message = err.lowercased().contains("exists")
                        ? "An event with that name already exists."
                        : err
                    self?.fieldErrors = [message]
                    return
                }
                // success → generate QR + show sheet
                self?.qrImage   = QrCodeGenerator(eventCode: self?.eventCode ?? "")
                self?.showingQR = true
                onSuccess()
            }
        }
    }
}

/// Utility that takes an event code and returns a non-interpolated QR UIImage.
func QrCodeGenerator(eventCode: String, size: CGFloat = 200) -> UIImage {
    let raw = "[SHPEUF]:" + eventCode
    let filter = CIFilter.qrCodeGenerator()
    filter.setValue(raw.data(using: .ascii), forKey: "inputMessage")
    guard let output = filter.outputImage else {
        return UIImage(systemName: "xmark")!
    }

    let scaleX = size / output.extent.width
    let scaleY = size / output.extent.height
    let scaled = output.transformed(by: .init(scaleX: scaleX, y: scaleY))

    let context = CIContext()
    guard let cg = context.createCGImage(scaled, from: scaled.extent) else {
        return UIImage(systemName: "xmark")!
    }
    return UIImage(cgImage: cg, scale: 1, orientation: .up)
}

