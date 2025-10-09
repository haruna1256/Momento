//
//  Notification.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//

import SwiftUI
import Foundation

enum NotificationType: String {
    case management = "運営"
    case album = "アルバム"
    case photo = "写真"

    // タイプに応じて色を決定するロジック
    var color: String {
        switch self {
        case .management:
            return "managementColor"
        case .album:
            return "albumColor"
        case .photo:
            return "photoColor"
        }
    }
}

struct NotificationItem: Identifiable {
    let id = UUID()
    let type: NotificationType
    let date: String
    let message: String
}

// 画像を再現するためのサンプルデータ
let sampleNotifications = [
    NotificationItem(type: .management, date: "2025/10/06", message: "運営からのお知らせ"),
    NotificationItem(type: .album, date: "2025/10/05", message: "CCさんがBBアルバムに追加されました"),
    NotificationItem(type: .photo, date: "2025/09/06", message: "AAさんがBBアルバムに写真を追加しました"),
    NotificationItem(type: .management, date: "2025/09/12", message: "運営からのお知らせ"),
    NotificationItem(type: .management, date: "2025/09/03", message: "運営からのお知らせ"),
]

