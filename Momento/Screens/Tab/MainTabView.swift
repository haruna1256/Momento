//
//  MainTabView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct MainTabView: View {
    // 選択中のView
    @State private var selectedTab: TabItem = .home
    var body: some View {
        VStack(spacing: 0) {
            headerView(selectedTab: $selectedTab)
            selectedTab
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            footerView(selectedTab: $selectedTab)
        }
        .background(Color("bgBodyColor"))

    }
}

#Preview {
    MainTabView()
}
