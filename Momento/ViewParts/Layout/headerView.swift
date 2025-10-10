//
//  headerView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

// ヘッダーのUI設計
struct headerView: View {
    // 選択状態を保持する
    @Binding var selectedTab: TabItem
    var body: some View {
        HStack(spacing: 0) {
            Button {
                // homeに飛ばす
                selectedTab = .home
            } label: {
                Image("logo")
                    .frame(width: 100, height: 42)
            }


            Spacer()
            Button {
                print("アイコンが押されたよ")
            } label: {
                Image("icon")
                    .frame(width: 38, height: 38)
            }
        }
        .padding(.horizontal, 8)
        .frame(height: 60)
        .background(Color("bgColor")
            .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        )
    }
}
