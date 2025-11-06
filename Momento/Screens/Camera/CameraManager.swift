//
//  CameraManager.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//

import AVFoundation
import SwiftUI

class CameraManager: NSObject, ObservableObject {
    @Published var previewLayer: AVCaptureVideoPreviewLayer?
    @Published var capturedImage: UIImage?
    @Published var isCapturing = false

    // フリーズ対策のためにセッション開始を通知するフラグ
    @Published var sessionIsRunning: Bool = false

    private var captureSession: AVCaptureSession?
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")
    private var photoCompletion: ((UIImage?) -> Void)?

    func setupSession(completion: @escaping (Bool) -> Void) {
        sessionQueue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(false) }
                return
            }

            let session = AVCaptureSession()
            session.beginConfiguration()

            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }

            guard let videoDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ) else {
                session.commitConfiguration()
                DispatchQueue.main.async { completion(false) }
                return
            }

            do {
                let videoInput = try AVCaptureDeviceInput(device: videoDevice)
                if session.canAddInput(videoInput) {
                    session.addInput(videoInput)
                    self.videoDeviceInput = videoInput
                } else {
                    session.commitConfiguration()
                    DispatchQueue.main.async { completion(false) }
                    return
                }
            } catch {
                print("カメラ入力エラー: \(error.localizedDescription)")
                session.commitConfiguration()
                DispatchQueue.main.async { completion(false) }
                return
            }

            let output = AVCapturePhotoOutput()

            // AVCapturePhotoOutput自体で高解像度キャプチャを有効にする
            output.isHighResolutionCaptureEnabled = true

            if session.canAddOutput(output) {
                session.addOutput(output)
                self.photoOutput = output
            }

            session.commitConfiguration()
            self.captureSession = session

            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill

                if let connection = previewLayer.connection {
                    if connection.isVideoOrientationSupported {
                        connection.videoOrientation = .portrait
                    }
                }

                self.previewLayer = previewLayer
                completion(true)
            }
        }
    }

    func startSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.startRunning()

            DispatchQueue.main.async {
                self?.sessionIsRunning = true
            }
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
            self?.sessionIsRunning = false
            print("[Session] セッション停止完了。")
        }
    }

    func switchCamera() {
        sessionQueue.async { [weak self] in
            guard let self = self,
                      let session = self.captureSession,
                      let currentInput = self.videoDeviceInput else {
                return
            }

            session.beginConfiguration()
            session.removeInput(currentInput)

            let newPosition: AVCaptureDevice.Position =
                currentInput.device.position == .back ? .front : .back

            guard let newDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: newPosition
            ) else {
                session.addInput(currentInput)
                session.commitConfiguration()
                return
            }

            do {
                let newInput = try AVCaptureDeviceInput(device: newDevice)
                if session.canAddInput(newInput) {
                    session.addInput(newInput)
                    self.videoDeviceInput = newInput
                } else {
                    session.addInput(currentInput)
                }
            } catch {
                print("カメラ切り替えエラー: \(error.localizedDescription)")
                session.addInput(currentInput)
            }

            session.commitConfiguration()
        }
    }

    func takePhoto(flashMode: FlashMode, completion: @escaping (UIImage?) -> Void) {
        guard let photoOutput = photoOutput else {
            completion(nil)
            return
        }

        sessionQueue.async { [weak self] in
            guard let self = self else {
                completion(nil)
                return
            }

            self.photoCompletion = completion

            let settings = AVCapturePhotoSettings()

            if photoOutput.supportedFlashModes.contains(flashMode.avFlashMode) {
                settings.flashMode = flashMode.avFlashMode
            }

            // 撮影要求で高解像度を有効化
            settings.isHighResolutionPhotoEnabled = true

            DispatchQueue.main.async {
                self.isCapturing = true
            }

            photoOutput.capturePhoto(with: settings, delegate: self)
        }
    }
}

// MARK: - AVCapturePhotoCaptureDelegate

extension CameraManager: AVCapturePhotoCaptureDelegate {
    func photoOutput(
        _ output: AVCapturePhotoOutput,
        didFinishProcessingPhoto photo: AVCapturePhoto,
        error: Error?
    ) {
        DispatchQueue.main.async { [weak self] in
            self?.isCapturing = false
        }

        if let error = error {
            print("写真撮影エラー: \(error.localizedDescription)")
            photoCompletion?(nil)
            return
        }

        guard let imageData = photo.fileDataRepresentation(),
              let image = UIImage(data: imageData) else {
            photoCompletion?(nil)
            return
        }

        let fixedImage = image.fixOrientation()

        DispatchQueue.main.async { [weak self] in
            self?.capturedImage = fixedImage
            self?.photoCompletion?(fixedImage)
        }
    }
}

// MARK: - UIImage Extension

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return normalizedImage ?? self
    }
}
