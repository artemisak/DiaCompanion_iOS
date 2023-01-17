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
        Text(String(format: "%.1f", gi))
            .padding(7)
            .background(RoundedRectangle(cornerSize: CGSize(width: 7, height: 7)).stroke(getColor(_gi: gi)))
            .foregroundColor(getColor(_gi: gi))
            .fixedSize(horizontal: true, vertical: false)
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
