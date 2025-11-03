//
//  CameraManager.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//
import AVFoundation
import Foundation

// カメラ処理（セッション管理、入力/出力設定）のロジック

class CameraManager: ObservableObject {
    // プレビュー層を保持するための公開プロパティ
    var previewLayer: AVCaptureVideoPreviewLayer?

    // カメラのセッション
    private var captureSession: AVCaptureSession?

    // 現在使用しているカメラの位置 (背面/前面)
    private var currentCameraPosition: AVCaptureDevice.Position = .back

    // セッションの設定
    func setupSession(completion: @escaping (Bool) -> Void) {
        // セッションが既に実行中なら終了
        if captureSession != nil {
            completion(true)
            return
        }

        // 新しいセッションを作成
        let session = AVCaptureSession()
        self.captureSession = session

        // 入力と出力の設定
        do {
            try configureCaptureInput(session: session)
            try configureCaptureOutput(session: session)

            // プレビューレイヤーの作成
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.videoGravity = .resizeAspectFill // 画面いっぱいに表示

            completion(true)
        } catch {
            print("カメラ設定エラー: \(error.localizedDescription)")
            completion(false)
        }
    }

    // カメラの入力設定
    private func configureCaptureInput(session: AVCaptureSession) throws {
        // 既存の入力を削除
        session.inputs.forEach { session.removeInput($0) }

        // デバイス（カメラ）の取得
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                   for: .video,
                                                   position: currentCameraPosition) else {
            throw CameraError.inputUnavailable
        }

        // 入力としてセッションに追加
        let cameraInput = try AVCaptureDeviceInput(device: camera)
        if session.canAddInput(cameraInput) {
            session.addInput(cameraInput)
        } else {
            throw CameraError.inputNotAdded
        }
    }

    // 出力設定（今回は写真撮影に必須のAVCapturePhotoOutputのみ）
    private func configureCaptureOutput(session: AVCaptureSession) throws {
        // 既存の出力を削除
        session.outputs.forEach { session.removeOutput($0) }

        let photoOutput = AVCapturePhotoOutput()
        if session.canAddOutput(photoOutput) {
            session.addOutput(photoOutput)
        } else {
            throw CameraError.outputNotAdded
        }
    }

    // カメラセッションの開始
    func startSession() {
        if let session = captureSession, !session.isRunning {
            // 別スレッドでセッションを開始（メインスレッドのブロックを避ける）
            DispatchQueue.global(qos: .userInitiated).async {
                session.startRunning()
            }
        }
    }

    // カメラセッションの停止
    func stopSession() {
        if let session = captureSession, session.isRunning {
            session.stopRunning()
        }
    }

    // カメラの切り替え
    func switchCamera() {
        currentCameraPosition = currentCameraPosition == .back ? .front : .back

        // セッションを再設定（入力の変更）
        if let session = captureSession {
            do {
                try configureCaptureInput(session: session)
            } catch {
                print("カメラ切り替えエラー: \(error.localizedDescription)")
            }
        }
    }
}

// エラー定義
enum CameraError: Error {
    case inputUnavailable
    case inputNotAdded
    case outputNotAdded
}
