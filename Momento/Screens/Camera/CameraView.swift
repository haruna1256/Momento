//
//  CameraView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/10.
//

import SwiftUI

struct CameraView: View {
    @State private var isFrontCamera = false
    @State private var flashMode: FlashMode = .auto

    var body: some View {
        ZStack {
            // カメラプレビューエリア (仮)
            Color("bgBodyColor")
                .ignoresSafeArea()

            // UIオーバーレイ
            VStack {
                // 上部コントロールバー (白文字で、背景はカメラプレビュー)
                controlBar()

                Spacer()

                // 下部シャッターボタンエリア (底部)
                shutterArea()
            }
            .padding(.bottom, 30)
            .padding(.horizontal, 20)

        }
        .statusBarHidden(true)
    }

}

// MARK: - 2. ヘルパー構造体 (FlashModeは変更なし)

enum FlashMode {
    case on, off, auto
    // ... (FlashModeの定義は省略) ...
    var iconName: String {
        switch self {
        case .on: return "bolt.fill"
        case .off: return "bolt.slash.fill"
        case .auto: return "bolt.badge.automatic.fill"
        }
    }
    mutating func toggle() {
        switch self {
        case .auto: self = .on
        case .on: self = .off
        case .off: self = .auto
        }
    }
}

#Preview {
    CameraView()
}
