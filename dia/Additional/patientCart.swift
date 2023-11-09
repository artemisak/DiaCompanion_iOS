import SwiftUI

struct patientCart: View {
    @EnvironmentObject var routeManager: Router
    @State private var edit: Bool = true
    @ObservedObject var viewModel = patientViewModel()
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
                Group {
                    Section {
                        TextField("Полное имя", text: $viewModel.woman.fio)
                        DatePicker("Дата рождения", selection: $viewModel.woman.birthday, displayedComponents: [.date]).font(Font.body)
                    } header: {
                        Text("Общая информация").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $viewModel.woman.weight, formatter: formatter).labelsHidden()
                            Spacer()
                            bage(txt: "кг.")
                        }
                    } header: {
                        Text("Вес до беременности").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $viewModel.woman.height, formatter: formatter).labelsHidden()
                            Spacer()
                            bage(txt: "см.")
                        }
                    } header: {
                        Text("Рост").font(.body)
                    }
                    Section {
                        TextField("", value: $viewModel.woman.patientID, formatter: formatter).labelsHidden()
                    } header: {
                        Text("ID пациента").font(.body)
                    }
                }.disabled(edit)
                Group {
                    Section {
                        Picker("Врач", selection: $viewModel.woman.selectedDoc) {
                            ForEach(doc.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }.pickerStyle(.menu).font(Font.body).padding(.trailing)
                        DatePicker("На мониторинге с", selection: $viewModel.woman.start_date, displayedComponents: [.date])
                        if (routeManager.version == 1) || (routeManager.version == 2) {
                            Picker("Неделя беременности на дату начала мониторинга", selection: $viewModel.woman.week_of_start){
                                ForEach(1...40, id: \.self) { week in
                                    Text("\(week)")
                                }
                            }
                            Picker("День недели беременности", selection: $viewModel.woman.day_of_start){
                                ForEach(1...7, id: \.self) { day in
                                    Text("\(day)")
                                }
                            }
                        }
                    } header: {
                        Text("Мониторинг").font(.body)
                    }.disabled(edit)
                }
            }
            .navigationTitle("О пациенте")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        edit.toggle()
                        if edit {
                            Task {
                                await patientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight)
                            }
                        }
                    } label: {
                        Text(edit ? "Изменить" : "Сохранить")
                    }
                })
            }
        } else {
            Form {
                Group {
                    Section {
                        TextField("Полное имя", text: $viewModel.woman.fio)
                        DatePicker("Дата рождения", selection: $viewModel.woman.birthday, displayedComponents: [.date]).font(Font.body)
                    } header: {
                        Text("Общая информация").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $viewModel.woman.weight, formatter: formatter).labelsHidden()
                            Spacer()
                            bage(txt: "кг.")
                        }
                    } header: {
                        Text("Вес до беременности").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $viewModel.woman.height, formatter: formatter).labelsHidden()
                            Spacer()
                            bage(txt: "см.")
                        }
                    } header: {
                        Text("Рост").font(.body)
                    }
                    Section {
                        TextField("", value: $viewModel.woman.patientID, formatter: formatter).labelsHidden()
                    } header: {
                        Text("ID пациента").font(.body)
                    }
                }
                Group {
                    Section {
                        Picker("Врач", selection: $viewModel.woman.selectedDoc) {
                            ForEach(doc.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }.pickerStyle(.menu).font(Font.body).padding(.trailing)
                        DatePicker("На мониторинге с", selection: $viewModel.woman.start_date, displayedComponents: [.date])
                        if (routeManager.version == 1) || (routeManager.version == 2) {
                            Picker("Неделя беременности на дату начала мониторинга", selection: $viewModel.woman.week_of_start){
                                ForEach(1...40, id: \.self) { week in
                                    Text("\(week)")
                                }
                            }
                            Picker("День недели беременности", selection: $viewModel.woman.day_of_start){
                                ForEach(1...7, id: \.self) { day in
                                    Text("\(day)")
                                }
                            }
                        }
                    } header: {
                        Text("Мониторинг").font(.body)
                    }
                }
            }
            .navigationTitle("О пациенте")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                            Task {
                                await patientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight)
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
