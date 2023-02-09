//
//  giIndicator.swift
//  dia
//
//  Created by Артём Исаков on 10.12.2022.
//

import SwiftUI

struct giIndicator: View {
    @Binding var gi: Double
    @Binding var carbo: Double
    @Binding var gl: Double
    var mainColor: Color {
        if gi >= 70.0 {
            return Color.red
        }
        else if gi < 70.0 && gi > 20.0 {
            return Color(red: 255/255, green: 91/255, blue: 36/255)
        }
        else {
            return Color.green
        }
    }
    var body: some View {
        HStack {
            Text(String(format: "%.0f", gi)).font(.body).padding(.horizontal, 7)
            Divider().overlay{mainColor}
            Text(String(format: "%.0f", carbo)).font(.body).padding(.horizontal, 7)
            Divider().overlay{mainColor}
            Text(String(format: "%.0f", gl)).font(.body).padding(.horizontal, 7)
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 7).stroke(mainColor))
        .foregroundColor(mainColor)
        .frame(height: 36, alignment: .leading)
    }
}

struct giIndicator_Previews: PreviewProvider {
    static var previews: some View {
        giIndicator(gi: .constant(round(Double(800.8)*100)/100), carbo: .constant(round(Double(800.2)*100)/100), gl: .constant(round(Double(710.5)*100)/100))
    }
}
