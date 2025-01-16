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
        let container = UIView()
        container.backgroundColor = .black

        DispatchQueue.main.async {
            guard let previewLayer = self.cameraModel.previewLayer else {
                print("PreviewLayer is nil")
                return
            }
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.frame = container.bounds
            container.layer.addSublayer(previewLayer)
        }

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let previewLayer = cameraModel.previewLayer else { return }

            // Remove existing preview layers to prevent stacking
            uiView.layer.sublayers?.forEach { layer in
                if layer is AVCaptureVideoPreviewLayer {
                    layer.removeFromSuperlayer()
                }
            }

            // Add the preview layer
            previewLayer.frame = uiView.bounds
            uiView.layer.addSublayer(previewLayer)
        }
    }
}

extension UIImage {
    func cropToMatchPreview(previewLayer: AVCaptureVideoPreviewLayer) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        // Convert the preview bounds to image coordinates
        let metadataOutputRect = previewLayer.metadataOutputRectConverted(fromLayerRect: previewLayer.bounds)
        
        // Calculate crop rect in pixel coordinates
        let cropRect = CGRect(
            x: metadataOutputRect.origin.x * CGFloat(cgImage.width),
            y: metadataOutputRect.origin.y * CGFloat(cgImage.height),
            width: metadataOutputRect.size.width * CGFloat(cgImage.width),
            height: metadataOutputRect.size.height * CGFloat(cgImage.height)
        )
        
        // Perform cropping
        guard let croppedCGImage = cgImage.cropping(to: cropRect) else { return nil }
        return UIImage(cgImage: croppedCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
}
