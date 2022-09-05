//
//  foodButton.swift
//  dia
//
//  Created by Артём Исаков on 05.09.2022.
//

import SwiftUI

struct foodButton : View {
    @State var dish : FoodList
    @Binding var selectedFoodTemp : String
    @Binding var addScreen: Bool
    @Binding var successedSave: Bool
    var body: some View {
        Button(action: {
            selectedFoodTemp = dish.name
            successedSave = false
            withAnimation(.default){
                addScreen = true
            }
        }){
            VStack(alignment: .leading) {
                HStack {
                    VStack {
                        Text("Б")
                            .foregroundColor(Color.gray)
                        Text("\(dish.prot)").foregroundColor(.orange)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("Ж")
                            .foregroundColor(Color.gray)
                        Text("\(dish.fat)").foregroundColor(.green)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("У")
                            .foregroundColor(Color.gray)
                        Text("\(dish.carbo)").foregroundColor(.blue)
                    }.font(.system(size: 18.5))
                    VStack {
                        Text("ГИ")
                            .foregroundColor(Color.gray)
                        Text("\(dish.gi)").foregroundColor(.red)
                    }.font(.system(size: 18.5))
                }
                Text("\(dish.name)").frame(minWidth: 0, maxWidth: .infinity, alignment: .leading).font(.system(size: 20)).multilineTextAlignment(.leading).foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.vertical, 12.5)
            .background(dish.rating == 0 ? nil : Color.green.opacity(0.3))
        }
        .buttonStyle(ButtonAndLink())
    }
}
