//
//  CategoryMember.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// グループに誰が所属しているか を管理する中間テーブル
import Foundation

struct CategoryMember: Identifiable, Decodable {
    let id: String                  // メンバーのID
    let categoryId: String          // カテゴリーのID
    let userId: String              // ユーザーのID
    var role: String = "member"     // 権限
    let joinedAt: Date              // 参加日時

    init(
        id: String,
        categoryId: String,
        userId: String,
        role: String = "member",
        joinedAt: Date = Date()
    ) {
        self.id = id
        self.categoryId = categoryId
        self.userId = userId
        self.role = role
        self.joinedAt = joinedAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case categoryId
        case userId
        case role
        case joinedAt = "joined_at"
    }
}
