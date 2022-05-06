import Foundation
import SwiftUI

struct pacient: View {
    @Binding var pFio: Bool
    @Binding var pV: Bool
    @Binding var pDate: Bool
    @Binding var bStart: Bool
    @Binding var bWeek: Bool
    @Binding var bid: Bool
    @Binding var bWeight: Bool
    @Binding var bHeight: Bool
    var body: some View {
        List{
            Section(header: Text("Данные пациента").font(.system(size: 15.5))){
                Button(action: {withAnimation{pFio.toggle()}}) {
                    Text("ФИО")
                }.foregroundColor(.black)
                Button(action: {withAnimation{pDate.toggle()}}) {
                    Text("Дата рождения")
                }.foregroundColor(.black)
//                Button(action: {withAnimation{pV.toggle()}}) {
//                    Text("Лечащий врач")
//                }.foregroundColor(.black)
                Button(action: {withAnimation{bStart.toggle()}}) {
                    Text("Дата начала ведения дневника")
                }.foregroundColor(.black)
                Button(action: {withAnimation{bWeek.toggle()}}) {
                    Text("Неделя берем. на начало исследования")
                }.foregroundColor(.black)
//                Button(action: {withAnimation{bid.toggle()}}) {
//                    Text("Индивидуальный номер пациента")
//                }.foregroundColor(.black)
                Button(action: {withAnimation{bWeight.toggle()}}) {
                    Text("Вес до беременности, кг")
                }.foregroundColor(.black)
                Button(action: {withAnimation{bHeight.toggle()}}) {
                    Text("Рост до беременности, см")
                }.foregroundColor(.black)
            }
        }
        .listStyle(.insetGrouped)
        .navigationBarTitle("Персональная карта")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
    }
}
