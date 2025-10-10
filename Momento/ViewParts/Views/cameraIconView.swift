//
//  cameraIconView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/03.
//

import SwiftUI

struct cameraIconView: View {
    let frameSize: CGFloat
    let cameraIconSize: CGFloat
    var body: some View {
        ZStack {
            Circle()
                .frame(width: frameSize, height: frameSize)
                .foregroundStyle(Color("bgColor"))

            Image("cameraIcon")
                .resizable()
                .frame(width: cameraIconSize, height: cameraIconSize)
                .scaledToFit()
        }
        .frame(width: frameSize, height: frameSize)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
    }
}
#Preview {
    cameraIconView(
        frameSize: 64,
        cameraIconSize: 40
    )
}
