//
//  giIndicator.swift
//  dia
//
//  Created by Артём Исаков on 10.12.2022.
//

import SwiftUI

struct indicatorGroup: View {
    @Binding var gi: Double
    @Binding var carbo: Double
    @Binding var gl: Double
    var body: some View {
        HStack(spacing: 10) {
            indicator(value: $gi, label: "ГИ:", lowerBound: 20.0, upperBound: 55.0)
            indicator(value: $gl, label: "ГН:", lowerBound: 20.0, upperBound: 70.0)
            indicator(value: $carbo, label: "УГЛ:", lowerBound: 30.0, upperBound: 60.0)
        }
    }
}

struct giIndicator_Previews: PreviewProvider {
    static var previews: some View {
        indicatorGroup(gi: .constant(round(Double(8.8)*100)/100), carbo: .constant(round(Double(59.2)*100)/100), gl: .constant(round(Double(71.5)*100)/100))
    }
}
