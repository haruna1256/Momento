//
//  NotificationView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/02.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        ScrollView {
                    VStack(spacing: 0) { // spacing: 0 でカード間の隙間をなくす
                        ForEach(sampleNotifications) { item in
                            Button {
                                // ボタンを押した時の処理
                            } label: {
                                notificationCardView(item: item)
                                    .padding(.top, 5)
                            }


                        }
                    }
                    .background(Color("bgBodyColor"))
                }
    }
}

#Preview {
    NotificationView()
}
