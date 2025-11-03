//
//  CameraPreviewView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//
import SwiftUI
import AVFoundation
// CameraManagerからプレビュー層を受け取り、SwiftUIに表示するためのブリッジ

struct CameraPreviewView: UIViewRepresentable {
    // CameraManagerからプレビュー層を受け取る
    let cameraManager: CameraManager

    // プレビュー層をホストするUIViewを作成
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.backgroundColor = .black // プレビューがない時の背景

        // CameraManagerからPreviewLayerを取得し、UIViewのLayerとして追加
        if let previewLayer = cameraManager.previewLayer {
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
        }
        return view
    }

    // Viewが更新された時の処理
    func updateUIView(_ uiView: UIView, context: Context) {
        // プレビュー層のフレームサイズをViewのサイズに合わせて更新
        if let previewLayer = cameraManager.previewLayer {
            previewLayer.frame = uiView.bounds
        }
    }
}
