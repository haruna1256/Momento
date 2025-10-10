//
//  shutterArea.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI
// 下部シャッターボタンエリア
struct shutterArea: View {
    @State private var isFrontCamera = false
    var body: some View {
            HStack(spacing: 0) {
                // 1. アルバム/ギャラリーボタン (過去の写真を小さく表示するイメージ)
                Button {
                    print("ギャラリーへ移動")
                } label: {
                    // 過去のサムネイルのプレースホルダ
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("onColor"))
                        .frame(width: 48, height: 48)
                        .overlay(
                            Image(systemName: "photo.fill")
                                .foregroundColor(Color("bgColor"))
                        )

                }

                Spacer()

                // 2. シャッターボタン (白基調でアクセントカラーの枠)
                Button {
                    print("シャッターを切る！")
                } label: {
                    cameraIconView(
                        frameSize: 72,
                        cameraIconSize: 45
                    )
                }

                Spacer()

                // 3. カメラフリップボタン
                Button {
                    isFrontCamera.toggle()
                    print(isFrontCamera ? "内カメに切り替え" : "外カメに切り替え")
                } label: {

                    Image("circlepath")
                        .font(.title)
                        .foregroundColor(.white)
                }
                .frame(width: 48, height: 48) // 見た目のバランス調整
            }
            .padding(.horizontal, 10)
    }
}

#Preview {
    shutterArea()
}
