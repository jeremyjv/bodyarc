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
    @Published var capturedImage: UIImage?
    private var currentCameraPosition: AVCaptureDevice.Position = .front
    private var isSessionConfigured = false
    @Published var isCameraReady = false

    // Check Camera Authorization
    func checkAuthorization() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        print("Authorization status: \(status.rawValue)")
        switch status {
        case .authorized:
            retrySetupCamera(for: currentCameraPosition)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    DispatchQueue.main.async {
                        self.retrySetupCamera(for: self.currentCameraPosition)
                    }
                } else {
                    print("Camera access denied by user.")
                }
            }
        default:
            print("Camera access denied.")
        }
    }

    // Configure Camera
    func setupCamera(for position: AVCaptureDevice.Position, completion: @escaping (Bool) -> Void) {
        print("Setting up camera for position: \(position.rawValue)")
        
        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        // Remove existing inputs
        session.inputs.forEach { input in
            session.removeInput(input)
        }

        // Discover and add camera input
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        ).devices.first else {
            print("No camera available for position: \(position.rawValue)")
            completion(false)
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Unable to add input for position: \(position.rawValue)")
                completion(false)
                return
            }

            // Add photo output
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }

            // Set preview layer
            DispatchQueue.main.async {
                let layer = AVCaptureVideoPreviewLayer(session: self.session)
                layer.videoGravity = .resizeAspectFill
                self.previewLayer = layer
                print("Preview layer setup complete.")
                completion(true)
            }

            isSessionConfigured = true

            // Start session
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
                print("Camera session started: \(self.session.isRunning)")
            }
        } catch {
            print("Error configuring camera: \(error.localizedDescription)")
            completion(false)
        }
    }

    // Retry Camera Setup
    func retrySetupCamera(for position: AVCaptureDevice.Position, retries: Int = 3) {
        setupCamera(for: position) { success in
            if !success && retries > 0 {
                print("Retrying camera setup... (\(retries) retries left)")
                DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                    self.retrySetupCamera(for: position, retries: retries - 1)
                }
            } else if !success {
                print("Failed to set up camera after retries.")
            }
        }
    }

    // Capture Photo
    func capturePhoto() {
        guard session.isRunning else {
            print("Session is not running; cannot capture photo.")
            return
        }
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }

    // Stop Session
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            print("Camera session stopped.")
            DispatchQueue.main.async {
                self.previewLayer?.removeFromSuperlayer()
                self.previewLayer = nil
                self.isSessionConfigured = false
            }
        }
    }

    // Toggle between front and back camera without restarting session
    func toggleCamera() {
        print("Toggling camera position.")
        let newPosition: AVCaptureDevice.Position = (currentCameraPosition == .front) ? .back : .front

        session.beginConfiguration()
        defer {
            session.commitConfiguration()
        }

        // Remove existing input
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)
        }

        // Add new input for the other camera position
        guard let newDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: newPosition
        ).devices.first else {
            print("No camera available for position: \(newPosition.rawValue)")
            return
        }

        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
                currentCameraPosition = newPosition
                print("Switched to \(newPosition == .front ? "front" : "back") camera.")
            } else {
                print("Unable to add input for new position: \(newPosition.rawValue)")
            }
        } catch {
            print("Error switching to \(newPosition == .front ? "front" : "back") camera: \(error.localizedDescription)")
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error {
            print("Error capturing photo: \(error.localizedDescription)")
            return
        }

        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Failed to get image data from photo.")
            return
        }

        DispatchQueue.main.async {
            print("Photo captured successfully.")
            self.capturedImage = image
        }
    }
}
