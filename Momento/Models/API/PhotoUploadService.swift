//
//  PhotoUploadService.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/04.
//

import Foundation
import UIKit

// バックエンドへの写真アップロード用サービス
class PhotoUploadService: ObservableObject {

    // バックエンドのエンドポイントURL
    private let uploadURL = "http://10.200.4.152:4000/upload"

    enum UploadError: Error {
        case invalidImageData
        case invalidURL
        case networkError(Error)
        case serverError(Int)
        case unknown

        var localizedDescription: String {
            switch self {
            case .invalidImageData:
                return "画像データが無効です"
            case .invalidURL:
                return "URLが無効です"
            case .networkError(let error):
                return "ネットワークエラー: \(error.localizedDescription)"
            case .serverError(let code):
                return "サーバーエラー: \(code)"
            case .unknown:
                return "不明なエラー"
            }
        }
    }

    // 写真をアップロード（async/await版）
    func uploadPhoto(
        image: UIImage,
        metadata: [String: Any]? = nil
    ) async throws -> [String: Any] {

        // 画像をJPEGデータに変換（圧縮率0.8）
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw UploadError.invalidImageData
        }

        // URLの検証
        guard let url = URL(string: uploadURL) else {
            throw UploadError.invalidURL
        }

        // マルチパートフォームデータの作成
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // 必要に応じて認証トークンを追加
        // request.setValue("Bearer YOUR_TOKEN", forHTTPHeaderField: "Authorization")

        // リクエストボディの構築
        var body = Data()

        // 画像データの追加
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"photo.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: .utf8)!)

        // メタデータの追加（オプション）
        if let metadata = metadata {
            for (key, value) in metadata {
                body.append("--\(boundary)\r\n".data(using: .utf8)!)
                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                body.append("\(value)\r\n".data(using: .utf8)!)
            }
        }

        // 終了境界
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        // リクエストの送信
        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw UploadError.unknown
            }

            // ステータスコードの確認
            guard (200...299).contains(httpResponse.statusCode) else {
                throw UploadError.serverError(httpResponse.statusCode)
            }

            // レスポンスのパース
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                return json
            } else {
                return ["success": true]
            }

        } catch let error as UploadError {
            throw error
        } catch {
            throw UploadError.networkError(error)
        }
    }

    // 写真をアップロード（クロージャ版）
    func uploadPhoto(
        image: UIImage,
        metadata: [String: Any]? = nil,
        completion: @escaping (Result<[String: Any], UploadError>) -> Void
    ) {
        Task {
            do {
                let result = try await uploadPhoto(image: image, metadata: metadata)
                completion(.success(result))
            } catch let error as UploadError {
                completion(.failure(error))
            } catch {
                completion(.failure(.unknown))
            }
        }
    }
}

// Data型の拡張（マルチパートデータ構築用）
extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
