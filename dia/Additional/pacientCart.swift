//
//  pacientPage.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import SwiftUI

struct pacientCart: View {
    @State private var pFio: Bool = false
    @State private var pV: Bool = false
    @State private var pDate: Bool = false
    @State private var bStart: Bool = false
    @State private var bWeek: Bool = false
    @State private var bid: Bool = false
    @State private var bWeight: Bool = false
    @State private var bHeight: Bool = false
    @State private var txt: String = ""
    @State private var vDate = Date()
    @EnvironmentObject var routeManager: Router
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Данные пациента").font(.caption)){
                    Button(action: {withAnimation(.default){pFio.toggle()}}) {
                        Text("ФИО")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){pDate.toggle()}}) {
                        Text("Дата рождения")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){pV.toggle()}}) {
                        Text("Лечащий врач")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bStart.toggle()}}) {
                        Text("Дата начала ведения дневника")
                    }.foregroundColor(.black)
                    if routeManager.version != 3 && routeManager.version != 4 {
                        Button(action: {withAnimation(.default){bWeek.toggle()}}) {
                            Text("Неделя берем. на начало исследования")
                        }.foregroundColor(.black)
                    }
                    Button(action: {withAnimation(.default){bid.toggle()}}) {
                        Text("Индивидуальный номер пациента")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bWeight.toggle()}}) {
                        if routeManager.version != 3 && routeManager.version != 4 {
                            Text("Вес до беременности, кг")
                        } else {
                            Text("Вес, кг")
                        }
                    }.foregroundColor(.black)
                    Button(action: {withAnimation(.default){bHeight.toggle()}}) {
                        if routeManager.version != 3 && routeManager.version != 4 {
                            Text("Рост до беременности, см")
                        } else {
                            Text("Рост, см")
                        }
                    }.foregroundColor(.black)
                }
            }
            .ignoresSafeArea(.keyboard)
            .listStyle(.insetGrouped)
            if bWeek {
                weekS(bWeek: $bWeek)
            }
            if pV {
                currentV(pV:$pV)
            }
            if pFio {
                fio(pFio: $pFio, txt: $txt)
            }
            if pDate {
                bday(pDate: $pDate, vDate: $vDate)
            }
            if bStart {
                dStart(bStart: $bStart, vDate: $vDate)
            }
            if bid {
                pid(bid: $bid, txt: $txt)
            }
            if bWeight {
                pWeight(bWeight: $bWeight, txt: $txt)
            }
            if bHeight {
                pHeight(bHeight: $bHeight, txt: $txt)
            }
        }
        .navigationBarTitle("Персональная карта")
        .toolbar {
            ToolbarItemGroup(placement: .keyboard, content: {
                Spacer()
                Button(action: {
                    UIApplication.shared.dismissedKeyboard()
                }, label: {
                    Text("Готово")
                })
            })
        }
    }
}

struct pacientPage_Previews: PreviewProvider {
    static var previews: some View {
        pacientCart()
    }
}
