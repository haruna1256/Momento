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
    @StateObject private var uploadService = PhotoUploadService()

    @State private var isCameraSetup = false
    @State private var flashMode: FlashMode = .auto
    @State private var isFrontCamera: Bool = false
    @State private var permissionDenied = false

    // アップロード関連
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var uploadError: String?
    @State private var showUploadAlert = false

    var body: some View {
        ZStack {
            if permissionDenied {
                permissionDeniedView
            } else if isCameraSetup {
                CameraPreviewView(cameraManager: cameraManager)
                    .ignoresSafeArea()
            } else {
                loadingView
            }

            if !permissionDenied {
                VStack {
                    controlBar(flashMode: $flashMode)
                        .background(Color("bgBodyColor"))

                    Spacer()

                    shutterArea(
                        isFrontCamera: $isFrontCamera,
                        onShutterTap: {
                            captureAndUploadPhoto()
                        },
                        onFlipTap: {
                            cameraManager.switchCamera()
                            isFrontCamera.toggle()
                        }
                    )
                    .background(Color("bgBodyColor"))
                }
            }

            // アップロード中のオーバーレイ
            if isUploading {
                uploadingOverlay
            }
        }
        .statusBarHidden(true)
        .onAppear {
            checkCameraPermission()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
        .alert(uploadSuccess ? "アップロード完了" : "アップロード失敗",
               isPresented: $showUploadAlert) {
            Button("OK", role: .cancel) {
                uploadSuccess = false
                uploadError = nil
            }
        } message: {
            if uploadSuccess {
                Text("写真をバックエンドに送信しました！")
            } else if let error = uploadError {
                Text(error)
            }
        }
    }

    // 写真を撮影してアップロード
    private func captureAndUploadPhoto() {
        // 撮影中は連続撮影を防止
        guard !cameraManager.isCapturing && !isUploading else { return }

        cameraManager.takePhoto(flashMode: flashMode) { image in
            guard let image = image else {
                uploadError = "写真の撮影に失敗しました"
                showUploadAlert = true
                return
            }

            // アップロード開始
            uploadPhoto(image)
        }
    }

    // 写真をバックエンドにアップロード
    private func uploadPhoto(_ image: UIImage) {
        isUploading = true

        // メタデータの準備（オプション）
        let metadata: [String: Any] = [
            "timestamp": ISO8601DateFormatter().string(from: Date()),
            "camera_position": isFrontCamera ? "front" : "back",
            "flash_mode": "\(flashMode)"
        ]

        Task {
            do {
                let response = try await uploadService.uploadPhoto(
                    image: image,
                    metadata: metadata
                )

                await MainActor.run {
                    isUploading = false
                    uploadSuccess = true
                    showUploadAlert = true

                    print("アップロード成功: \(response)")
                }
            } catch let error as PhotoUploadService.UploadError {
                await MainActor.run {
                    isUploading = false
                    uploadError = error.localizedDescription
                    showUploadAlert = true
                }
            } catch {
                await MainActor.run {
                    isUploading = false
                    uploadError = "不明なエラーが発生しました"
                    showUploadAlert = true
                }
            }
        }
    }

    // MARK: - Views

    private var permissionDeniedView: some View {
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
    }

    private var loadingView: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ProgressView("カメラを起動中...")
                .controlSize(.large)
                .tint(.white)
        }
    }

    private var uploadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
                Text("アップロード中...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
            .padding(40)
            .background(Color.black.opacity(0.8))
            .cornerRadius(20)
        }
    }

    // MARK: - Helper Methods

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
