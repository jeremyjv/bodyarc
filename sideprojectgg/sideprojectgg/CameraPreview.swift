//
//  CameraPreview.swift
//  sideprojectgg
//
//  Created by Jeremy Villanueva on 12/13/24.
//
import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    @ObservedObject var cameraModel: CameraModel

    func makeUIView(context: Context) -> UIView {
        print("CameraPreview: makeUIView called")
        let container = UIView()
        container.backgroundColor = .black // Debugging background color
        container.accessibilityLabel = "Camera preview"
        container.isAccessibilityElement = true
        
        // Create a subview for the camera preview
        let cameraView = UIView()
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(cameraView)
        
        // Enforce aspect ratio (275:370)
        let aspectRatio = CGFloat(275.0 / 445.0)
        NSLayoutConstraint.activate([
            cameraView.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            cameraView.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            cameraView.widthAnchor.constraint(equalTo: container.widthAnchor, multiplier: aspectRatio),
            cameraView.heightAnchor.constraint(equalTo: cameraView.widthAnchor, multiplier: 1.0 / aspectRatio)
        ])
        
        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let previewLayer = cameraModel.previewLayer else {
                print("CameraPreview: previewLayer is nil. Ensure setupCamera has been called.")
                return
            }

            let cameraView = uiView.subviews.first
            guard let cameraViewLayer = cameraView?.layer else { return }
            
            // Ensure the layer is added only once
            if previewLayer.superlayer != cameraViewLayer {
                cameraViewLayer.sublayers?
                    .filter { $0 is AVCaptureVideoPreviewLayer }
                    .forEach { $0.removeFromSuperlayer() }
                cameraViewLayer.addSublayer(previewLayer)
                print("Preview layer added to cameraView.")
            }

            previewLayer.frame = cameraView?.bounds ?? .zero
        }
    }
}

extension UIImage {
    func cropToAspectRatio(width: CGFloat, height: CGFloat) -> UIImage? {
        let targetAspectRatio = width / height
        let currentAspectRatio = size.width / size.height

        var newSize: CGSize
        if currentAspectRatio > targetAspectRatio {
            // Wider than target, crop width
            newSize = CGSize(width: size.height * targetAspectRatio, height: size.height)
        } else {
            // Taller than target, crop height
            newSize = CGSize(width: size.width, height: size.width / targetAspectRatio)
        }

        let origin = CGPoint(x: (size.width - newSize.width) / 2, y: (size.height - newSize.height) / 2)
        let cropRect = CGRect(origin: origin, size: newSize)

        guard let cgImage = self.cgImage?.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: imageOrientation)
    }
}
