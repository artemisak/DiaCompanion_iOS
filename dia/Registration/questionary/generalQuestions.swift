//
//  generalQuestions.swift
//  dia
//
//  Created by Артём Исаков on 05.08.2023.
//

import SwiftUI

enum pregNum: String, CaseIterable, Identifiable {
    case one = "1-ая"
    case two = "2-ая"
    case three = "3-я"
    case four = "4-ая"
    case five = "5-ая"
    case six = "6-ая"
    case seven = "7-ая"
    case eight = "8-ая"
    case nine = "9-ая"
    case ten = "10-ая"
    var id : Self { self }
}

enum birthCount: String, CaseIterable, Identifiable {
    case zero = "Не было"
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case ten = "10"
    var id : Self { self }
}

enum oralContr: String, CaseIterable, Identifiable {
    case no = "Нет"
    case yes = "Да"
    var id: Self { self }
}

enum prolactin: String, CaseIterable, Identifiable {
    case no = "Нет"
    case yes = "Да"
    case dontKnow = "Не знаю"
    var id: Self { self }
}

enum drags: String, CaseIterable, Identifiable {
    case nothing = "Нет"
    case bromkriptin = "Бромкриптин"
    case dostineks = "Достинекс"
    case other = "Другое"
    var id: Self { self }
}

enum vitamin_d: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum vitamin_d_dosage: String, CaseIterable, Identifiable {
    case no = "Нет"
    case underOne = "< 1 мес."
    case oneToThree = "1-3 мес."
    case aboveThree = "> 3 мес."
    var id: Self { self }
}

enum weekendAtSouth: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum solarium: String, CaseIterable, Identifiable {
    case no = "Не посещался"
    case oneTimeAtMonthOrLess = "Меньше 1 раза в мес."
    case atleastOneTimeAtMonth = "Не менее 1 раза в мес."
    var id: Self { self }
}

struct generalQuestions: View {
    @State private var nextField: Bool = false
    @State private var selectedPregNum: pregNum = pregNum.one
    @State private var selectedBirthCount: birthCount = birthCount.zero
    @State private var selectedOralContr: oralContr = oralContr.no
    @State private var selectedProlactin: prolactin = prolactin.no
    @State private var selectedHeightenedProlactin: prolactin = prolactin.no
    @State private var selectedDrags: drags = drags.nothing
    @State private var otherDrags: String = ""
    @State private var selectedVitaminD: vitamin_d = vitamin_d.no
    @State private var vitaminDragsBefore: String = ""
    @State private var selectedVitaminDosage: vitamin_d_dosage = vitamin_d_dosage.no
    @State private var vitaminDragsAfter: String = ""
    @State private var selectedWeekendAtSouth: weekendAtSouth = weekendAtSouth.no
    @State private var selectedFirstTrimester: weekendAtSouth = weekendAtSouth.no
    @State private var selectedSecondTrimester: weekendAtSouth = weekendAtSouth.no
    @State private var selectedThirdTrimester: weekendAtSouth = weekendAtSouth.no
    @State private var selectedSolarium: solarium = solarium.no
    @State private var hemoglobin = 0.0
    @State private var triglic = 0.0
    @State private var hl = 0.0
    @State private var fbg = 0.0
    @State private var preg_week = 0.0
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.zeroSymbol = ""
        return formatter
    }()
    var body: some View {
            Form {
                Group {
                    Section {
                        Picker("Беременность по счету", selection: $selectedPregNum) {
                            ForEach(pregNum.allCases) {i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        Picker("Количество родов", selection: $selectedBirthCount) {
                            ForEach(birthCount.allCases) {i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        Picker("Применение комбинированных оральных контрацептивов", selection: $selectedOralContr) {
                            ForEach(oralContr.allCases) {i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                    } header: {
                        Text("Беременность").font(.body)
                    }
                    Section {
                        Picker("Брали ли у вас пролактин", selection: $selectedProlactin) {
                            ForEach(prolactin.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        if selectedProlactin == prolactin.yes {
                            Picker("Было зафиксировано повышение", selection: $selectedHeightenedProlactin) {
                                ForEach(prolactin.allCases) { i in
                                    Text(LocalizedStringKey(i.rawValue)).tag(i)
                                }
                            }
                            Picker("Назначен препарат", selection: $selectedDrags) {
                                ForEach(drags.allCases) { i in
                                    Text(LocalizedStringKey(i.rawValue)).tag(i)
                                }
                            }
                            if selectedDrags == drags.other {
                                TextField("Перечислите препараты", text: $otherDrags)
                            }
                        }
                    } header: {
                        Text("Пролактин").font(.body)
                    }
                    Section {
                        Picker("Прием вит. D до беременности", selection: $selectedVitaminD) {
                            ForEach(vitamin_d.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        if selectedVitaminD == vitamin_d.yes {
                            TextField("Перечислите препараты", text: $vitaminDragsBefore)
                        }
                        Picker("Прием вит. D во время беременности", selection: $selectedVitaminDosage) {
                            ForEach(vitamin_d_dosage.allCases) {i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        if selectedVitaminDosage != vitamin_d_dosage.no {
                            TextField("Перечислите препараты", text: $vitaminDragsAfter)
                        }
                        Picker("Отпуск в жарких странах", selection: $selectedWeekendAtSouth) {
                            ForEach(weekendAtSouth.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                        if selectedWeekendAtSouth == weekendAtSouth.yes {
                            Picker("Первый триместр", selection: $selectedFirstTrimester){
                                ForEach(weekendAtSouth.allCases) { i in
                                    Text(LocalizedStringKey(i.rawValue)).tag(i)
                                }
                            }
                            Picker("Второй триместр", selection: $selectedSecondTrimester){
                                ForEach(weekendAtSouth.allCases) { i in
                                    Text(LocalizedStringKey(i.rawValue)).tag(i)
                                }
                            }
                            Picker("Третий триместр", selection: $selectedThirdTrimester){
                                ForEach(weekendAtSouth.allCases) { i in
                                    Text(LocalizedStringKey(i.rawValue)).tag(i)
                                }
                            }
                        }
                        Picker("Солярий", selection: $selectedSolarium){
                            ForEach(solarium.allCases) { i in
                                Text(LocalizedStringKey(i.rawValue)).tag(i)
                            }
                        }
                    } header: {
                        Text("Витамин D").font(.body)
                    }
                }
                Group {
                    Section {
                        HStack {
                            TextField("", value: $hemoglobin, formatter: formatter)
                                .keyboardType(.decimalPad)
                                .labelsHidden()
                            Spacer()
                            bage(txt: " % ")
                        }
                    } header: {
                        Text("Уровень гликированного гемоглобина").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $triglic, formatter: formatter)
                                .keyboardType(.decimalPad)
                                .labelsHidden()
                            Spacer()
                            bage(txt: "ммоль/л")
                        }
                    } header: {
                        Text("Уровень триглицеридов").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $hl, formatter: formatter)
                                .keyboardType(.decimalPad)
                                .labelsHidden()
                            Spacer()
                            bage(txt: "ммоль/л")
                        }
                    } header: {
                        Text("Уровень холестерина").font(.body)
                    }
                    Section {
                        HStack {
                            TextField("", value: $fbg, formatter: formatter)
                                .keyboardType(.decimalPad)
                                .labelsHidden()
                            Spacer()
                            bage(txt: "ммоль/л")
                        }
                    } header: {
                        Text("Уровень глюкозы натощак").font(.body)
                    }
                }
                Section {
                    HStack {
                        TextField("", value: $preg_week, formatter: formatter)
                            .keyboardType(.decimalPad)
                            .labelsHidden()
                        Spacer()
                        bage(txt: "Неделя")
                    }
                } header: {
                    Text("Срок на момент сдачи анализов").font(.body)
                }
            }
            .animation(.spring(), value: selectedProlactin)
            .animation(.spring(), value: selectedDrags)
            .animation(.spring(), value: selectedVitaminD)
            .animation(.spring(), value: selectedVitaminDosage)
            .animation(.spring(), value: selectedWeekendAtSouth)
            .autocorrectionDisabled()
            .navigationTitle("Метрики")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ZStack {
                        NavigationLink(isActive: $nextField, destination: {lifeStyle()}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                        Button {
                            Task {
                                await questionaryManager.provider.saveGeneralQuestion(pregnancy_n: selectedPregNum.rawValue, delivery_n: selectedBirthCount.rawValue, contraceptive: selectedOralContr.rawValue, prolactin_test: selectedProlactin.rawValue, heightened_prolactin: selectedHeightenedProlactin.rawValue, prolactin_drug_prescribed: selectedDrags.rawValue, prolactin_drug: otherDrags, vitamin_d_before: selectedVitaminD.rawValue, vitamin_d_before_drug: vitaminDragsBefore, vitamin_d_after: selectedVitaminDosage.rawValue, vitamin_d_after_drug: vitaminDragsAfter, weekendAtSouth: selectedWeekendAtSouth.rawValue, weekendAtSouth_firstTrimester: selectedFirstTrimester.rawValue, weekendAtSouth_secondTrimester: selectedSecondTrimester.rawValue, weekendAtSouth_thirdTrimester: selectedThirdTrimester.rawValue, solarium: selectedSolarium.rawValue, HbA1C: String(hemoglobin), triglycerides: String(triglic), cholesterol: String(hl), glucose: String(fbg), preg_week: String(preg_week))
                                nextField = true
                            }
                        } label: {
                            Text("Далее")
                        }
                    }
                }
            }
    }
}
