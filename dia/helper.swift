//
//  helper.swift
//  dia
//
//  Created by Артём Исаков on 26.02.2022.
//

import SwiftUI

struct helper: View {
    @Binding var phelper: Bool
    var body: some View {
//        ZStack {
//            Color(.black)
//                .opacity(0.3)
//                .ignoresSafeArea()
//                .onTapGesture{
//                    withAnimation{
//                        phelper.toggle()
//                    }
//                }
            VStack(spacing:0){
                Text("Помощь")
                    .padding()
                Divider()
                ScrollView{
                    VStack(){
                        Text("DiaCompanion GDM v. 1.0 \nПо вопросам работы с приложением - обращайтесь по адресу электронной почты: \namedi.ioakim@gmail.com \nИспользуя данное приложение вы соглашаетесь с тем, что ваши персональные данные будут храниться на вашем устройстве в виде закрытой базы данных и XLS-таблиц. Передача ваших данных осуществляется только в виде лично отправляемых вами лечащему врачу электронных писем. Ни при каких условиях ни в каких иных формах ваши данные не будут переданы третьим лицам.")
                            .fixedSize(horizontal: false, vertical: true)
                }
                }.padding()
                Divider()
                Button(action: {
                    withAnimation {
                        phelper.toggle()
                    }
                }){
                    Text("OK")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .frame(maxWidth: 350, maxHeight: 450)
//        }
    }
}
