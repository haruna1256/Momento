//
//  notificationCardView.swift
//  Momento
//
//  Created by 川岸遥奈 on 2025/10/07.
//

import SwiftUI

struct notificationCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 8) {
                Text("運営")
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .overlay(
                        RoundedRectangle(cornerRadius: 4)
                            .stroke(Color.cyan, lineWidth: 2)
                    )
                Text("2025/10/06")
                    .foregroundColor(.gray)
                    .font(.caption)
            }
            Text("運営からのお知らせ")
                .font(.body)
                .padding(.leading, 38)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal)

        Rectangle()
            .frame(maxWidth: .infinity)
            .frame(height: 3)
            .padding(.horizontal)
            .foregroundColor(.cyan.opacity(0.6))
    }
}

#Preview {
    notificationCardView()
}
