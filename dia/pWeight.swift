//
//  pWeight.swift
//  dia
//
//  Created by Артем  on 25.10.2021.
//

import SwiftUI

struct pWeight: View {
    @Binding var bWeight: Bool
    @Binding var txt: String
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bWeight.toggle()}}
            VStack(spacing:0){
                Text("Вес до беременности, в кг")
                    .padding()
                Divider()
                VStack(){
                    TextField("кг", text: $txt)
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
                        txt = ""
                        withAnimation {
                            bWeight.toggle()
                        }
                    }){
                        Text("Отменить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        addWeight(Weight: Double(txt)!)
                        txt = ""
                        withAnimation {
                            bWeight.toggle()
                        }
                        UIApplication.shared.dismissedKeyboard()
                    }){
                        Text("Сохранить")
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
