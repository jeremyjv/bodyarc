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

            // Reattach the preview layer if necessary
            if previewLayer.superlayer != uiView.layer {
                uiView.layer.addSublayer(previewLayer)
            }
            previewLayer.frame = uiView.bounds
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
