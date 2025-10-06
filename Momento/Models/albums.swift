//
//  albums.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import Foundation

struct album: Identifiable {
    let id = UUID()
    let title: String
    let place: String
    let date: String
    let imageName: String
    let category: String // フィルタリング用
}

// ダミーデータ（画像に合わせて作成）
let sampleAlbums = [
    album(title: "ECCコンピュータ専門学校", place: "学校", date: "2024.06.01", imageName: "image1", category: "学校"),
    album(title: "うちのにゃんこ", place: "おうち", date: "2025.09.12", imageName: "image2", category: "家族"),
    album(title: "水族館！！", place: "新宿区西新宿町...", date: "2025.08.28", imageName: "image3", category: "友達"),
    album(title: "ハロウィン🎃", place: "公園", date: "2025.10.31", imageName: "image4", category: "友達"),
    album(title: "水族館！！！", place: "新宿区西新宿町...", date: "2025.08.28", imageName: "image5", category: "友達"),
    album(title: "水族館！！！", place: "新宿区西新宿町...", date: "2025.08.28", imageName: "image6", category: "友達"),
]
