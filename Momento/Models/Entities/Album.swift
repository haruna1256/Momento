//
//  Album.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// グループごとのアルバムを管理するテーブル
import Foundation

struct Album: Identifiable, Decodable {
    let id: String                      // アルバムのID
    let ownerId: String                 // 作成者のID
    let title: String                   // アルバム名
    let description: String?            // アルバムの説明
    let categoryId: String              // カテゴリーのID
    let coverPhotoId: String?           // 表紙の画像
    let latitude: Double                // 緯度
    let longitude: Double               // 経度
    let createdAt: Date                 // 作成日時
    let updatedAt: Date                 // 更新日時
    var photos: [Photo] = []            // 保存している写真
    var sharedUsers: [AlbumShare] = []  // アルバム内に入っているメンバー

    init(
        id: String,
        ownerId: String,
        title: String,
        description: String? = nil,
        categoryId: String,
        coverPhotoId: String? = nil,
        latitude: Double = 0.0,
        longitude: Double = 0.0,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        photos: [Photo] = [],
        sharedUsers: [AlbumShare] = []
    ) {
        self.id = id
        self.ownerId = ownerId
        self.title = title
        self.description = description
        self.categoryId = categoryId
        self.coverPhotoId = coverPhotoId
        self.latitude = latitude
        self.longitude = longitude
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.photos = photos
        self.sharedUsers = sharedUsers
    }

    enum CodingKeys: String, CodingKey {
        case id = "albumID"
        case ownerId = "ownerID"
        case title
        case description
        case categoryId = "categoryID"
        case coverPhotoId = "cover_photo_id"
        case latitude
        case longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case photos
        case sharedUsers
    }
}
