import UIKit
import ReplayKit

@objc class ScreenshotService: NSObject {
    static let shared = ScreenshotService()

    @objc func captureScreenshot(result: @escaping (String?) -> Void) {
        let recorder = RPScreenRecorder.shared()
        recorder.isMicrophoneEnabled = false
        
        recorder.startCapture(handler: { (sampleBuffer, bufferType, error) in
            guard error == nil else {
                result(nil)
                return
            }

            if bufferType == .video {
                let image = self.imageFromSampleBuffer(sampleBuffer: sampleBuffer)
                
                guard let imageData = image.pngData() else {
                    result(nil)
                    return
                }
                
                let filePath = self.saveImageToDocuments(imageData: imageData)
                result(filePath)
                recorder.stopCapture { (error) in
                    if let error = error {
                        print("Stop capture error: \(error)")
                    }
                }
            }
        }, completionHandler: { error in
            if let error = error {
                print("Error starting screen capture: \(error.localizedDescription)")
                result(nil)
            }
        })
    }

    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> UIImage {
        let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        let context = CIContext()
        let cgImage = context.createCGImage(ciImage, from: ciImage.extent)!
        return UIImage(cgImage: cgImage)
    }

    private func saveImageToDocuments(imageData: Data) -> String? {
        let fileName = "screenshot_\(UUID().uuidString).png"
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            return fileURL.path
        } catch {
            print("Error saving image: \(error)")
            return nil
        }
    }
}
