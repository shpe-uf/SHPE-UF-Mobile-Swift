import SwiftUI
import Foundation

final class ForgetPasswordViewModel: ObservableObject {
   
    private var requestHandler = RequestHandler()
    @Published var email: String = ""
    @Published var error: String = ""
    @Published var isCommunicating: Bool = false
    let toastDuration: Double = 3.0
    
    // MARK: - Forgot Password Logic
    func forgotPassword(email: String) {
        // Overwrite local email if needed
        self.email = email
        
        // Basic check
        guard email.contains("@") else {
            self.error = "Please enter a valid email."
            AppViewModel.appVM.toastMessage = self.error
            withAnimation(.easeIn(duration: 0.3)) {
                AppViewModel.appVM.showToast = true
            }
            return
        }
        
        // Show activity indicator
        self.isCommunicating = true
        print("🔍 Starting email validation for: \(email)")
        
        // 1) Validate email with backend
        requestHandler.validateEmail(email: email) { result in
            DispatchQueue.main.async {
                self.isCommunicating = false
                
                // Check if there's an error
                if let error = result["error"] as? String {
                    self.error = error
                    AppViewModel.appVM.toastMessage = self.error
                    withAnimation(.easeIn(duration: 0.3)) {
                        AppViewModel.appVM.showToast = true
                    }
                    print("❌ Email validation failed with error: \(error)")
                    return
                }
                
                // Check if email is registered
                guard let emailExists = result["emailExists"] as? Bool, emailExists else {
                    self.error = "Email not registered"
                    AppViewModel.appVM.toastMessage = self.error
                    withAnimation(.easeIn(duration: 0.3)) {
                        AppViewModel.appVM.showToast = true
                    }
                    print("⚠️ Email not registered: \(self.email)")
                    return
                }
                
                // 2) If email is valid, proceed to request a password reset
                self.isCommunicating = true
                print("✅ Email exists. Proceeding to send password reset request...")
                
                self.requestHandler.forgotPassword(email: email) { data in
                    DispatchQueue.main.async {
                        self.isCommunicating = false
                        if let error = data["error"] as? String {
                            self.error = error
                            AppViewModel.appVM.toastMessage = self.error
                            withAnimation(.easeIn(duration: 0.3)) {
                                AppViewModel.appVM.showToast = true
                            }
                            print("❌ Failed to send password reset email: \(error)")
                            return
                        }
                        
                        if let message = data["message"] as? String {
                            // Show success toast
                            AppViewModel.appVM.toastMessage = message
                            withAnimation(.easeIn(duration: 0.3)) {
                                AppViewModel.appVM.showToast = true
                            }
                            print("📬 Password reset request successful. Message: \(message)")
                        } else {
                            print("⚠️ Password reset response missing 'message' field.")
                        }
                    }
                }
            }
        }
    }
}
