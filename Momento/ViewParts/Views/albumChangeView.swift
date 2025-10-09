//
//  albumChangeView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct albumChangeView: View {
    // 状態のバインディング
    @Binding var selectedCategoryId: String
    // カテゴリリスト全体
    private let categories: [Category] = allCategories
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                // 横スクロール
                // 全てのカテゴリを選択可能にし、横スクロールさせる
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) { // 各タブ間の間隔

                        // 全てのカテゴリ（"最近のアルバム"を含む）をループ
                        ForEach(categories, id: \.id) { category in
                            CategoryTabView(
                                category: category,
                                isSelected: category.id == selectedCategoryId,
                                action: {
                                    // 選択されたIDを更新
                                    selectedCategoryId = category.id
                                }
                            )
                        }
                    }
                    .padding(.leading, 16) // 左端のパディング
                }

                Spacer()

                // アルバム追加ボタン
                AddAlbumButtonView(action: {
                    print("")
                })
                .padding(.trailing, 16)
            }
            .padding(.top, 0) // 上部の余白
        }
        .frame(height: 60) // ヘッダー全体の高さを固定
        .background(Color("bgBodyColor"))
    }
}

// カテゴリーの状態と動き
struct CategoryTabView: View {
    let category: Category
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Text(category.name)
        // 拡張でスタイルを一括適用し、条件分岐を全て排除
            .categoryTabStyle(category: category, isSelected: isSelected)
            .onTapGesture(perform: action)
            .padding(.vertical, 8) // タップエリアを広げる
    }
}

// 新規カテゴリーボタン
struct AddAlbumButtonView: View {
    let action: () -> Void


    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 20, weight: .regular))
                .foregroundColor(Color("onColor")) // 「+」の色
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(Color("bgColor")) // ボタンの背景
                        .shadow(color: Color.blue.opacity(0.1), radius: 5, x: 0, y: 2)
                )
            // 外側の円形のエフェクト
                .overlay(
                    Circle()
                        .stroke(Color("onColor").opacity(0.1), lineWidth: 2)
                )
        }
    }
}


#Preview {
    albumChangeView(selectedCategoryId: .constant("000"))
}
