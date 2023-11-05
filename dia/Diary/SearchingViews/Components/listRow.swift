//
//  listRow.swift
//  listing
//
//  Created by Артём Исаков on 03.01.2023.
//

import SwiftUI

struct listRow: View {
    @EnvironmentObject var collection: foodCollections
    @State var food_name: String
    @State var food_prot: Double
    @State var food_fat: Double
    @State var food_carbo: Double
    @State var food_kkal: Double
    @State var food_gi: Double
    @Binding var index: Int?
    var body: some View {
        HStack(alignment: .center, spacing: 0) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 0) {
                    VStack {
                        Image("prot")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(String(format: "%.1f", food_prot))
                            .bold()
                    }
                    .frame(maxWidth: 57, alignment: .center)
                    VStack {
                        Image("fat")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(String(format: "%.1f", food_fat))
                            .bold()
                    }
                    .frame(maxWidth: 57, alignment: .center)
                    VStack {
                        Image("carbo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(String(format: "%.1f", food_carbo))
                            .bold()
                    }
                    .frame(maxWidth: 57, alignment: .center)
                    VStack {
                        Image("kkal")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(String(format: "%.1f", food_kkal))
                            .bold()
                    }
                    .frame(maxWidth: 57, alignment: .center)
                    VStack {
                        Image("gi")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                        Text(String(format: "%.1f", food_gi))
                            .bold()
                    }
                    .frame(maxWidth: 57, alignment: .center)
                }
                Text(food_name)
                    .multilineTextAlignment(.leading)
            }.padding(.horizontal)
            Image(systemName: "pin").rotationEffect(.degrees(45)).foregroundColor(.blue).padding(.horizontal).opacity(index!.intToBool ? 1 : 0)
        }.padding(.vertical, 8)
    }
}

struct listRow_Previews: PreviewProvider {
    static var previews: some View {
        listRow(food_name: "Картофель рафинированный, вырезка сердцевины", food_prot: Double.random(in: 100...150), food_fat: Double.random(in: 100...150), food_carbo: Double.random(in: 100...150), food_kkal: Double.random(in: 100...150), food_gi: Double.random(in: 100...120), index: .constant(1))
    }
}
