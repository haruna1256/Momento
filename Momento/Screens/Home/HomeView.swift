//
//  HomeView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct HomeView: View {
    // 仮のアルバムデータ
    let albums = Array(1...10).map { "アルバム \($0)" }

    // 2列レイアウト
        let columns = [
            GridItem(.flexible(), spacing: 10),
            GridItem(.flexible(), spacing: 10)
        ]
    var body: some View {
        VStack(spacing: 8) {
            albumChangeView()

            // アルバムカードグリッド表示
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    // データ配列を基にカードを生成
                    ForEach(sampleAlbums) { album in
                        albumCardView(
                            title: album.title,
                            place: album.place,
                            date: album.date,
                            imageName: album.imageName
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
