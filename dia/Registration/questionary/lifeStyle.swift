//
//  lifeStyle.swift
//  PickerTest
//
//  Created by Артём Исаков on 05.08.2023.
//

import SwiftUI

enum diabet: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum gluTol: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum hypertension: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum smokeBeforeSixMonth: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum smokeBeforeKnow: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

enum smokeInProcces: String, CaseIterable, Identifiable {
    case yes = "Да"
    case no = "Нет"
    var id: Self { self }
}

struct lifeStyle: View {
    @State private var nextField: Bool = false
    @State private var selectedDiabet: diabet = diabet.no
    @State private var selectedGluTol: gluTol = gluTol.no
    @State private var selectedHypertensionBefore: hypertension = hypertension.no
    @State private var selectedHypertensionAfter: hypertension = hypertension.no
    @State private var selectedSmoke0: smokeBeforeSixMonth = smokeBeforeSixMonth.no
    @State private var selectedSmoke1: smokeBeforeKnow = smokeBeforeKnow.no
    @State private var selectedSmoke2: smokeInProcces = smokeInProcces.no
    var body: some View {
        Form {
            Section {
                Picker("Диабет у родственников", selection: $selectedDiabet) {
                    ForEach(diabet.allCases){ i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Нарушение толерантности к глюкозе до беременности", selection: $selectedGluTol) {
                    ForEach(gluTol.allCases){ i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Гестационный диабет").font(.body)
            }
            Section {
                Picker("До беременности", selection: $selectedHypertensionBefore) {
                    ForEach(hypertension.allCases){i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Во время беременности", selection: $selectedHypertensionAfter) {
                    ForEach(hypertension.allCases){i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Гипертоническая болезнь").font(.body)
            }
            Section {
                Picker("За 6 месяцев до беременности", selection: $selectedSmoke0) {
                    ForEach(smokeBeforeSixMonth.allCases){ i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("До того, как узнали о беременности", selection: $selectedSmoke1) {
                    ForEach(smokeBeforeKnow.allCases){ i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Во время беременности", selection: $selectedSmoke2) {
                    ForEach(smokeInProcces.allCases){ i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Курение").font(.body)
            }
        }
        .navigationTitle("Здоровье")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    NavigationLink(isActive: $nextField, destination: {foodPreferences()}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                    Button {
                        Task {
                            await questionaryManager.provider.saveLifeStyle(family_diabetes: selectedDiabet.rawValue, impaired_glucose_tolerance: selectedGluTol.rawValue, hypertension_before: selectedHypertensionBefore.rawValue, hypertension_after: selectedHypertensionAfter.rawValue, smoking_before6month: selectedSmoke0.rawValue, smoking_before_known: selectedSmoke1.rawValue, smoking_after: selectedSmoke2.rawValue)
                            nextField = true
                        }
                    } label: {
                        Text("Далее")
                    }
                }
            }
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
