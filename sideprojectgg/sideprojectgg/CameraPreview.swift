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

        // Try to add preview layer immediately if it's ready
        if let previewLayer = cameraModel.previewLayer {
            print("Adding preview layer in makeUIView")
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }

        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        print("updateUIView called")
        // Ensure the preview layer is added if it was initialized later
        if let previewLayer = cameraModel.previewLayer {
            if previewLayer.superlayer == nil {
                print("Adding preview layer in updateUIView")
                previewLayer.frame = uiView.bounds
                uiView.layer.addSublayer(previewLayer)
            } else {
                print("Preview layer already added")
            }
        } else {
            print("Preview layer not ready in updateUIView")
        }
    }
}
