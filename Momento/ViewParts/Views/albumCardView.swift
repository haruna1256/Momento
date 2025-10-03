//
//  albumCardView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct albumCardView: View {
    var body: some View {
        // カード全体のコンテナ。サイズ、白色背景、角丸、影を設定
                VStack(spacing: 0) {
                    ZStack() {
                        Image("albumImage")
                            .resizable()
                            .scaledToFill()
                            .clipped()
                        Rectangle()
                            .foregroundColor(Color("imageShadowColor"))

                    }
                    .frame(width: 148, height: 148)
                    // 下部テキストの表示
                    VStack(alignment: .leading, spacing: 4) {
                        // メインタイトル
                        Text("ECCコンピュータ専門学校")
                            .font(.caption2)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)

                        // カテゴリと日付のHStack
                        HStack {
                            Text("学校")
                                .font(.caption2)
                                .foregroundColor(.gray)

                            Spacer() // 日付を右端に寄せる

                            Text("2024.06.01")
                                .font(.caption2)
                                .foregroundColor(.gray)
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
    albumCardView()
}
