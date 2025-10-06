//
//  Photo.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// 写真の情報を保持するテーブル
import Foundation

struct Photo: Identifiable, Decodable {
    let id: String          // 写真のID
    let albumId: String     // アルバムのID
    let imageUrl: URL       // 写真のURL
    let caption: String?    // 写真のメモ
    let place: String?      // 写真の住所or地名
    let latitude: Double?   // 緯度
    let longitude: Double?  // 経度
    let takenAt: Date?      // 撮影日時
    let createdAt: Date     // 登録日時

    init(
        id: String,
        albumId: String,
        imageUrl: URL,
        caption: String? = nil,
        place: String? = nil,
        latitude: Double? = 0.0,
        longitude: Double? = 0.0,
        takenAt: Date? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.albumId = albumId
        self.imageUrl = imageUrl
        self.caption = caption
        self.place = place
        self.latitude = latitude
        self.longitude = longitude
        self.takenAt = takenAt
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id = "photoID"
        case albumId = "albumID"
        case imageUrl = "image_url"
        case caption
        case place
        case latitude
        case longitude
        case takenAt = "taken_at"
        case createdAt = "created_at"
    }
}
