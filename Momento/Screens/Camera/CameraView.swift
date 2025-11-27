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
    @StateObject private var locationManager = LocationManager()

    @State private var isCameraSetup = false
    @State private var flashMode: FlashMode = .auto
    @State private var isFrontCamera: Bool = false
    @State private var permissionDenied = false

    // 確認画面表示用
    @State private var showConfirmView = false
    @State private var capturedImage: UIImage?

    // アップロード関連
    @State private var isUploading = false
    @State private var uploadSuccess = false
    @State private var uploadError: String?
    @State private var showUploadAlert = false

    // 利用可能なアルバム一覧（実際にはAPIから取得する）
    @State private var availableAlbums: [Album] = []

    // デフォルトのアルバムID
    private var defaultAlbumId: String {
        availableAlbums.first?.id ?? ""
    }

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

            if !permissionDenied && !showConfirmView {
                VStack {
                    controlBar(flashMode: $flashMode)
                        .background(Color("bgBodyColor"))

                    Spacer()

                    shutterArea(
                        isFrontCamera: $isFrontCamera,
                        onShutterTap: {
                            capturePhoto()
                        },
                        onFlipTap: {
                            cameraManager.switchCamera()
                            isFrontCamera.toggle()
                        }
                    )
                    .background(Color("bgBodyColor"))
                }
            }

            // 撮影後の確認画面
            if showConfirmView, let image = capturedImage {
                PhotoConfirmView(
                    image: image,
                    availableAlbums: availableAlbums,
                    defaultAlbumId: defaultAlbumId,
                    currentLocation: getCurrentLocationString(),
                    onDiscard: {
                        // 破棄：確認画面を閉じてカメラに戻る
                        showConfirmView = false
                        capturedImage = nil
                    },
                    onSend: { metadata in
                        // 送信：アップロード処理を開始
                        showConfirmView = false
                        uploadPhoto(image, metadata: metadata)
                    }
                )
                .transition(.move(edge: .bottom))
                .zIndex(1)
            }

            // アップロード中のオーバーレイ
            if isUploading {
                uploadingOverlay
                    .zIndex(2)
            }
        }
        .statusBarHidden(true)
        .onAppear {
            checkCameraPermission()
            // 位置情報の取得を開始
            locationManager.requestLocation()
            // アルバム一覧を取得（実際にはAPIから取得）
            loadAlbums()
        }
        .onDisappear {
            cameraManager.stopSession()
        }
        .alert(uploadSuccess ? "アップロード完了" : "アップロード失敗",
               isPresented: $showUploadAlert) {
            Button("OK", role: .cancel) {
                uploadSuccess = false
                uploadError = nil
                capturedImage = nil
            }
        } message: {
            if uploadSuccess {
                Text("写真をバックエンドに送信しました!")
            } else if let error = uploadError {
                Text(error)
            }
        }
    }

    // MARK: - Photo Capture & Upload

    // 写真を撮影
    private func capturePhoto() {
        // 撮影中は連続撮影を防止
        guard !cameraManager.isCapturing && !isUploading else { return }

        cameraManager.takePhoto(flashMode: flashMode) { image in
            guard let image = image else {
                uploadError = "写真の撮影に失敗しました"
                showUploadAlert = true
                return
            }

            // 撮影成功 → 確認画面を表示
            capturedImage = image
            withAnimation {
                showConfirmView = true
            }
        }
    }

    // 写真をバックエンドにアップロード
    private func uploadPhoto(_ image: UIImage, metadata: PhotoMetadata) {
        isUploading = true

        // メタデータの準備
        let uploadMetadata: [String: Any] = [
            "albumId": metadata.albumId,
            "caption": metadata.memo ?? "",
            "place": metadata.place ?? "",  // 場所の名前（ユーザー入力）
            "latitude": locationManager.currentLocation?.coordinate.latitude ?? 0.0,  // 緯度（位置情報）
            "longitude": locationManager.currentLocation?.coordinate.longitude ?? 0.0,  // 経度（位置情報）
            "camera_position": isFrontCamera ? "front" : "back",
            "timestamp": ISO8601DateFormatter().string(from: Date())
        ]

        Task {
            do {
                let response = try await uploadService.uploadPhoto(
                    image: image,
                    metadata: uploadMetadata
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

    // アルバム一覧を読み込む
    private func loadAlbums() {
        // TODO: バックエンドAPIからアルバム一覧を取得
        // 現時点ではモックデータを使用
        availableAlbums = Album.mockAlbums
        print("アルバム読み込み完了: \(availableAlbums.count)件")
    }

    // 現在地の住所を文字列で取得
    private func getCurrentLocationString() -> String? {
        // LocationManagerから住所を取得
        if let address = locationManager.currentAddress {
            return address
        }

        // 住所がまだ取得できていない場合は緯度経度を返す
        guard let location = locationManager.currentLocation else {
            return nil
        }
        return "緯度: \(String(format: "%.4f", location.coordinate.latitude)), 経度: \(String(format: "%.4f", location.coordinate.longitude))"
    }
}

#Preview {
    CameraView()
}
