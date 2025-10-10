//
//  controlBar.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI
// 上部コントロールバー
struct controlBar: View {
    @State private var flashMode: FlashMode = .auto
    var body: some View {

            HStack(spacing: 0) {
                // 戻るボタン
                Button {
                    flashMode.toggle()
                } label: {
                    Text("＞戻る")
                }
                Spacer()
                Text("アルバム名")
                    .foregroundStyle(Color("accentTextColor"))
                Spacer()
                // マップボタン
                Button {
                    flashMode.toggle()
                } label: {
                    Image("mapIcon")
                }
            }
            .padding(.top, 10)
            .padding(.horizontal, 10)

        }
}

#Preview {
    controlBar()
}
