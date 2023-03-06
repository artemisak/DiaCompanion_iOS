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
        HStack(spacing: 0) {
            Text(label)
                .font(.body)
                .bold()
            Text(String(format: "%.0f", value))
                .font(.body)
                .bold()
                .padding(.horizontal, 5)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 7).stroke(bgColor, lineWidth: 1.5))
        .foregroundColor(bgColor)
    }
}

struct indicator_Previews: PreviewProvider {
    static var previews: some View {
        indicator(value: .constant(15.0), label: "ГИ: ", lowerBound: 20.0, upperBound: 70.0)
    }
}
