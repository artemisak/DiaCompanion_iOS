//
//  pHeight.swift
//  dia
//
//  Created by Артем  on 25.10.2021.
//

import SwiftUI

struct pHeight: View {
    @Binding var bHeight: Bool
    @Binding var txt: String
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bHeight.toggle()}}
            VStack(spacing:0){
                Text("Рост до беременности, в см")
                    .padding()
                Divider()
                VStack(){
                    TextField("см", text: $txt)
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
                        addHeight(Height: Double(txt)!)
                        txt = ""
                        withAnimation {
                            bHeight.toggle()
                        }
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        txt = ""
                        withAnimation {
                            bHeight.toggle()
                        }
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
