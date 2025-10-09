//
//  LocationManager.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//

import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
}
