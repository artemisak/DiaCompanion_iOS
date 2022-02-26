//
//  ModalView.swift
//  dia
//
//  Created by Артем  on 19.08.2021.
//

import SwiftUI

struct ModalView: View {
    @State var phelper : Bool = true
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: Text("О пациенте")){
                        NavigationLink(destination: ketonur()) {
                            Button("Добавить запись о кетонурии", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: massa()) {
                            Button("Добавить измерение массы тела", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: pacient()) {
                            Button("Данные пациента", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: poldny()) {
                            Button("Отметить полные дни", action: {})
                        }.foregroundColor(.black)
                        Button("Обучение", action: {
                        }).foregroundColor(.black)
                        Button("Помощь", action: {
                            phelper = false
                        })
                        .foregroundColor(.black)
                    }
                }
                if !phelper {
                    helper(phelper: $phelper)
                        .ignoresSafeArea()
                }
            }
            .navigationTitle("Дополнительно")
        }
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}


