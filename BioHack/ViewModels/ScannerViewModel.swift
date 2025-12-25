import Foundation
import AVFoundation

class ScannerViewModel: NSObject, ObservableObject {
    /// Publishes the barcode string when found
    @Published var scannedCode: String?
    
    /// Publishes whether the torch (flashlight) is on
    @Published var isTorchOn: Bool = false
    
    var captureSession: AVCaptureSession?
    
    func toggleTorch() {
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        if device.hasTorch {
            do {
                try device.lockForConfiguration()
                isTorchOn.toggle()
                device.torchMode = isTorchOn ? .on : .off
                device.unlockForConfiguration()
            } catch {
                print("Torch could not be used")
            }
        }
    }
}

// Extension to handle the Camera Output
extension ScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        
        // Check if we have any metadata
        if let metadataObject = metadataObjects.first {
            // Valid barcode types for food
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            
            // If the code is readable, send it to the UI
            if let stringValue = readableObject.stringValue {
                // Audio feedback (Beep!)
                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                
                // Update on Main Thread
                DispatchQueue.main.async {
                    self.scannedCode = stringValue
                }
            }
        }
    }
}