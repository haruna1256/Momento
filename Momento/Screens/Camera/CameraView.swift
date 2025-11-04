//
//  CameraView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//
import SwiftUI
import AVFoundation

struct CameraView: View {
    @StateObject private var cameraManager = CameraManager()
    @State private var isCameraSetup = false
    @State private var didTapShutter = false
    @State private var flashMode: FlashMode = .auto
    @State private var isFrontCamera: Bool = false
    @State private var permissionDenied = false

    var body: some View {
        ZStack {
            if permissionDenied {
                // 権限が拒否された場合の表示
                VStack(spacing: 20) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.gray)
                    Text("カメラへのアクセスが許可されていません")
                        .font(.headline)
                    Text("設定からカメラへのアクセスを許可してください")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    Button("設定を開く") {
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            } else if isCameraSetup {
                CameraPreviewView(cameraManager: cameraManager)
                    .ignoresSafeArea()
            } else {
                Color.black.ignoresSafeArea()
                ProgressView("カメラを起動中...")
                    .controlSize(.large)
                    .tint(.white)
            }

            if !permissionDenied {
                VStack {
                    controlBar(flashMode: $flashMode)
                        .background(Color("bgBodyColor"))

                    Spacer()

                    shutterArea(
                        isFrontCamera: $isFrontCamera,
                        onShutterTap: {
                            didTapShutter = true
                        },
                        onFlipTap: {
                            cameraManager.switchCamera()
                            isFrontCamera.toggle()
                        }
                    )
                    .background(Color("bgBodyColor"))
                }
            }
        }
        .statusBarHidden(true)
        .onAppear {
            checkCameraPermission()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
        .alert("写真を撮ったよ!", isPresented: $didTapShutter) {
            Button("OK", role: .cancel) { }
        }
    }

    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupCamera()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { granted in
                DispatchQueue.main.async {
                    if granted {
                        setupCamera()
                    } else {
                        permissionDenied = true
                    }
                }
            }
        case .denied, .restricted:
            permissionDenied = true
        @unknown default:
            permissionDenied = true
        }
    }

    private func setupCamera() {
        cameraManager.setupSession { success in
            DispatchQueue.main.async {
                if success {
                    isCameraSetup = true
                    cameraManager.startSession()
                } else {
                    print("カメラのセットアップに失敗しました")
                }
            }
        }
    }
}

#Preview {
    CameraView()
}
