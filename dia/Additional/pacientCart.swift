//
//  pacientPage.swift
//  dia
//
//  Created by Артём Исаков on 20.01.2023.
//

import SwiftUI

struct pacientCart: View {
    @EnvironmentObject var routeManager: Router
    @State private var edit: Bool = true
    @ObservedObject var viewModel = pacientViewModel()
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        formatter.zeroSymbol = ""
        return formatter
    }()
    var body: some View {
        if (routeManager.isLoggedIn && routeManager.isChoosed) {
            Form {
                Section {
                    HStack {
                        Text("ФИО").font(Font.body)
                        TextField(text: $viewModel.woman.fio) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    HStack {
                        Text("Вес, кг.").font(Font.body)
                        TextField(value: $viewModel.woman.weight, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    HStack {
                        Text("Рост, см.").font(Font.body)
                        TextField(value: $viewModel.woman.height, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    DatePicker("День рождения", selection: $viewModel.woman.birthday, displayedComponents: [.date]).font(Font.body)
                    HStack {
                        Text("ID пациента").font(Font.body)
                        TextField(value: $viewModel.woman.patientID, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                } header: {
                    Text("О пациенте")
                }.disabled(edit)
                Section {
                    Picker("Врач", selection: $viewModel.woman.selectedDoc) {
                        ForEach(doc.allCases) { i in
                            Text(i.rawValue).tag(i)
                        }
                    }.pickerStyle(.menu).font(Font.body).padding(.trailing)
                    DatePicker("Начало мониторинга", selection: $viewModel.woman.start_date, displayedComponents: [.date])
                    Picker("Неделя беременности", selection: $viewModel.woman.week_of_start){
                        ForEach(1...40, id: \.self) { week in
                            Text("\(week)")
                        }
                    }
                    Picker("День недели", selection: $viewModel.woman.day_of_start){
                        ForEach(1...7, id: \.self) { day in
                            Text("\(day)")
                        }
                    }
                } header: {
                    Text("Мониторинг")
                }.disabled(edit)
            }
            .navigationTitle("Персональная карта")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        edit.toggle()
                        if edit {
                            Task {
                                await pacientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight)
                            }
                        }
                    } label: {
                        Text(edit ? "Изменить" : "Сохранить")
                    }
                })
            }
        } else {
            Form {
                Section {
                    HStack {
                        Text("ФИО").font(Font.body)
                        TextField(text: $viewModel.woman.fio) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    HStack {
                        Text("Вес, кг.").font(Font.body)
                        TextField(value: $viewModel.woman.weight, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    HStack {
                        Text("Рост, см.").font(Font.body)
                        TextField(value: $viewModel.woman.height, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                    DatePicker("День рождения", selection: $viewModel.woman.birthday, displayedComponents: [.date]).font(Font.body)
                    HStack {
                        Text("ID пациента").font(Font.body)
                        TextField(value: $viewModel.woman.patientID, formatter: formatter) {EmptyView()}.multilineTextAlignment(.trailing).padding(.trailing)
                    }
                } header: {
                    Text("О пациенте")
                }
                Section {
                    Picker("Врач", selection: $viewModel.woman.selectedDoc) {
                        ForEach(doc.allCases) { i in
                            Text(i.rawValue).tag(i)
                        }
                    }.pickerStyle(.menu).font(Font.body).padding(.trailing)
                    DatePicker("Начало мониторинга", selection: $viewModel.woman.start_date, displayedComponents: [.date])
                    Picker("Неделя беременности", selection: $viewModel.woman.week_of_start) {
                        ForEach(1...40, id: \.self) { week in
                            Text("\(week)")
                        }
                    }
                    Picker("День недели", selection: $viewModel.woman.day_of_start){
                        ForEach(1...7, id: \.self) { day in
                            Text("\(day)")
                        }
                    }
                } header: {
                    Text("Мониторинг")
                }
            }
            .navigationTitle("Персональная карта")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                            Task {
                                await pacientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight)
                                await routeManager.setChoosed()
                            }
                            routeManager.animateTransition = true
                    } label: {
                        Text("Завершить")
                    }
                })
            }
        }
    }
}

struct pacientPage_Previews: PreviewProvider {
    static var previews: some View {
        pacientCart()
    }
}
