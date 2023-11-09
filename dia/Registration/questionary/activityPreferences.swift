//
//  activityPreferences.swift
//  PickerTest
//
//  Created by Артём Исаков on 07.08.2023.
//

import SwiftUI

enum walking: String, CaseIterable, Identifiable {
    case under30 = "< 30 минут"
    case between30and60 = "30-60 минут"
    case above60 = "> 60 минут"
    var id: Self { self }
}

enum stepping: String, CaseIterable, Identifiable {
    case under4 = "< 4 пролетов"
    case between4to16 = "4-16 пролетов"
    case above16 = "> 16 пролетов"
    var id: Self { self }
}

enum sport: String, CaseIterable, Identifiable {
    case under2 = "< 2 раз"
    case between2to3 = "2-3 раза"
    case above3 = "> 3 раз"
    var id: Self { self }
}

struct activityPreferences: View {
    @State private var nextField: Bool = false
    @State private var selectedWalkBefore: walking = walking.above60
    @State private var selectedWalkAfter: walking = walking.between30and60
    @State private var selectedStepBefore: stepping = stepping.between4to16
    @State private var selectedStepAfter: stepping = stepping.under4
    @State private var selectedSportBefore: sport = sport.between2to3
    @State private var selectedSportAfter: sport = sport.under2
    var body: some View {
        Form {
            Section {
                Picker("До беременности", selection: $selectedWalkBefore) {
                    ForEach(walking.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Во время беременности", selection: $selectedWalkAfter) {
                    ForEach(walking.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Легкая ходьба, в день").font(.body)
            }
            Section {
                Picker("До беременности", selection: $selectedStepBefore) {
                    ForEach(stepping.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Во время беременности", selection: $selectedStepAfter) {
                    ForEach(stepping.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Степпинг, в день").font(.body)
            }
            Section {
                Picker("До беременности", selection: $selectedSportBefore) {
                    ForEach(sport.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
                Picker("Во время беременности", selection: $selectedSportAfter) {
                    ForEach(sport.allCases) {i in
                        Text(LocalizedStringKey(i.rawValue)).tag(i)
                    }
                }
            } header: {
                Text("Спорт, в неделю").font(.body)
            }
        }
        .navigationTitle("Нагрузка")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ZStack {
                    NavigationLink(isActive: $nextField, destination: {patientCart()}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                    Button {
                        Task {
                            await questionaryManager.provider.saveActivityPrefrences(walkBefore: selectedWalkBefore.rawValue, walkAfter: selectedWalkAfter.rawValue, stepBefore: selectedStepBefore.rawValue, stepAfter: selectedStepAfter.rawValue, sportBefore: selectedSportBefore.rawValue, sportAfter: selectedSportAfter.rawValue)
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
