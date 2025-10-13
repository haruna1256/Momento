//
//  Category.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// 共有グループ（友達グループ・カテゴリ）を管理するテーブル
import Foundation
import SwiftUI

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

    // SwiftUI Colorを取得するComputed Propertyを追加
    var color: Color {
        return Color(hex: self.colorHex)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "categoryID"
        case name
        case colorHex = "color"
        case createdBy = "created_by"
        case createdAt = "created_at"
    }
}

// ダミーデータ（「最近のアルバム」を特殊なカテゴリとして含める）
let allCategories = [
    Category(id: "000", name: "最近のアルバム", colorHex: "#4C81FF", createdBy: "System"), // 青
    Category(id: "001", name: "家族", colorHex: "#FF7D7D", createdBy: "User"), // 赤
    Category(id: "002", name: "友達", colorHex: "#008b8b", createdBy: "User"), // 緑
    Category(id: "003", name: "学校", colorHex: "#A0A0FF", createdBy: "User"), // 薄紫
    Category(id: "004", name: "バイト", colorHex: "#FFFF7D", createdBy: "User"), // 黄
    Category(id: "005", name: "自分", colorHex: "#E0E0E0", createdBy: "User") // グレー
]
