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
                Button(action: {
                    islogin.setChoosed(v: 1)
                }) {
                    Text("Гестационный СД РКИ (GDM RCT)")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 2)
                }) {
                    Text("Гестационный СД (GDM)")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 3)
                }) {
                    Text("Метаболический синдром (MS)")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                Button(action: {
                    islogin.setChoosed(v: 4)
                }) {
                    Text("Синдром ПЯ (PCOS)")
                }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
            }
            .ignoresSafeArea(.keyboard)
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Конфигурация")
        .navigationBarBackButtonHidden()
    }
}
