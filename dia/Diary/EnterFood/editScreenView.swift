//
//  editeSreenView.swift
//  dia
//
//  Created by Артём Исаков on 31.08.2022.
//

import SwiftUI

struct editScreenView: View {
    @State private var gram = ""
    @Binding var id: Int
    @Binding var foodItems: [foodToSave]
    @Binding var showEditView: Bool
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                Text("Добавить блюдо/продукт")
                    .padding()
                Divider()
                VStack(){
                    TextField("Вес, в граммах", text: $gram)
                        .focused($focusedField)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .keyboardType(.numberPad)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }
                .padding()
                Divider()
                HStack(){
                    Button(action: {
                        showEditView = false
                    }){
                        Text("Назад")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        let arg = "\(foodItems[id].name)".components(separatedBy: "////")
                        foodItems[id].name = arg[0] + "////" + "\(gram)" + "////" + "\(arg[2])"
                        showEditView = false
                    }, label: {
                        Text("Изменить")
                    })
                    .buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .task {
            gram = ""
            focusedField = true
        }
    }
}
