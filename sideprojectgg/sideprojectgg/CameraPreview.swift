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
        guard let previewLayer = cameraModel.previewLayer else { return }

        // Ensure the preview layer is added only once
        if previewLayer.superlayer != uiView.layer {
            uiView.layer.sublayers?.removeAll() // <— This removes any sublayer
            uiView.layer.addSublayer(previewLayer)
        }
        previewLayer.frame = uiView.bounds
    }
}
