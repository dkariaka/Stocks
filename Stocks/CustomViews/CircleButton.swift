//
//  CircleButton.swift
//  Stocks
//
//  Created by Дмитрий К on 26.06.2025.
//

import SwiftUI

struct CircleButton: View {
    let systemIconName: String
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            Image(systemName: systemIconName)
                .font(.title2)
                .foregroundColor(.blue)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color(.systemGray5))
                )
        }
    }
}

#Preview {
    CircleButton(systemIconName: "plus") {}
}
