//
//  PhotoConfirmView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/11/11.
//

import SwiftUI
// 撮影後確認画面
struct PhotoConfirmView: View {
    let image: UIImage
    let onDiscard: () -> Void
    let onSend: (_ caption: String?) -> Void

    @State private var caption: String = ""

    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            TextField("キャプションを入力...", text: $caption)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            HStack {
                Button("破棄") { onDiscard() }
                    .padding().background(Color.red).foregroundColor(.white).cornerRadius(10)
                Button("送信") { onSend(caption.isEmpty ? nil : caption) }
                    .padding().background(Color.blue).foregroundColor(.white).cornerRadius(10)
            }
            .padding()
        }
    }
}
