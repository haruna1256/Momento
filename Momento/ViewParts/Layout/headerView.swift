//
//  headerView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

// ヘッダーのUI設計
struct headerView: View {
    var body: some View {
        HStack(spacing: 0) {
            Image("logo")
                .frame(width: 100, height: 42)
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
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        )
    }
}

#Preview {
    headerView()
}
