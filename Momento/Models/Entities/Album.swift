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
    let coverPhoto: String              // 表紙の画像
    let place: String                   // 写真の住所or地名
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
        coverPhoto: String,
        place: String,
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
        self.coverPhoto = coverPhoto
        self.place = place
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
        case coverPhoto
        case place
        case latitude
        case longitude
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case photos
        case sharedUsers
    }
}

extension Album {

    /// テスト用のモックアルバムデータ配列
    static var mockAlbums: [Album] {
        return [
            Album.dotonboriFood,
            Album.osakaCastle,
            Album.kobeHarbor,
            Album.emptyKyoto
        ]
    }

    /// モックデータ 1: 道頓堀グルメ (大阪、中心地)
    static var dotonboriFood: Album {
        let albumId = "album-osaka-001"

        let photos = [
            Photo(
                id: "p-o01",
                albumId: albumId,
                imageUrl: URL(string: "https://example.com/dotonbori/food1.jpg")!,
                caption: "グリコの前！",
                place: "道頓堀",
                latitude: 34.6687,
                longitude: 135.5012,
                takenAt: Date(timeIntervalSinceNow: -86400 * 5)
            ),
            Photo(
                id: "p-o02",
                albumId: albumId,
                imageUrl: URL(string: "https://example.com/dotonbori/takoyaki.jpg")!,
                caption: "本場のたこ焼き",
                place: "千日前",
                latitude: 34.6720,
                longitude: 135.5030,
                takenAt: Date(timeIntervalSinceNow: -86400 * 4)
            )
        ]

        return Album(
            id: albumId,
            ownerId: "user-a",
            title: "🐙 道頓堀グルメ天国",
            description: "食い倒れの旅！たこ焼き、お好み焼き、串カツ。",
            categoryId: "002",
            coverPhoto: "Image7",
            place: "道頓堀",
            latitude: 34.6685,
            longitude: 135.5015, // アルバムの緯度経度
            createdAt: Date(timeIntervalSinceNow: -86400 * 10),
            updatedAt: Date(timeIntervalSinceNow: -86400 * 3),
            photos: photos
        )
    }

    /// モックデータ 2: 大阪城の桜 (大阪、少し東)
    static var osakaCastle: Album {
        let albumId = "album-osaka-002"

        let photos = [
            Photo(
                id: "p-o03",
                albumId: albumId,
                imageUrl: URL(string: "https://example.com/castle/castle1.jpg")!,
                caption: "天守閣と桜",
                place: "大阪城公園",
                latitude: 34.6872,
                longitude: 135.5256,
                takenAt: Date(timeIntervalSinceNow: -86400 * 2)
            )
        ]

        return Album(
            id: albumId,
            ownerId: "user-b",
            title: "🏯 大阪城 2025年春",
            description: "桜が満開で最高でした。共同編集者あり。",
            categoryId: "001",
            coverPhoto: "Image8",
            place: "大阪城",
            latitude: 34.6873,
            longitude: 135.5262,
            createdAt: Date(timeIntervalSinceNow: -86400 * 5),
            updatedAt: Date(),
            photos: photos,
            sharedUsers: [
                AlbumShare(id: "s-001", albumId: albumId, userId: "user-c", role: "viewer")
            ]
        )
    }

    /// モックデータ 3: 神戸ハーバーランド (大阪近隣、写真の位置情報なしの例)
    static var kobeHarbor: Album {
        let albumId = "album-osaka-003"
        let photos = [
             Photo(
                id: "p-o04",
                albumId: albumId,
                imageUrl: URL(string: "https://example.com/kobe/harbor.jpg")!,
                caption: "夜景が綺麗",
                place: "神戸ハーバーランド",
                latitude: nil, // ⭐緯度経度なしの例 (オプショナル対応)
                longitude: nil,
                takenAt: Date(timeIntervalSinceNow: -86400)
            )
        ]
        return Album(
            id: albumId,
            ownerId: "user-a",
            title: "🛳️ 神戸の夜景",
            description: "モザイクで撮った写真。",
            categoryId: "001",
            coverPhoto: "Image9",
            place: "神戸",
            latitude: 34.6853, // アルバムの緯度経度 (神戸)
            longitude: 135.1856,
            createdAt: Date(timeIntervalSinceNow: -86400),
            updatedAt: Date(timeIntervalSinceNow: -86400),
            photos: photos
        )
    }

    /// モックデータ 4: 空の新規アルバム (京都、北東)
    static var emptyKyoto: Album {
        let albumId = "album-osaka-004"
        return Album(
            id: albumId,
            ownerId: "user-d",
            title: "⛩️ 次の京都旅行計画",
            categoryId: "002",
            coverPhoto: "Image10",
            place: "京都",
            latitude: 35.0116, // 京都御所付近
            longitude: 135.7681,
            createdAt: Date(timeIntervalSinceNow: -86400 * 1),
            updatedAt: Date(timeIntervalSinceNow: -86400 * 1)
        )
    }
}
