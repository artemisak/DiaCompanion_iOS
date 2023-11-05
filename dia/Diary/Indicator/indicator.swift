//
//  indicator.swift
//  dia
//
//  Created by Артём Исаков on 22.02.2023.
//

import SwiftUI

struct indicator: View, BypassIndicator {
    @Binding var value: Double
    var label: String
    var lowerBound: Double
    var upperBound: Double
    var bgColor: Color {
        if value >= upperBound {
            return Color("indicatorDanger")
        }
        else if value < upperBound && value > lowerBound {
            return Color("indicatorCaution")
        }
        else {
            return Color("indicatorSafe")
        }
    }
    var body: some View {
        HStack(spacing: 5) {
            Text(label)
                .font(.body)
                .bold()
            Text(String(format: "%.0f", value))
                .font(.body)
                .bold()
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 7).stroke(bgColor, lineWidth: 1.5))
        .foregroundColor(bgColor)
    }
}
