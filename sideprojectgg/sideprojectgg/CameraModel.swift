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
    
    // Track the current camera position (default to front if you want)
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    // Check Camera Authorization
    func checkAuthorization() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // Default to whichever position you prefer
            setupCamera(for: currentCameraPosition)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    // Must call on the main thread if you’re updating published properties
                    DispatchQueue.main.async {
                        self.setupCamera(for: self.currentCameraPosition)
                    }
                } else {
                    print("Camera access denied")
                }
            }
        default:
            print("Camera access denied")
        }
    }

    // Configure Camera (param to specify front or back)
    func setupCamera(for position: AVCaptureDevice.Position) {
        session.beginConfiguration()
        
        // 1) Remove existing inputs
        for input in session.inputs {
            session.removeInput(input)
        }
        
        // 2) Discover the requested camera
        guard let device = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: position
        ).devices.first else {
            print("\(position) camera not available")
            session.commitConfiguration()
            return
        }

        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            // 3) Add the new input
            if session.canAddInput(input) {
                session.addInput(input)
            } else {
                print("Unable to add camera input for \(position) camera")
            }
            
            // 4) Add photo output if it’s not already added
            if session.canAddOutput(photoOutput) {
                session.addOutput(photoOutput)
            }
            
            // 5) Commit and start session
            session.commitConfiguration()
            
            // Start the session on a background thread
            DispatchQueue.global(qos: .userInitiated).async {
                self.session.startRunning()
            }
            
            // Update preview layer on the main thread
            DispatchQueue.main.async {
                let layer = AVCaptureVideoPreviewLayer(session: self.session)
                layer.videoGravity = .resizeAspectFill
                self.previewLayer = layer
            }
            
        } catch {
            print("Error setting up \(position) camera: \(error)")
            session.commitConfiguration()
        }
    }

    // Capture Photo
    func capturePhoto() {
        let settings = AVCapturePhotoSettings()
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    
    // Stop Session
    func stopSession() {
        guard session.isRunning else { return }
        DispatchQueue.global(qos: .background).async {
            self.session.stopRunning()
            DispatchQueue.main.async {
                self.previewLayer?.removeFromSuperlayer()
                self.previewLayer = nil
            }
        }
    }
    
    // Toggle between front and back camera
    func toggleCamera() {
        session.beginConfiguration()
        // Remove old input
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)
        }

        // Determine new position
        let newPosition: AVCaptureDevice.Position =
           (currentCameraPosition == .front) ? .back : .front
        currentCameraPosition = newPosition

        // Discover new device
        guard let newDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: newPosition
        ).devices.first else {
            print("No device for position \(newPosition)")
            session.commitConfiguration()
            return
        }

        // Add input
        do {
            let newInput = try AVCaptureDeviceInput(device: newDevice)
            if session.canAddInput(newInput) {
                session.addInput(newInput)
            }
            // 4) Add photo output if it’s not already added
    
        } catch {
            print("Error switching camera: \(error)")
        }
        
        print("start config")
        session.commitConfiguration()
        print("finish config")
        
        
        
    }
}

// MARK: - AVCapturePhotoCaptureDelegate
extension CameraModel: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        print("run 1")
        // 1. Check if there's an error from AVCapturePhotoOutput
        if let error = error {
            print("Error capturing photo delegate call: \(error.localizedDescription)")
            return
        }

        // 2. No error, so proceed with extracting image data
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("Error: Could not get image data from photo.")
            return
        }
        
        print("going to capture the image")

        // 3. If we got here, we have a valid UIImage
        DispatchQueue.main.async {
            self.capturedImage = image
        }
    }
}
