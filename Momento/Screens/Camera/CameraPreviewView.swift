//
//  CameraPreviewView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//

import SwiftUI
import AVFoundation

struct CameraPreviewView: UIViewRepresentable {
    @ObservedObject var cameraManager: CameraManager

    func makeUIView(context: Context) -> PreviewView {
        let view = PreviewView()
        view.backgroundColor = .black

        // プレビューレイヤーを設定
        if let previewLayer = cameraManager.previewLayer {
            view.videoPreviewLayer = previewLayer
            previewLayer.videoGravity = .resizeAspectFill
        }

        return view
    }

    func updateUIView(_ uiView: PreviewView, context: Context) {
        // プレビューレイヤーの更新を確認
        if uiView.videoPreviewLayer == nil,
           let previewLayer = cameraManager.previewLayer {
            uiView.videoPreviewLayer = previewLayer
            previewLayer.videoGravity = .resizeAspectFill
        }
    }
}

// カスタムUIViewクラス - レイヤーのフレーム自動調整を実装
class PreviewView: UIView {
    var videoPreviewLayer: AVCaptureVideoPreviewLayer? {
        didSet {
            if let oldLayer = oldValue {
                oldLayer.removeFromSuperlayer()
            }

            if let newLayer = videoPreviewLayer {
                layer.addSublayer(newLayer)
                newLayer.frame = bounds
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        // レイアウトが変更されたらプレビューレイヤーのフレームも更新
        videoPreviewLayer?.frame = bounds
    }
}
