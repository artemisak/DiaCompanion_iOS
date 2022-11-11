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
        GeometryReader {g in
            ScrollView{
                HStack{
                    Text("Выберите цель").font(.title).bold().foregroundColor(.white)
                        .padding()
                    Spacer()
                    Image("fitness_man")
                        .resizable()
                        .frame(width: 75.0, height: 75.0)
                        .padding()
                }
                .background(Color(red: 255/255, green: 91/255, blue: 36/255).shadow(color: Color.black.opacity(0.3), radius: 1, y: 1))
                .padding(.top, g.size.height*0.05)
                .padding(.bottom, g.size.height*0.085)
                VStack{
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
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
