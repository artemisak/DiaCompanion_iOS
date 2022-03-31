//
//  fio.swift
//  dia
//
//  Created by Артем  on 21.10.2021.
//

import SwiftUI

struct fio: View {
    @Binding var pFio: Bool
    @Binding var txt: String
    
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){pFio.toggle()}}
            VStack(spacing:0){
                Text("ФИО пациента")
                    .padding()
                Divider()
                VStack(){
                    TextField("Фамилия Имя Отчество", text: $txt)
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
                        addName(pName: txt)
                        txt = ""
                        withAnimation {
                            pFio.toggle()
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
                            pFio.toggle()
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
