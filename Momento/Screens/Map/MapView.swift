//
//  MapView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct MapView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 6) {
                mapStyleView()
                    .frame(height: geometry.size.height / 2)
                ScrollView {
                    albumListView(
                        title: "ECCコンピューター専門学校",
                        date: "2025/08/12",
                        imageName: "image1",
                        place: "学校",
                        categoryColor: .blue,
                        location: 250
                    )
                }
                .frame(height: geometry.size.height / 2)
            }
            .background(Color("bgBodyColor"))
        }
    }
}

#Preview {
    MapView()
}
