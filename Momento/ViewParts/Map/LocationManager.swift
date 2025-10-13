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
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

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
             self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        }
    }

    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        // startUpdatingLocation() の呼び出しは権限付与後に delegate メソッドで行う。
    }

    // 位置情報が更新されたときに呼ばれるdelegateメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        // Publishing changesエラー対策: メインスレッドの次のサイクルで実行
        DispatchQueue.main.async {
            let center = location.coordinate
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)

            // 1. annotations の更新
            self.annotations = [LocationAnnotation(coordinate: center)]

            // 2. region と regionUpdateID の更新
            self.region = MKCoordinateRegion(center: center, span: span)
            self.regionUpdateID = UUID() // IDを更新してビューに通知

            // 取得成功後、停止する
            manager.stopUpdatingLocation()
        }
    }

    // 権限ステータスが変更されたときに呼ばれるdelegateメソッド
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            manager.startUpdatingLocation() // 権限付与後に更新開始
        case .denied, .restricted, .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
