//
//  MapView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct MapView: View {
    // LocationManagerは @StateObject として定義
    @StateObject var locationManager = LocationManager()
    let albums = Album.mockAlbums

    var body: some View {
        // GeometryReader はレイアウト全体のサイズを取得するために使用
        GeometryReader { geometry in
            VStack(spacing: 6) {

                mapStyleView()
                    .frame(height: geometry.size.height / 2)// 地図ビューの高さを画面の半分に固定

                ScrollView {
                    VStack(spacing: 16) { // 各アイテム間に8ptのスペースを設定
                        // リストアイテム全体に左右のパディングを適用
                        ForEach(albums) { album in
                            // LocationManagerを引数として渡す
                            albumListView(album: album, locationManager: locationManager)
                        }
                    }
                    .padding(.horizontal, 16) // リスト全体に水平方向の余白
                    .padding(.top, 8)         // 上部に少し余白

                }
                .frame(height: geometry.size.height / 2)
                .background(Color("bgBodyColor")) // ScrollView の背景色
            }
        }
        // 位置情報の要求を開始
        .onAppear {
            locationManager.requestLocation()
        }
    }
}

#Preview {
    // MapView 内で locationManager が @StateObject で定義されているため、引数不要
    MapView()
}
