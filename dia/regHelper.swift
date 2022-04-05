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
        ZStack {
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{
                    withAnimation{
                        phelper.toggle()
                    }
                    
                }
            VStack(spacing:0){
                Text("Помощь")
                    .padding()
                Divider()
                VStack(){
                    Text("Для получения логина и пароля обратитесь в Национальный медицинский исследовательский центр имени В.А.Алмазова. Обратите внимание, что приложение находится в бета-тесте, некоторые функции могут быть недоступны или работать некорректно. Сейчас в бета-тесте принимает участие исключительно медицинский персонал центра.")
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
            .frame(maxWidth: 350)
        }
    }
}
