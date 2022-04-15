//
//  regHelper.swift
//  dia
//
//  Created by Артём Исаков on 05.04.2022.
//

import SwiftUI

struct regHelper: View {
    @Binding var phelper: Bool
    var body: some View {
        VStack(spacing:0){
            Text("Помощь")
                .padding()
            Divider()
            ScrollView{
            VStack(){
                Text("Для получения логина и пароля обратитесь в Национальный медицинский исследовательский центр имени В.А.Алмазова. Обратите внимание, что приложение находится в бета-тесте, некоторые функции могут быть недоступны или работать некорректно. Сейчас в бета-тесте принимает участие исключительно медицинский персонал центра.").fixedSize(horizontal: false, vertical: true)
            }
            }.padding()
            Divider()
            Button(action: {
                withAnimation {
                    phelper.toggle()
                }
            }){
                Text("OK")
            }
            .buttonStyle(TransparentButton())
        }
        .background(Color.white.cornerRadius(10))
        .frame(maxWidth: 350, maxHeight: 450)
    }
}
