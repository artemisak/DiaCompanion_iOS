//
//  weekS.swift
//  dia
//
//  Created by Артем  on 21.10.2021.
//

import SwiftUI

struct weekS: View {
    @Binding var bWeek: Bool
    @State private var selectedW = 20
    @State private var selectedD = 4

    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bWeek.toggle()}}
            VStack(spacing:0){
                Text("Неделя беременности на начало исследования")
                    .multilineTextAlignment(.center)
                .padding()
                Divider()
                HStack(){
                    VStack{
                        Text("Неделя")
                        Picker("Неделя",selection: $selectedW){
                            ForEach(1...40, id: \.self){
                                Text("\($0)")
                            }.labelsHidden()
                        }
                        .frame(width: 100)
                        .compositingGroup()
                        .clipped()
                        .pickerStyle(.wheel)
                    }
                    VStack{
                        Text("День")
                        Picker("День",selection: $selectedD){
                            ForEach(1...7, id: \.self){
                                Text("\($0)")
                            }.labelsHidden()
                        }
                        .frame(width: 100)
                        .compositingGroup()
                        .clipped()
                        .pickerStyle(.wheel)
                    }
                }
                
                .padding()
                Divider()
                HStack(){
                    Button(action: {
                        addWeekDay(week: selectedW, day: selectedD)
                        bWeek.toggle()
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }
                    .frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {bWeek.toggle()}){
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
