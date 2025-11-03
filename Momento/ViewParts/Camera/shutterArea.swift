//
//  shutterArea.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI
// 下部シャッターボタンエリア
struct shutterArea: View {
    // 親Viewのカメラマネージャーの状態を受け取る
    @Binding var isFrontCamera: Bool

    // シャッターボタンのアクションを親Viewに伝えるためのクロージャ
    let onShutterTap: () -> Void
    // カメラフリップのアクションを親Viewに伝えるためのクロージャ
    let onFlipTap: () -> Void
    var body: some View {
        HStack(spacing: 0) {
            // アルバム/ギャラリーボタン (過去の写真を小さく表示するイメージ)
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
            // シャッターボタン
            Button {
                onShutterTap()
            } label: {
                cameraIconView(
                    frameSize: 72,
                    cameraIconSize: 45
                )
            }
            Spacer()
            // カメラフリップボタン
            Button {
                onFlipTap()
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
    @State var isFront = false
    return ZStack {
        Color.black.ignoresSafeArea()
        shutterArea(
            isFrontCamera: $isFront,
            onShutterTap: { print("Preview Shutter") },
            onFlipTap: { isFront.toggle() }
        )
    }
}
