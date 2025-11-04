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

    private var captureSession: AVCaptureSession?
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var photoOutput: AVCapturePhotoOutput?

    private let sessionQueue = DispatchQueue(label: "camera.session.queue")

    func setupSession(completion: @escaping (Bool) -> Void) {
        sessionQueue.async { [weak self] in
            guard let self = self else {
                DispatchQueue.main.async { completion(false) }
                return
            }

            // セッションの作成
            let session = AVCaptureSession()
            session.beginConfiguration()

            // セッション品質の設定
            if session.canSetSessionPreset(.photo) {
                session.sessionPreset = .photo
            }

            // カメラデバイスの取得
            guard let videoDevice = AVCaptureDevice.default(
                .builtInWideAngleCamera,
                for: .video,
                position: .back
            ) else {
                DispatchQueue.main.async { completion(false) }
                return
            }

            // ビデオ入力の設定
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

            // 写真出力の設定
            let output = AVCapturePhotoOutput()
            if session.canAddOutput(output) {
                session.addOutput(output)
                self.photoOutput = output
            }

            session.commitConfiguration()

            // セッションを保存
            self.captureSession = session

            // プレビューレイヤーの作成（メインスレッドで）
            DispatchQueue.main.async {
                let previewLayer = AVCaptureVideoPreviewLayer(session: session)
                previewLayer.videoGravity = .resizeAspectFill

                // デバイスの向きに応じた接続設定
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
        }
    }

    func stopSession() {
        sessionQueue.async { [weak self] in
            self?.captureSession?.stopRunning()
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

            // 現在の位置とは逆のカメラを取得
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
}
