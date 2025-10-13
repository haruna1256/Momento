//
//  mapStyleView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//
import SwiftUI
import MapKit

// マップを表示する
struct mapStyleView: View {
    @StateObject private var locationManager = LocationManager()

    // MapCameraPositionで地図のカメラ位置を管理 (新しいAPI)
    @State private var position: MapCameraPosition = .automatic

    // カテゴリIDからColorを取得する関数
    private func getColor(for categoryId: String) -> Color {
        // allCategoriesからIDが一致するものを探し、そのColorを返す。見つからない場合は灰色を返す。
        return allCategories.first(where: { $0.id == categoryId })?.color ?? .gray
    }

    var body: some View {

        Map(position: $position) {

            // アノテーションの表示 (モックアルバムのピン)
            ForEach(locationManager.annotations) { annotation in
                Annotation(annotation.title, coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(getColor(for: annotation.categoryId))
                            .font(.title)
                    }
                }
            }

            // 現在地を示す青丸を有効化
            UserAnnotation()
        }
        .mapControls {
            //  現在地ボタンを有効化
            MapUserLocationButton()
        }
        .onAppear {
            // 1. 現在地取得を呼び出し（青丸の表示に必要）
            locationManager.requestLocation()

            // 2. モックデータを呼び出して地図に表示
            let mockAlbums = Album.mockAlbums
            locationManager.setPins(from: mockAlbums)

            // 3. 初期位置を設定
            position = .region(locationManager.region)
        }

        // Equatableな regionUpdateID の変更を監視する
        .onChange(of: locationManager.regionUpdateID) { _ in
            // IDが変わったら、最新の region に基づいて position を更新
            position = .region(locationManager.region)
        }
    }
}

#Preview {
    mapStyleView()
}
