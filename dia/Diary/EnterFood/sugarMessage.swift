//
//  sugarMessage.swift
//  dia
//
//  Created by Артём Исаков on 02.11.2023.
//

import SwiftUI

struct sugarMessage: View {
    @Binding var message: LocalizedStringKey
    @Binding var msgColor: Color
    @Binding var recomendations: [recomendation]
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 5) {
                VStack(spacing: 5) {
                    Text("Прогнозируемый УГК")
                        .bold()
                        .font(.title2)
                    Text(message)
                        .bold()
                        .font(.title2)
                        .foregroundColor(msgColor)
                        .underline()
                    Text("норму")
                        .bold()
                        .font(.title2)
                }
                .minimumScaleFactor(0.01)
                .scaledToFit()
                if !recomendations.isEmpty {
                    HStack {
                        Text("Посмотрите доступные рекомендаций")
                        Image(systemName: "hand.point.up.left")
                    }
                    .font(.caption)
                    .foregroundStyle(Color.accentColor)
                }
            }
            Spacer()
        }
    }
}
