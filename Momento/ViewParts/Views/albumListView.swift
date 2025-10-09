//
//  albumListView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//

import SwiftUI

struct albumListView: View {
    let title: String
    let date: String
    let imageName: String
    let place: String
    let categoryColor: Color
    let location: Int
    var body: some View {
        HStack(spacing: 16) {
            Image(imageName)
                .resizable()
                .frame(width: 72, height: 64)

            VStack(alignment: .leading) {
                Text(date)
                    .font(.caption2)
                    .foregroundStyle(categoryColor)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(categoryColor)
                HStack(spacing: 0) {
                    Text(place)
                        .foregroundStyle(categoryColor)
                        .font(.caption2)
                        .lineLimit(1)
                    Spacer()
                    Text("現在地から\(location)m")
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
        .frame(width: .infinity, height: 72)
    }
}

#Preview {
    albumListView(
        title: "ECCコンピューター専門学校",
                date: "2025/08/12",
                imageName: "image1",
                place: "学校",
                categoryColor: .blue,
                location: 250
    )
}
