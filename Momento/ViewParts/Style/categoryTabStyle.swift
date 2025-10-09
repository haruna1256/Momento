//
//  categoryTabStyle.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//

import SwiftUI

extension View {

    /// カテゴリタブのスタイル（フォント、文字色、下線）を適用するカスタム修飾子
    func categoryTabStyle(category: Category, isSelected: Bool) -> some View {

        let fontSize: CGFloat = isSelected ? 20 : 16 // 選択時を20、非選択時を16に
        let fontWeight: Font.Weight = .semibold

        return self
            // テキストのスタイルを設定
            .font(.system(size: fontSize, weight: fontWeight))
            .foregroundColor(isSelected ? .black : Color("textColor"))

            // 下線をオーバーレイとして配置
            .overlay(
                // 下線が VStack の中央でなく下端に配置されるように調整するVStack
                VStack(spacing: 4) {
                    Spacer()

                    if isSelected {
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(category.color) // カテゴリの色を下線に反映
                            // 「最近のアルバム」の下線は長く、他はテキスト幅に合わせる
                            .frame(width: category.id == "recent" ? 140 : nil)
                    } else {
                        // 非選択時は透明な線で高さを保持し、テキストがずれるのを防ぐ
                        Rectangle()
                            .frame(height: 2)
                            .foregroundColor(.clear)
                    }
                }
                .padding(.bottom, isSelected ? -4 : 0) // 選択時だけ下線を少し上げる（微調整）
            )
            .padding(.top, isSelected ? 0 : 4) // 非選択時は上へ4ptパディングし、中央揃えからずらす
            .padding(.bottom, isSelected ? 0 : 4) // 非選択時は下に4ptパディング
            .animation(.easeInOut(duration: 0.2), value: isSelected)
    }
}
