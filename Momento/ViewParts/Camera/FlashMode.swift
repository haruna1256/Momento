//
//  FlashMode.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/03.
//

// カメラのモードの定義
enum FlashMode {
    case on, off, auto

    var iconName: String {
        switch self {
        case .on: return "bolt.fill"
        case .off: return "bolt.slash.fill"
        case .auto: return "bolt.badge.automatic.fill"
        }
    }

    // 次のモードに切り替えるメソッド
    mutating func toggle() {
        switch self {
        case .auto: self = .on
        case .on: self = .off
        case .off: self = .auto
        }
    }
}
