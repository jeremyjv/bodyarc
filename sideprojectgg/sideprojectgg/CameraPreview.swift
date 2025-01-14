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
        let view = UIView()
        view.backgroundColor = .black // Debugging background color
        view.accessibilityLabel = "Camera preview"
        view.isAccessibilityElement = true
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let previewLayer = cameraModel.previewLayer else {
            print("CameraPreview: previewLayer is nil. Ensure setupCamera has been called.")
            return
        }

        // Ensure the layer is added only once
        if previewLayer.superlayer != uiView.layer {
            uiView.layer.sublayers?
                .filter { $0 is AVCaptureVideoPreviewLayer }
                .forEach { $0.removeFromSuperlayer() }
            uiView.layer.addSublayer(previewLayer)
            print("Preview layer added to view.")
        }

        previewLayer.frame = uiView.bounds
    }
}
