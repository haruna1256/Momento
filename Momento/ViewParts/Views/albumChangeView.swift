//
//  albumChangeView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct albumChangeView: View {
            // 現在選択されているカテゴリ
            @State private var selectedCategory: String = "最近のアルバム"
            // カテゴリリスト
            private let categories = ["家族", "友達", "学校", "バイト", "自分"]
            var body: some View {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 4) {
                            // 「最近のアルバム」はカテゴリリストから独立したデザインのため、分離
                            VStack(spacing: 0) {
                                Text("最近のアルバム")
                                    .font(.headline) // 大きめの太字
                                    .foregroundColor(.black)

                                // アクティブなカテゴリを示すアンダーライン
                                Rectangle()
                                    .frame(width: 120, height: 2)
                                    .foregroundColor(Color("onColor"))
                            }
                            .padding(.leading, 8)
                            // 横スクロール
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 10) {
                                    ForEach(categories, id: \.self) { category in
                                        // カテゴリは非アクティブなスタイル
                                        Text(category)
                                            .font(.body)
                                            .foregroundColor(Color("offColor"))
                                            .onTapGesture {
                                                // 選択時の処理（例: selectedCategory = category）
                                            }
                                    }
                                }

                                .frame(maxHeight: .infinity, alignment: .top)
                            }
                            // スクロールビューが右端まで伸びないように制限
                            .frame(width: 190)
                            Spacer()

                            // MARK: - 3. 追加ボタン（+）
                            Button(action: {
                                print("アルバム追加")
                            }) {
                                Image(systemName: "plus")
                                    .font(.system(size: 20, weight: .regular))
                                    .foregroundColor(Color("onColor")) // 「+」の色
                                    .frame(width: 48, height: 48)
                                    .background(
                                        Circle()
                                            .fill(Color("bgColor"))
                                            .shadow(color: Color.blue.opacity(0.1), radius: 5, x: 0, y: 2) // わずかな影
                                    )
                                    // 外側の円形のエフェクト（非常に薄いライトブルー）
                                    .overlay(
                                        Circle()
                                            .stroke(Color("onColor").opacity(0.2), lineWidth: 2)
                                    )
                            }
                            .padding(.trailing, 16)
                        }
                        .padding(.top, 0) // 上部の余白
                    }
                .frame(height: 60) // ヘッダー全体の高さを固定
            }
        }

#Preview {
    albumChangeView()
}
