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
                // 上部コントロールバー (白文字で、背景はカメラプレビュー)
                controlBar()

                Spacer()

                // 下部シャッターボタンエリア (底部)
                shutterArea()
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)

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
        .alert("シャッターが切られました！", isPresented: $didTapShutter) {
            Button("OK", role: .cancel) { }
        }
    }
}

#Preview {
    CameraView()
}
