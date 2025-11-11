//
//  LocationManager.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.


import MapKit
import CoreLocation
import Combine

// 位置情報のアノテーションを表す構造体
struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let title: String
    let categoryId: String
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()
    // 現在地を保持するプロパティ
    @Published var currentLocation: CLLocation?

    @Published private(set) var annotations: [LocationAnnotation] = []

    // 地図の表示領域
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 35.6895, longitude: 139.6917), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

    // 重要: regionが更新されたことを通知するためのEquatableなID
    @Published var regionUpdateID = UUID()

    override init() {
        super.init()
        locationManager.delegate = self

        // desiredAccuracy の設定は、init の完了を待ってから実行する。
        DispatchQueue.main.async {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        }
    }


    func requestLocation() {
            locationManager.requestWhenInUseAuthorization()
            // 許可が得られたかどうかはデリゲートメソッドで確認
        }

    // 位置情報の更新を開始
        private func startUpdatingLocation() {
            locationManager.startUpdatingLocation()
        }

    func setPins(from albums: [Album]) {

        let newAnnotations: [LocationAnnotation] = albums.map { album in
            // Albumの緯度経度を使ってLocationAnnotationを作成
            return LocationAnnotation(
                coordinate: CLLocationCoordinate2D(
                    latitude: album.latitude,
                    longitude: album.longitude
                ),
                title: album.title, // Albumのタイトルをそのまま使用
                categoryId: album.categoryId
            )
        }

        // 1. annotations を更新
        DispatchQueue.main.async {
            self.annotations = newAnnotations

            // 複数のピンに対応するため、regionは最初のピンに合わせる
            if let firstAlbum = albums.first {
                let center = CLLocationCoordinate2D(latitude: firstAlbum.latitude, longitude: firstAlbum.longitude)
                let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05) // 広めのズームレベル
                self.region = MKCoordinateRegion(center: center, span: span)
                self.regionUpdateID = UUID() // 更新通知
            }
        }
    }

    // 位置情報が更新されたときに呼ばれるdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.currentLocation = location

        DispatchQueue.main.async {
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

            // region の更新は継続（地図の中心を現在地に合わせるため）
            self.region = MKCoordinateRegion(center: center, span: span)
            self.regionUpdateID = UUID()

            // 取得成功後、停止する
            manager.stopUpdatingLocation()
        }
    }
    // 権限ステータスが変更されたときに呼ばれるdelegateメソッド
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            // エラー処理（特にシミュレータで位置情報が設定されていない場合によく発生）
            print("Location update failed: \(error.localizedDescription)")
        }
}
