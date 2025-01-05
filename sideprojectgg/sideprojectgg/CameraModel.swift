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
            setupCamera() // No need for DispatchQueue.main here
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    self.setupCamera()
                } else {
                    print("Camera access denied")
                }
            }
        default:
            print("Camera access denied")
        }
    }

    // Configure Camera (Front Camera)
    func setupCamera() {
        session.beginConfiguration()

        // Remove existing inputs
        session.inputs.forEach { session.removeInput($0) }

        guard let frontCamera = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .front
        ).devices.first else {
            print("Front camera not available")
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: frontCamera)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Unable to add front camera input")
            }

            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }

            session.commitConfiguration()

            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }

            DispatchQueue.main.async {
                let layer = AVCaptureVideoPreviewLayer(session: self.session)
                layer.videoGravity = .resizeAspectFill
                self.previewLayer = layer
            }
        } catch {
            print("Error setting up front camera: \(error)")
            session.commitConfiguration()
        }
    }
    
    func stopSession() {
        if session.isRunning {
            DispatchQueue.global(qos: .background).async {
                self.session.stopRunning()
                DispatchQueue.main.async {
                    self.previewLayer?.removeFromSuperlayer() // Remove the preview layer to avoid reattachment issues
                    self.previewLayer = nil // Reset preview layer
                }
            }
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


