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
            return Image("icnTabOnHome")
        case .map:
            return Image("icnTabOnMap")
        case .notification:
            return Image("icnTabOnNotification")
        case .setting:
            return Image("icnTabOnSetting")
        }
    }
    // 選択されていない時の画像デザイン
    var unselectedImage: Image {
        switch self {
        case .home:
            return Image("icnTabOffHome")
        case .map:
            return Image("icnTabOffMap")
        case .notification:
            return Image("icnTabOffNotification")
        case .setting:
            return Image("icnTabOffSetting")
        }
    }
}

// 画面遷移元を定義
extension TabItem: View {
    var body: some View {
        switch self {
        case .home:

        case .map:

        case .notification:

        case .setting:

        }
    }

}
