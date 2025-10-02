//
//  footerView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct footerView: View {
    // 選択状態を保持する
    @State private var selectedTab: TabItem = .home
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.self) { tab in
                    Button(action: {
                        // 選択要素に合わせて画面遷移を行う
                        selectedTab = tab
                    }) {
                        // アイコン、タイトルの表示
                        VStack {
                            (selectedTab == tab ? tab.selectedImage : tab.unselectedImage)
                                .resizable()
                                .frame(width: 36, height: 36)
                            Text(tab.title)
                                .font(.caption)
                                .foregroundColor(selectedTab == tab ? Color("onColor") : Color("offColor"))
                        }
                        .padding(.all, 8)
                        .frame(maxWidth: .infinity)
                    }
                }
        }
        .frame(height: 60)
        .padding(.horizontal, 8)
        .background(Color("bgColor"))
    }
}

#Preview {
    footerView()
}
