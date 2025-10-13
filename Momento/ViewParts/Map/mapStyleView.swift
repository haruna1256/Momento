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

    var body: some View {

        // Mapを新しい Map(position:...) 初期化子に変更
        Map(position: $position) {

            // アノテーションの表示
            ForEach(locationManager.annotations) { annotation in
                Annotation("現在地", coordinate: annotation.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.red)
                            .font(.title)

                    }
                }
            }

            // ユーザーの位置を示す
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
        }
        .onAppear {
            locationManager.requestLocation()
            // 初期位置を LocationManager の初期 region で設定
            position = .region(locationManager.region)
        }

        // 重要: Equatableな regionUpdateID の変更を監視する
        .onChange(of: locationManager.regionUpdateID) { _ in
            // IDが変わったら、最新の region に基づいて position を更新
            position = .region(locationManager.region)
        }
    }
}

#Preview {
    mapStyleView()
}
