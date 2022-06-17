import Foundation
import SwiftUI

struct pacient: View {
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
    var body: some View {
        ZStack {
            List {
                Section(header: Text("Данные пациента").font(.system(size: 15.5))){
                    Button(action: {withAnimation{pFio.toggle()}}) {
                        Text("ФИО")
                    }.foregroundColor(.black)
                    Button(action: {withAnimation{pDate.toggle()}}) {
                        Text("Дата рождения")
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
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard, content: {
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                    })
                }
            })
        }
    }
}
