//
//  TabItem.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

// 画面遷移のタブ要素の定義
enum TabItem: CaseIterable {
    case home
    case map
    case notification
    case setting
}

extension TabItem {
    // 選択されている時の画像デザイン
    var selectedImage: Image {
        switch self {
        case .home:
            return Image("iconTabOnHome")
        case .map:
            return Image("iconTabOnMap")
        case .notification:
            return Image("iconTabOnNotification")
        case .setting:
            return Image("iconTabOnSetting")
        }
    }
    // 選択されていない時の画像デザイン
    var unselectedImage: Image {
        switch self {
        case .home:
            return Image("iconTabOffHome")
        case .map:
            return Image("iconTabOffMap")
        case .notification:
            return Image("iconTabOffNotification")
        case .setting:
            return Image("iconTabOffSetting")
        }
    }
    // タイトル
    var title: String {
            switch self {
            case .home: return "ホーム"
            case .map: return "マップ"
            case .notification: return "通知"
            case .setting: return "設定"
            }
        }
}

// 画面遷移元を定義
extension TabItem: View {
    var body: some View {
        switch self {
        case .home:
            HomeView()
        case .map:
            MapView()
        case .notification:
            NotificationView()
        case .setting:
            SettingView()
        }
    }

}
