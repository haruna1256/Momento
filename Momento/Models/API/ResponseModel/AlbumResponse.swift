//
//  AlbumResponse.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/06.
//

// アルバムの情報を取得する要素の定義
import Foundation

struct AlbumResponse: Decodable {
    let albums: [Album]
}
