//
//  giIndicator.swift
//  dia
//
//  Created by Артём Исаков on 10.12.2022.
//

import SwiftUI

struct giIndicator: View {
    @State var gi: Double
    var body: some View {
        Text(String(format: "%.1f", gi)).font(.system(size: 10))
            .padding(7)
            .background(Circle().stroke(getColor(_gi: gi)))
            .foregroundColor(getColor(_gi: gi))
    }

    func getColor(_gi: Double) -> Color {
        if _gi > 70.0 {
            return Color.red
        }
        else if _gi < 70.0 && _gi > 20.0 {
            return Color(red: 255/255, green: 91/255, blue: 36/255)
        }
        else {
            return Color.green
        }
    }
}

struct giIndicator_Previews: PreviewProvider {
    static var previews: some View {
        giIndicator(gi: round(Double(80.4)*100)/100)
    }
}
