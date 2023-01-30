//
//  giIndicator.swift
//  dia
//
//  Created by Артём Исаков on 10.12.2022.
//

import SwiftUI

struct giIndicator: View {
    @State var gi: Double
    @State var gl: Double
    var body: some View {
        HStack {
             VStack{
                Text("ГИ")
                Text(String(format: "%.1f", gi))
            }
            Divider()
            VStack{
                Text("ГН")
                Text(String(format: "%.1f", gl))
            }
        }
        .padding(5)
        .background(RoundedRectangle(cornerRadius: 7).stroke(getColor(_gi: gi)))
        .foregroundColor(getColor(_gi: gi))
        .frame(height: 44)
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
        giIndicator(gi: round(Double(800.4)*100)/100, gl: round(Double(710.5)*100)/100)
    }
}
