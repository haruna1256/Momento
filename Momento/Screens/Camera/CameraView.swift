//
//  CameraView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI
import AVFoundation
// カメラ画面を表示するview
struct CameraView: View {
    // カメラ処理の切り出し部分
    // @StateObjectでCameraManagerをインスタンス化
    @StateObject private var cameraManager = CameraManager()
    @State private var isCameraSetup = false        // カメラの初期設定完了フラグ

    @State private var didTapShutter = false
    @State private var flashMode: FlashMode = .auto
    @State private var isFrontCamera: Bool = false


    var body: some View {
        ZStack {
            // 実際のカメラプレビューエリア
            if isCameraSetup {
                CameraPreviewView(cameraManager: cameraManager)
                    .ignoresSafeArea()
            } else {
                // カメラ設定中の代替ビュー
                Color.black.ignoresSafeArea()
                ProgressView().controlSize(.large)
            }

            // UIオーバーレイ
            VStack {
                // 上部コントロールバー
                // flashModeのバインドと、カメラ切り替えアクションを渡す
                controlBar(flashMode: $flashMode)
                    .background(Color("bgBodyColor"))

                Spacer()

                // 下部シャッターボタンエリア (底部)
                shutterArea(
                    isFrontCamera: $isFrontCamera,
                    onShutterTap: {
                        // 実際の写真撮影メソッドを呼び出す
                        // cameraManager.takePhoto(flashMode: flashMode)
                        didTapShutter = true
                    },
                    onFlipTap: {
                        cameraManager.switchCamera()
                        self.isFrontCamera.toggle()
                    }
                )
                .background(Color("bgBodyColor"))
            }
        }
        .statusBarHidden(true)
        .onAppear {
            // Viewが表示されたらカメラ設定を開始
            cameraManager.setupSession { success in
                if success {
                    isCameraSetup = true
                    cameraManager.startSession() // セッションを開始
                }
            }
        }
        .onDisappear {
            // Viewが閉じられたらセッションを停止
            cameraManager.stopSession()
        }
        .alert("写真を撮ったよ！", isPresented: $didTapShutter) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    CameraView()
}
