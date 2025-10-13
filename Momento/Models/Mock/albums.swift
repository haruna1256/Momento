//
//  albums.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import Foundation
import SwiftUI

struct AlbumMock: Identifiable {
    let id = UUID()
    let title: String
    let place: String
    let date: String
    let imageName: String
    let categoryID: String // カテゴリーID
}

// MARK: - ダミーデータ
let AlbumMocks = [
    AlbumMock(title: "ECCコンピュータ専門学校", place: "学校", date: "2024.06.01", imageName: "image1", categoryID: "003"),
    AlbumMock(title: "うちのにゃんこ", place: "おうち", date: "2025.09.12", imageName: "image2", categoryID: "001"),
    AlbumMock(title: "水族館！！", place: "新潟県新潟市中央区西船見町５９３２−４４５", date: "2025.08.28", imageName: "image3", categoryID: "002"),
    AlbumMock(title: "ハロウィン🎃", place: "公園", date: "2025.10.31", imageName: "image4", categoryID: "001"),
    AlbumMock(title: "友達との山登り", place: "高尾山", date: "2025.05.01", imageName: "image5", categoryID: "002"),
    AlbumMock(title: "一人旅の思い出", place: "京都", date: "2025.04.20", imageName: "image6", categoryID: "005"),
]

