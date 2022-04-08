//
//  dStart.swift
//  dia
//
//  Created by Артем  on 21.10.2021.
//

import SwiftUI

struct dStart: View {
    @Binding var bStart: Bool
    @Binding var vDate: Date
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){bStart.toggle()}}
            VStack(spacing: 0){
                Text("Дата начала ведения дневника")
                    .padding()
                Divider()
                VStack(){
                    DatePicker(
                        "Дата",
                        selection: $vDate,
                        displayedComponents: [.date]
                    ).environment(\.locale, Locale.init(identifier: "ru"))
                        .datePickerStyle(.wheel)
                        .labelsHidden()
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
                        vDate = Date.now
                        withAnimation {
                            bStart.toggle()
                        }
                    }){
                        Text("Отменить")
                            .frame(maxWidth: .infinity)
                            .foregroundColor(.black)
                    }.frame(maxWidth: .infinity)
                    Divider()
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "ru_RU")
                        dateFormatter.setLocalizedDateFormatFromTemplate("dd.MM.yyyy")
                        addDateS(pDate: dateFormatter.string(from: vDate))
                        vDate = Date.now
                        withAnimation {
                            bStart.toggle()
                        }
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
