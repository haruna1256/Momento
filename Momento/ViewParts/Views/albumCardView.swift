//
//  albumCardView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct albumCardView: View {
    let title: String
    let place: String
    let date: String
    let imageName: String
    let categoryColor: Color
    // カードの共通サイズを定数化（前回の修正から流用）
        private let cardWidth: CGFloat = 148
        private let cornerRadiusValue: CGFloat = 8

        private var imageGradient: LinearGradient {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.black.opacity(0.3),
                    Color.clear
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
        }
    var body: some View {
        // カード全体のコンテナ。サイズ、白色背景、角丸、影を設定
        VStack(spacing: 0) {
            ZStack() {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .clipped()
                Rectangle()
                    .foregroundColor(Color("imageShadowColor"))

            }
            .frame(width: cardWidth, height: cardWidth)
            // 下部テキストの表示
            VStack(alignment: .leading, spacing: 4) {
                // メインタイトル
                Text(title)
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(Color(categoryColor))

                // 場所と日付のHStack
                HStack {
                    Text(place)
                        .font(.caption2)
                        .foregroundColor(categoryColor.opacity(0.8))

                    Spacer() // 日付を右端に寄せる

                    Text(date)
                        .font(.caption2)
                        .foregroundColor(categoryColor.opacity(0.8))
                }
            }
            // テキスト部分のパディング（上下左右）
            .padding([.leading, .trailing, .bottom], 8)
            .padding(.top, 0)
            .frame(maxWidth: .infinity) // 幅いっぱいに広げる
        }
        .frame(width: 148, height: 176)
        .background(Color("bgColor"))
        .cornerRadius(8)
        // 薄い影を適用
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
    }
}

#Preview {
    albumCardView(
        title: "ECCコンピュータ専門学校",
        place: "学校",
        date: "2024.06.01",
        imageName: "albumImage",
        categoryColor: .blue
    )
}
