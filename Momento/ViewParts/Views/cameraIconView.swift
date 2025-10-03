//
//  cameraIconView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct cameraIconView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 64, height: 64)
                .foregroundStyle(Color("bgColor"))

            Image("cameraIcon")
                .resizable()
                .frame(width: 40, height: 40)
                .scaledToFit()
        }
        .frame(width: 64, height: 64)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}

#Preview {
    cameraIconView()
}
