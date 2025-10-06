//
//  Category.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// 共有グループ（友達グループ・カテゴリ）を管理するテーブル
import Foundation

struct Category: Identifiable, Decodable {
    let id: String                      // カテゴリーのID
    let name: String                    // カテゴリーの名前
    var colorHex: String = "#000000"    // カテゴリーのカラー
    let createdBy: String               // 作成者
    let createdAt: Date                 // 登録日時

    init(
        id: String,
        name: String,
        colorHex: String = "#000000",
        createdBy: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.createdBy = createdBy
        self.createdAt = createdAt
    }

    enum CodingKeys: String, CodingKey {
        case id = "categoryID"
        case name
        case colorHex = "color"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
}
