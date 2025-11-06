//
//  controlBar.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI
// 上部コントロールバー
struct controlBar: View {
    // フラッシュ切り替え
    @Binding var flashMode: FlashMode
    // Environment object for dismissing the view (画面を閉じるため)
    @Environment(\.dismiss) var dismiss
    var body: some View {

        HStack(spacing: 0) {
            // 戻るボタン
            Button {
                dismiss()
            } label: {
                Text("＞戻る")
            }
            Spacer()
            Text("アルバム名")
                .foregroundStyle(Color("accentTextColor"))
            Spacer()
            // フラッシュ切り替えボタン
            Button {
                flashMode.toggle()
            } label: {
                Image(systemName: flashMode.iconName)
                    .font(.title2)
                    .padding(8)
                    .clipShape(Circle())
            }
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    @Previewable @State var mode: FlashMode = .auto

        return ZStack {
            // カメラプレビューの代わりとして黒い背景を設定
            Color.black.ignoresSafeArea()

            controlBar(flashMode: $mode)
        }
}
