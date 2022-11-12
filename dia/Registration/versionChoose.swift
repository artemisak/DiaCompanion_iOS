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
                HStack(spacing: 20){
                    Text("Выберите цель").font(.title2).bold().foregroundColor(Color(red: 57/255, green: 67/255, blue: 121/255))
                    Image("fitness_man")
                        .resizable()
                        .frame(width: 50.0, height: 50.0)
                }.frame(minWidth: 0, maxWidth: .infinity)
                .padding()
                .background(Capsule().fill(LinearGradient(gradient: Gradient(colors: [Color(red: 249/255, green: 215/255, blue: 222/255), Color(red: 181/255, green: 190/255, blue: 240/255)]), startPoint: .leading, endPoint: .trailing)).shadow(color: Color.black.opacity(0.3), radius: 1, y: 1))
                .padding(.top, g.size.height*0.05)
                .padding(.bottom, g.size.height*0.08)
                .padding(.horizontal)
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
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {
                HStack{
                    Text("Профилирование")
                        .foregroundColor(Color.black)
                        .font(.title3)
                        .fontWeight(.bold)
                        .fixedSize()
//                    Image("planshat")
//                        .resizable()
//                        .frame(width: 35, height: 35)
//                        .zIndex(1)
                }
            })
        }
    }
}
