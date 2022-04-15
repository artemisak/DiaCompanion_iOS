//
//  pacient.swift
//  dia
//
//  Created by Артем  on 12.09.2021.
//
import Foundation
import SwiftUI

struct pacient: View {
    @State private var pFio: Bool = true
    @State private var pV: Bool = true
    @State private var pDate: Bool = true
    @State private var bStart: Bool = true
    @State private var bWeek: Bool = true
    @State private var bid: Bool = true
    @State private var bWeight: Bool = true
    @State private var bHeight: Bool = true
    @State private var vDate = Date()
    @State private var txt: String = ""
    var body: some View {
        ZStack{
            List{
                Section(header: Text("Данные пациента")){
                    Button(action: {withAnimation{pFio.toggle()}}) {
                        Text("ФИО пациента")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{pDate.toggle()}}) {
                        Text("Дата рождения пациента")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{pV.toggle()}}) {
                        Text("Лечащий врач")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{bStart.toggle()}}) {
                        Text("Дата начала ведения дневника")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{bWeek.toggle()}}) {
                        Text("Неделя берем. на начало исследования")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{bid.toggle()}}) {
                        Text("Индивидуальный номер пациента")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{bWeight.toggle()}}) {
                        Text("Вес до беременности, кг")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{bHeight.toggle()}}) {
                        Text("Рост до беременности, см")
                    }.foregroundColor(.black)
                }
            }
            if !pFio {
                fio(pFio: $pFio, txt: $txt)
            }
            if !pDate {
                bday(pDate: $pDate, vDate: $vDate)
            }
            if !pV {
                currentV(pV:$pV)
            }
            if !bStart {
                dStart(bStart: $bStart, vDate: $vDate)
            }
            if !bWeek {
                weekS(bWeek: $bWeek)
            }
            if !bid {
                pid(bid: $bid, txt: $txt)
            }
            if !bWeight {
                pWeight(bWeight: $bWeight, txt: $txt)
            }
            if !bHeight {
                pHeight(bHeight: $bHeight, txt: $txt)
            }
        }
        .navigationBarTitle("Персональная карта")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                    })
                }
            })
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct pacient_Previews: PreviewProvider {
    static var previews: some View {
        pacient()
    }
}

