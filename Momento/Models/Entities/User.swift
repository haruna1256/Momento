//
//  User.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// ユーザー情報を保持するテーブル
import Foundation

struct User: Identifiable, Decodable {
    let id: String          // ユーザーID
    let name: String        // ユーザー名
    let email: String       // メールアドレス
    let iconUrl: URL?       // アイコン画像
    let createdAt: Date     // 登録日時

    init(
        id: String,
        name: String,
        email: String,
        iconUrl: URL? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.iconUrl = iconUrl
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id = "userID"
        case name = "uName"
        case email = "Email"
        case iconUrl = "icon_url"
        case createdAt = "created_at"
    }
}
