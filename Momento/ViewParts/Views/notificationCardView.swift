//
//  notificationCardView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/07.
//

import SwiftUI

struct notificationCardView: View {
    // 新しいデータ構造を受け取る
    let item: NotificationItem
    // 表示内容
    let category: String = "運営"
    let date: String = "2025/10/06"
    let title: String = "運営からのお知らせ"

    var body: some View {
        VStack(spacing: 0) {
            // 通知内容
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(item.type.rawValue)
                        .foregroundColor(Color(item.type.color))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color(item.type.color), lineWidth: 2)
                        )
                    Text(item.date)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                }
                // 投稿内容
                Text(item.message)
                    .font(.body)
                    .padding(.leading, 38)
                    .foregroundColor(Color("textColor"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal)
            // 下線
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 3)
                .foregroundColor(Color("accentTextColor"))
                .padding(.horizontal)
        }
        .background(Color("bgBodyColor"))
    }
}

#Preview {
    notificationCardView(item: NotificationItem(type: .album, date: "2025/10/05", message: "CCさんがBBアルバムに追加されました"))
}
