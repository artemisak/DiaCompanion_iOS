//
//  addSreenView.swift
//  dia
//
//  Created by Артем  on 06.11.2021.
//

import SwiftUI

struct addSreenView: View {
    @Binding var addScreen: Bool
    @Binding var txt: String
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){addScreen.toggle()}}
            VStack(spacing:0){
                Text("Добавить блюдо / продукт")
                    .padding()
                Divider()
                VStack(){
                    TextField("Вес, в граммах", text: $txt)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
//                        addName(pName: txt)
                        txt = ""
                        addScreen.toggle()
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        txt = ""
                        addScreen.toggle()
                    }){
                        Text("Отменить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .frame(maxWidth: 350)
        }
    }
}
