//
//  HomeView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct HomeView: View {
    // カテゴリ選択の状態を保持する @State を追加
    @State private var selectedCategoryId: String = "000"
    // 全てのアルバムデータ
    private let allAlbums: [AlbumMock] = AlbumMocks

    // 2列レイアウト
    let columns = [
        GridItem(.flexible(), spacing: 5),
        GridItem(.flexible(), spacing: 5)
    ]
    // 選択されたカテゴリに基づいてアルバムをフィルタリング
    private var filteredAlbums: [AlbumMock] {
        if selectedCategoryId == "000" {
            // "最近のアルバム": 日付降順でソート（String比較）
            return allAlbums.sorted(by: { $0.date > $1.date })
        } else {
            // AlbumMockの .category (ID) が selectedCategoryId (ID) と一致するもののみをフィルタ
            return allAlbums.filter { $0.categoryID == selectedCategoryId }
        }
    }
    var body: some View {
        VStack(spacing: 8) {
            albumChangeView(selectedCategoryId: $selectedCategoryId)
                .zIndex(1)

            // アルバムカードグリッド表示
            ScrollView {
                LazyVGrid(columns: columns, spacing: 30) {
                    // データ配列を基にカードを生成
                    ForEach(filteredAlbums) { album in
                        albumCardView(
                            title: album.title,
                            place: album.place,
                            date: album.date,
                            imageName: album.imageName,
                            categoryColor: album.categoryColor
                        )
                    }
                }
            }
            .padding(.horizontal, 10)

        }
        .background(Color("bgBodyColor"))
    }
}

#Preview {
    HomeView()
}
