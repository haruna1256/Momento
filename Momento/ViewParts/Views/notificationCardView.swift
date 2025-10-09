//
//  notificationCardView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/07.
//

import SwiftUI

struct notificationCardView: View {
    // 表示内容
    let category: String = "運営"
    let date: String = "2025/10/06"
    let title: String = "運営からのお知らせ"

    var body: some View {
        VStack(spacing: 0) {
            // 通知内容
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Text(category)
                        .foregroundColor(Color("textColor"))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .overlay(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Color("textColor"), lineWidth: 2)
                        )
                    Text(date)
                        .foregroundColor(.gray)
                        .font(.caption)
                    Spacer()
                }
                Text(title)
                    .font(.body)
                    .padding(.leading, 38)
                    .foregroundColor(Color("textColor"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .padding(.horizontal)
            Rectangle()
                .frame(maxWidth: .infinity)
                .frame(height: 3)
                .foregroundColor(Color("accentTextColor"))
                .padding(.horizontal)
        }
        .background(Color("bgBodyColor"))
    }
}

#Preview {
    notificationCardView()
}
