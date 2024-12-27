//
//  FrameHandler.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/13/24.
//
import Foundation
import AVFoundation
import UIKit

class CameraModel: NSObject, ObservableObject {
    @Published var session = AVCaptureSession()
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    private var photoOutput = AVCapturePhotoOutput()
    @Published var capturedImage: UIImage? // Store the captured image

    // Check Camera Authorization
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            DispatchQueue.main.async {
                self.setupCamera()
            }
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.setupCamera()
                    }
                }
            }
        default:
            print("Camera access denied")
        }
    }

    // Configure Camera (Front Camera)
    func setupCamera() {
        session.beginConfiguration()

        // Find the front camera (position: front)
        guard let frontCamera = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: .video,
                position: .front).devices.first else {
            print("Front camera not available")
            return
        }

        do {
            // Create input from the front camera
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Unable to add front camera input")
                return
            }

            // Configure the photo output
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }

            session.commitConfiguration()

            // Start the session in the background
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                DispatchQueue.main.async {
                    print("Session started: \(self.session.isRunning)") // Debugging line
                }
            }

            // Initialize the preview layer here
            let layer = AVCaptureVideoPreviewLayer(session: self.session)
            layer.videoGravity = .resizeAspectFill
            DispatchQueue.main.async {
                self.previewLayer = layer
            }

        } catch {
            print("Error setting up front camera: \(error)")
        }
    }

    // Capture Photo
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .off // Adjust flash mode as needed
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
}

// Implementing the AVCapturePhotoCaptureDelegate to handle photo capture
extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let data = photo.fileDataRepresentation(),
           let image = UIImage(data: data) {
            DispatchQueue.main.async {
                self.capturedImage = image // Store the image in the variable
            }
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil) // store in user photo
        } else {
            print("Error capturing photo: \(String(describing: error))")
        }
    }
}


