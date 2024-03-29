//
//  consumptionIndicator.swift
//  dia
//
//  Created by Артём Исаков on 18.01.2023.
//

import SwiftUI

struct consumptionIndicator: View {
    @Binding var food_prot: Double
    @Binding var food_fat: Double
    @Binding var food_carbo: Double
    @Binding var food_kkal: Double
    @Binding var nowDate: String
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 3) {
                VStack {
                    Image("prot")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text(String(format: "%.1f", food_prot))
                        .bold().font(.callout)
                }.frame(maxWidth: 75, alignment: .center)
                VStack {
                    Image("fat")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text(String(format: "%.1f", food_fat))
                        .bold().font(.callout)
                }.frame(maxWidth: 75, alignment: .center)
                VStack {
                    Image("carbo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text(String(format: "%.1f", food_carbo))
                        .bold().font(.callout)
                }.frame(maxWidth: 75, alignment: .center)
                VStack {
                    Image("kkal")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 25, height: 25)
                    Text(String(format: "%.1f", food_kkal))
                        .bold().font(.callout)
                }.frame(maxWidth: 75, alignment: .center)
            }
        }
    }
}

struct consumptionIndicator_Previews: PreviewProvider {
    static var previews: some View {
        consumptionIndicator(food_prot: .constant(1000.0), food_fat: .constant(800.0), food_carbo: .constant(900.0), food_kkal: .constant(2000.0), nowDate: .constant("05/01/2023"))
    }
}
