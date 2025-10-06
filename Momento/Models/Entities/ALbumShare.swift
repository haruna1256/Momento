//
//  ALbumShare.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// 共有設定（どのユーザーがどのアルバムにアクセスできるか）を管理するテーブル
import Foundation

struct AlbumShare: Identifiable, Decodable {
    let id: String              // 共有設定のID
    let albumId: String         // アルバムのID
    let userId: String          // ユーザーのID
    var role: String = "viewer" // 権限（viewer / editor）
    let createdAt: Date         // 登録日時

    init(
        id: String,
        albumId: String,
        userId: String,
        role: String = "viewer",
        createdAt: Date = Date()
    ) {
        self.id = id
        self.albumId = albumId
        self.userId = userId
        self.role = role
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id = "shareID"
        case albumId = "albumID"
        case userId = "userID"
        case role
        case createdAt = "created_at"
    }
}
