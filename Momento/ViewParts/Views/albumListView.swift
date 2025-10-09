//
//  albumListView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/09.
//

import SwiftUI

struct albumListView: View {
    var body: some View {
        HStack(spacing: 16) {
            Image("image1")
                .resizable()
                .frame(width: 72, height: 64)

            VStack(alignment: .leading) {
                Text("日付")
                    .font(.caption2)
                Text("Momento")
                    .font(.headline)
                Text("Momento is a photo album app.")
                    .font(.caption2)
                    .lineLimit(1)
            }
            Text("現在地から500m")
                .font(.caption)
                .frame(maxHeight: .infinity, alignment: .bottom)

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
    albumListView()
}
