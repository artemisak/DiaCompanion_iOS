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
    var gdm12: Bool {
        return ((routeManager.version == 1) || (routeManager.version == 2))
    }
    var permitted: Bool {
        (routeManager.isLoggedIn && routeManager.isChoosed)
    }
    var body: some View {
        if permitted {
            Form {
                Group {
                    Section {
                        TextField("Полное имя", text: $viewModel.woman.fio)
                        DatePicker("Дата рождения", selection: $viewModel.woman.birthday, displayedComponents: [.date]).font(Font.body)
                    } header: {
                        Text("Общая информация").font(.body)
                    }
                }.disabled(edit)
                Group {
                    Section {
                        HStack {
                            TextField("62.5", value: $viewModel.woman.weight, formatter: formatter).keyboardType(.decimalPad)
                            Spacer()
                            bage(txt: "кг.")
                        }
                    } header: {
                        if gdm12 {
                            Text("Вес до беременности").font(.body) + Text(" *").font(.body).bold()
                        } else {
                            Text("Вес").font(.body)
                        }
                    }
                    Section {
                        HStack {
                            TextField("175", value: $viewModel.woman.height, formatter: formatter).keyboardType(.decimalPad)
                            Spacer()
                            bage(txt: "см.")
                        }
                    } header: {
                        if gdm12 {
                            Text("Рост").font(.body) + Text(" *").font(.body).bold()
                        } else {
                            Text("Рост").font(.body)
                        }
                    }
                    if gdm12 {
                        Section {
                            HStack {
                                TextField("4.8", value: $viewModel.woman.hemoglobin, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                Spacer()
                                bage(txt: "%")
                            }
                        } header: {
                            Text("Уровень гликированного гемоглобина").font(.body) + Text(" *").font(.body).bold()
                        }
                        Section {
                            HStack {
                                TextField("1.3", value: $viewModel.woman.triglic, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                Spacer()
                                bage(txt: "ммоль/л")
                            }
                        } header: {
                            Text("Уровень триглицеридов").font(.body) + Text(" *").font(.body).bold()
                        }
                        Section {
                            HStack {
                                TextField("4.5", value: $viewModel.woman.hl, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                Spacer()
                                bage(txt: "ммоль/л")
                            }
                        } header: {
                            Text("Уровень холестерина").font(.body) + Text(" *").font(.body).bold()
                        }
                        Section {
                            HStack {
                                TextField("4.3", value: $viewModel.woman.fbg, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                Spacer()
                                bage(txt: "ммоль/л")
                            }
                        } header: {
                            Text("Уровень глюкозы натощак").font(.body) + Text(" *").font(.body).bold()
                        }
                        Section {
                            HStack {
                                TextField("20", value: $viewModel.woman.preg_week, formatter: formatter)
                                    .keyboardType(.decimalPad)
                                Spacer()
                                bage(txt: "неделя")
                            }
                        } header: {
                            Text("Срок на момент сдачи анализов").font(.body) + Text(" *").font(.body).bold()
                        }
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
                        if gdm12 {
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
                    } footer: {
                        if gdm12 {
                            Text("Поля, отмеченные (*), необходимы для работы системы прогнозирования уровня глюкозы в крови").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                        }
                    }
                }.disabled(edit)
            }
            .navigationTitle("О пациенте")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        edit.toggle()
                        if edit {
                            Task {
                                await patientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight, hb: viewModel.woman.hemoglobin, tg: viewModel.woman.triglic, hl: viewModel.woman.hl, glu: viewModel.woman.fbg, pgw: viewModel.woman.preg_week)
                            }
                        }
                    } label: {
                        Text(edit ? "Изменить" : "Сохранить")
                    }
                })
                ToolbarItemGroup(placement: .keyboard, content: {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                    })
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
                }
                Group {
                    Section {
                        HStack {
                            TextField("62.5", value: $viewModel.woman.weight, formatter: formatter).keyboardType(.decimalPad)
                            Spacer()
                            bage(txt: "кг.")
                        }
                    } header: {
                        if gdm12 {
                            Text("Вес до беременности").font(.body) + Text(" *").font(.body).bold()
                        } else {
                            Text("Вес").font(.body)
                        }
                    }
                    Section {
                        HStack {
                            TextField("175", value: $viewModel.woman.height, formatter: formatter).keyboardType(.decimalPad)
                            Spacer()
                            bage(txt: "см.")
                        }
                    } header: {
                        if gdm12 {
                            Text("Рост").font(.body) + Text(" *").font(.body).bold()
                        } else {
                            Text("Рост").font(.body)
                        }
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
                        if gdm12 {
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
                    } footer: {
                        if gdm12 {
                            Text("Поля, отмеченные (*), необходимы для работы системы прогнозирования уровня глюкозы в крови").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                        }
                    }
                }
            }
            .navigationTitle("О пациенте")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing, content: {
                    Button {
                        Task {
                            await patientManager.provider.savePatientCart(name: viewModel.woman.fio, birthDay: viewModel.woman.birthday, doc: viewModel.woman.selectedDoc.rawValue, start_day: viewModel.woman.start_date, week: viewModel.woman.week_of_start, day: viewModel.woman.day_of_start, id: viewModel.woman.patientID, height: viewModel.woman.height, weight: viewModel.woman.weight, hb: 0.0, tg: 0.0, hl: 0.0, glu: 0.0, pgw: 0.0)
                            await routeManager.setChoosed()
                        }
                        routeManager.animateTransition = true
                    } label: {
                        Text("Завершить")
                    }
                })
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
}
