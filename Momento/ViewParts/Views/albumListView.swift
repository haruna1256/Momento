//
//  albumListView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//
import CoreLocation
import SwiftUI

struct albumListView: View {
    let album: Album
    // LocationManagerをObservableObjectとして受け取る
    @ObservedObject var locationManager: LocationManager

    private func getColor(for categoryId: String) -> Color {
            return allCategories.first(where: { $0.id == categoryId })?.color ?? .gray
        }
    // LocationManagerのcurrentLocationを使って距離を計算
    private func calculateDistance(from album: Album) -> Int? {
            // 現在地がまだ取得されていない場合はnilを返す
            guard let userLocation = locationManager.currentLocation else {
                return nil
            }

            // アルバムの緯度経度がオプショナルでないため、そのまま使用
            let albumLocation = CLLocation(latitude: album.latitude, longitude: album.longitude)

            // メートル単位で距離を取得し、Int型に変換
            return Int(userLocation.distance(from: albumLocation).rounded())
        }
    var body: some View {
        // 必要な値を計算
                let categoryColor = getColor(for: album.categoryId)
                let distance = calculateDistance(from: album) // Int? 型
        // オプショナルな場所 (place) を安全にアンラップし、デフォルト値を設定
        let displayPlace = album.place ?? "場所不明"

        HStack(spacing: 16) {
            Image(album.coverPhoto)
                .resizable()
                .frame(width: 72, height: 64)

            VStack(alignment: .leading) {
                Text(album.updatedAt, style: .date)
                    .font(.caption2)
                    .foregroundStyle(categoryColor)
                Text(album.title)
                    .font(.subheadline)
                    .foregroundStyle(categoryColor)
                HStack(spacing: 0) {
                    Text(album.place)
                        .foregroundStyle(categoryColor)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer()
                    Text(distance.map { "現在地から\($0)m" } ?? "現在地から---m")
                        .foregroundStyle(categoryColor)
                        .font(.caption)
                        .frame(maxHeight: .infinity, alignment: .bottom)

                }
            }


            Image("goIcon")
                .resizable()
                .frame(width:32, height: 32)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color("bgColor"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
        .frame(maxWidth: .infinity)
        .frame(height: 72)
    }
}

#Preview {
    // LocationManagerのモックインスタンスを作成し、現在のアルバムリストを渡す
    albumListView(album: Album.dotonboriFood, locationManager: LocationManager())
}
