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
        print("makeUIView called")
        let view = UIView()
        view.backgroundColor = .black // Debugging background color
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView called")
        
        // Check if the preview layer is ready
        guard let previewLayer = cameraModel.previewLayer else {
            print("Preview layer not ready in updateUIView")
            return
        }
        
        // Ensure the preview layer is added only once
        if previewLayer.superlayer != uiView.layer {
            print("Adding preview layer in updateUIView")
            previewLayer.frame = uiView.bounds
            uiView.layer.sublayers?.removeAll() // Clear any previous layers to avoid duplicates
            uiView.layer.addSublayer(previewLayer)
        } else {
            print("Preview layer already added")
            // Update frame to handle rotation or resizing
            previewLayer.frame = uiView.bounds
        }
    }
}
