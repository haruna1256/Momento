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
    let availableAlbums: [Album] // アルバム一覧
    let currentLocation: String? // 現在の位置情報（住所）
    let onDiscard: () -> Void
    let onSend: (PhotoMetadata) -> Void

    @State private var selectedAlbumId: String
    @State private var place: String = ""
    @State private var memo: String = ""
    @FocusState private var focusedField: Field?

    // 初期化時にデフォルトのアルバムIDを設定
    init(
        image: UIImage,
        availableAlbums: [Album],
        defaultAlbumId: String? = nil,
        currentLocation: String? = nil,
        onDiscard: @escaping () -> Void,
        onSend: @escaping (PhotoMetadata) -> Void
    ) {
        self.image = image
        self.availableAlbums = availableAlbums
        self.currentLocation = currentLocation
        self.onDiscard = onDiscard
        self.onSend = onSend

        // 初期選択アルバム
        _selectedAlbumId = State(initialValue: defaultAlbumId ?? availableAlbums.first?.id ?? "")

        // 位置情報があれば初期値として設定
        if let location = currentLocation {
            _place = State(initialValue: location)
        }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                // 上部: 撮影した写真
                photoPreviewSection

                // 下部: 入力フォーム
                inputFormSection
            }
        }
    }

    // MARK: - Views

    private var photoPreviewSection: some View {
        ZStack {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: .infinity)

            // 閉じるボタン（左上）
            VStack {
                HStack {
                    Button {
                        onDiscard()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .padding()

                    Spacer()
                }
                Spacer()
            }
        }
    }

    private var inputFormSection: some View {
        VStack(spacing: 16) {
            // アルバム選択
            albumPicker

            // 場所入力
            placeTextField

            // メモ入力
            memoTextField

            // ボタンエリア
            actionButtons
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color("bgBodyColor"))
    }

    private var albumPicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(Color("accentTextColor"))
                Text("アルバム")
                    .foregroundColor(Color("accentTextColor"))
                    .font(.subheadline)
            }

            Menu {
                ForEach(availableAlbums) { album in
                    Button {
                        selectedAlbumId = album.id
                    } label: {
                        HStack {
                            Text(album.title)
                            if selectedAlbumId == album.id {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedAlbumTitle)
                        .foregroundColor(Color("accentTextColor"))
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(Color("accentTextColor"))
                }
                .padding(12)
                .background(Color("bgColor").opacity(0.8))
                .cornerRadius(10)
            }
        }
    }

    private var placeTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "location.fill")
                    .foregroundColor(Color("accentTextColor"))
                Text("場所")
                    .foregroundColor(Color("accentTextColor"))
                    .font(.subheadline)
            }

            TextField("例: 東京タワー", text: $place)
                .focused($focusedField, equals: .place)
                .textFieldStyle(.plain)
                .padding(12)
                .background(Color("bgColor").opacity(0.8))
                .cornerRadius(10)
                .foregroundColor(Color("accentTextColor"))
        }
    }

    private var memoTextField: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(Color("accentTextColor"))
                Text("メモ")
                    .foregroundColor(Color("accentTextColor"))
                    .font(.subheadline)
            }

            TextField("例: 友達と訪れた思い出の場所", text: $memo, axis: .vertical)
                .focused($focusedField, equals: .memo)
                .textFieldStyle(.plain)
                .lineLimit(3...5)
                .padding(12)
                .background(Color("bgColor").opacity(0.8))
                .cornerRadius(10)
                .foregroundColor(Color("accentTextColor"))
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 12) {
            // 破棄ボタン
            Button {
                onDiscard()
            } label: {
                HStack {
                    Image(systemName: "trash")
                    Text("破棄")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.red.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(12)
                .font(.headline)
            }

            // 送信ボタン
            Button {
                focusedField = nil // キーボードを閉じる

                let metadata = PhotoMetadata(
                    albumId: selectedAlbumId,
                    place: place.isEmpty ? nil : place,
                    memo: memo.isEmpty ? nil : memo
                )

                onSend(metadata)
            } label: {
                HStack {
                    Image(systemName: "paperplane.fill")
                    Text("送信")
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .font(.headline)
            }
        }
    }

    // MARK: - Helpers

    private var selectedAlbumTitle: String {
        availableAlbums.first(where: { $0.id == selectedAlbumId })?.title ?? "未選択"
    }

    enum Field {
        case place, memo
    }
}

// メタデータを受け渡す構造体
struct PhotoMetadata {
    let albumId: String
    let place: String?
    let memo: String?
}

// プレビュー
#Preview {
    PhotoConfirmView(
        image: UIImage(systemName: "photo.fill")!.withTintColor(.gray, renderingMode: .alwaysOriginal),
        availableAlbums: Album.mockAlbums,
        defaultAlbumId: Album.mockAlbums.first?.id,
        currentLocation: "大阪府大阪市中央区道頓堀",
        onDiscard: { print("破棄") },
        onSend: { metadata in
            print("送信 - アルバム: \(metadata.albumId), 場所: \(metadata.place ?? "なし"), メモ: \(metadata.memo ?? "なし")")
        }
    )
}
