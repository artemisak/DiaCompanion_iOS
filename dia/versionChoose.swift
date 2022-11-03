//
//  versionChoose.swift
//  dia
//
//  Created by Артём Исаков on 18.09.2022.
//

import SwiftUI

struct versionChoose: View {
    @EnvironmentObject var islogin: check
    var body: some View {
        ZStack{
            VStack{
                Text("Выберите подходящий вам режим ведения дневника").font(.title3)
                Spacer()
            }
            VStack{
                Spacer()
                Button(action: {
                    islogin.setChoosed(v: 1)
                }) {
                    Text("ГСД, диета (с прогнозированием)")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 2)
                }) {
                    Text("ГСД, диета + инсулинотерапия")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 3)
                }) {
                    Text("Дневник питания и самоконтроля")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 4)
                }) {
                    Text("Дневник питания")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Spacer()
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Конфигурация")
        .navigationBarBackButtonHidden()
    }
}
