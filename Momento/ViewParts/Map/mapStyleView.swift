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
    let locationManager = LocationManager()
    var body: some View {
        Map(interactionModes: .all) {
                    UserAnnotation(anchor: .center) { userLocation in
                        VStack {
                            Image(systemName: "arrow.up")
                                .rotationEffect(.degrees(userLocation.heading?.magneticHeading ?? 0))
                                .foregroundColor(.blue)
                            Circle()
                                .foregroundStyle(.blue)
                                .padding(2)
                                .background(
                                    Circle()
                                        .fill(.white)
                                )
                            Text("me")
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                }
                .onAppear {
                    locationManager.requestLocationAuthorization()
                }
    }
}

#Preview {
    mapStyleView()
}
