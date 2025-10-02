//
//  headerView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

// ヘッダーのUI設計
struct headerView: View {
    var body: some View {
        HStack {
            Image("logo")
                .frame(width: 100, height: 42)
            Image("icon")
                .frame(width: 38, height: 38)
        }
        .frame(height: 60)
        .padding()
        .background(Color.black)

    }
}

#Preview {
    headerView()
}
