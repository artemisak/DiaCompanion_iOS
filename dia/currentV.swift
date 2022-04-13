//
//  currentV.swift
//  dia
//
//  Created by Артем  on 20.10.2021.
//

import SwiftUI

enum Vrachi: String, CaseIterable, Identifiable {
    case Anopova = "Анопова Анна Дмитриевна"
    case Bolotko = "Болотько Яна Алексеевна"
    case Dronova = "Дронова Александра Владимировна"
    case Popova = "Попова Полина Викторовна"
    case Tkachuk = "Ткачут Александра Сергеевна"
    case Vasukova = "Васюкова Елена Андреева"
    case without = ""
    
    var id: String { self.rawValue }
}

struct currentV: View {
    @Binding var pV: Bool
    @State private var selectedVrach = Vrachi.Popova
    var body: some View {
        ZStack(){
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){pV.toggle()}}
            VStack(spacing:0){
                Text("Лечащий врач")
                    .padding()
                Divider()
                VStack(){
                    Picker("", selection: $selectedVrach) {
                        Text("Анопова Анна Дмитриевна").tag(Vrachi.Anopova)
                        Text("Болотько Яна Алексеевна").tag(Vrachi.Bolotko)
                        Text("Дронова Александра Владимировна").tag(Vrachi.Dronova)
                        Text("Попова Полина Викторовна").tag(Vrachi.Popova)
                        Text("Ткачут Александра Сергеевна").tag(Vrachi.Tkachuk)
                        Text("Васюкова Елена Андреева").tag(Vrachi.Vasukova)
                        Text("Без врача").tag(Vrachi.without)
                    }.pickerStyle(.inline).labelsHidden()
                }
                Divider()
                HStack(){
                    Button(action: {
                        withAnimation {
                            pV.toggle()
                        }
                    }){
                        Text("Отменить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }.frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        addVrach(pVrach: selectedVrach.rawValue)
                        withAnimation {
                            pV.toggle()
                        }
                        UIApplication.shared.dismissedKeyboard()
                    }){
                        Text("Сохранить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }.frame(maxWidth: .infinity)
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .frame(maxWidth: 350)
        }
    }
}
