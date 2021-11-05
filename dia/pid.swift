//
//  pid.swift
//  dia
//
//  Created by Артем  on 24.10.2021.
//

import SwiftUI

struct pid: View {
    @Binding var bid: Bool
    @Binding var txt: String
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bid.toggle()}}
            VStack(spacing:0){
                Text("Индивидуальный номер пациента")
                    .padding()
                Divider()
                VStack(){
                    TextField("ID", text: $txt)
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
                        addID(id: Int(txt)!)
                        txt = ""
                        bid.toggle()
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        txt = ""
                        bid.toggle()
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
