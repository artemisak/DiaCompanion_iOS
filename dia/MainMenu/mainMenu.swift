//
//  mainMenu.swift
//  dia
//
//  Created by Артём Исаков on 18.01.2023.
//

import SwiftUI

struct mainMenu: View {
    @Environment(\.presentationMode) private var presentationMode
    @EnvironmentObject var routeManager: Router
    @StateObject var consumption = dayConsumptionModel()
    @State private var localDate: Date = Date()
    @State private var localDateSTR: String = ""
    @State private var email: [String] = [""]
    @State private var erMessage: String = ""
    @State private var emailErrorMessage: Bool = false
    var body: some View {
        List {
            Section {
                consumptionIndicator(food_prot: $consumption.prot, food_fat: $consumption.fat, food_carbo: $consumption.carbo, food_kkal: $consumption.kkal, nowDate: $localDateSTR)
            } header: {
                HStack {
                    HStack(spacing:0) {
                        Text("Сегодня")
                        Text(" - \(localDate.formatted())")
                    }
                    Image(systemName: consumption.sunImage.rawValue)
                }.font(.body)
            }
            Section {
                NavigationLink {
                    if #available(iOS 16, *){
                        enterFood(sugar: "", date: localDate, ftpreviewIndex: ftype.zavtrak, dateForDelete: nil, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                    } else {
                        enterFood(sugar: "", date: localDate, ftpreviewIndex: ftype.zavtrak, dateForDelete: nil, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                    }
                } label: {
                    HStack {
                        Image("meal").resizable().scaledToFit().frame(width: 36, height: 36)
                        Text("Приемы пищи")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                if routeManager.version != 4 {
                    NavigationLink {
                        if #available(iOS 16, *){
                            sugarChange(t: "", date: localDate, isAct:  false, spreviewIndex: .natoshak, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                        }
                        else {
                            sugarChange(t: "", date: localDate, isAct:  false, spreviewIndex: .natoshak, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                        }
                    } label: {
                        HStack {
                            Image("sugar_level").resizable().scaledToFit().frame(width: 36, height: 36)
                            Text("Измерение глюкозы")
                        }
                        .foregroundColor(Color("listButtonColor"))
                    }
                    NavigationLink {
                        if #available(iOS 16, *){
                            inject(t: "", date: localDate, previewIndex: injectType.ultra, previewIndex1: injects.natoshak, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                        } else {
                            inject(t: "", date: localDate, previewIndex: injectType.ultra, previewIndex1: injects.natoshak, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                        }
                    } label: {
                        HStack {
                            Image("insulin").resizable().scaledToFit().frame(width: 36, height: 36)
                            Text("Введение инсулина")
                        }
                        .foregroundColor(Color("listButtonColor"))
                    }
                }
                NavigationLink {
                    if #available(iOS 16, *){
                        enterAct(t: "", date: localDate, actpreviewIndex: act.zar, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                    } else {
                        enterAct(t: "", date: localDate, actpreviewIndex: act.zar, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                    }
                } label: {
                    HStack {
                        Image("workoutSleep").resizable().scaledToFit().frame(width: 36, height: 36)
                        Text("Физическая активность")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    if #available(iOS 16, *){
                        massa(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                    } else {
                        massa(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                    }
                } label: {
                    HStack {
                        Image("weight").resizable().scaledToFit().frame(width: 36, height: 36)
                        Text("Измерение веса")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    if #available(iOS 16, *){
                        ketonur(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false)).toolbar(.hidden, for: .tabBar)
                    } else {
                        ketonur(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false)).hiddenTabBar()
                    }
                } label: {
                    HStack {
                        Image("keton").resizable().scaledToFit().frame(width: 36, height: 36)
                        Text("Уровень кетонурии")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
            } header: {
                Text("Разделы дневника").font(.body)
            }
        }
        .task {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            localDate = Date.now
            localDateSTR = dateFormatter.string(from: localDate)
            await consumption.setUpVidget()
            
        }
        .navigationTitle("ДиаКомпаньон")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink {
                    if #available(iOS 16, *){
                        history()
                            .toolbar(.hidden, for: .tabBar)
                    } else {
                        history()
                            .hiddenTabBar()
                    }
                } label: {
                    HStack {
                        Image(systemName: "tray.2")
                        Text("История")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing, content: {
                Menu {
                    Button {
                        Task.detached {
                            await showShareSheet()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "square.and.arrow.up")
                            Text("Поделиться")
                        }
                    }
                    Button {
                        Task.detached {
                            await sendEmail()
                        }
                    } label: {
                        HStack{
                            Image(systemName: "envelope")
                            Text("Отправить врачу")
                        }
                    }
                } label: {
                    Image(systemName: "arrowshape.turn.up.backward")
                }
            })
        }
        .alert("Статус операции", isPresented: $emailErrorMessage, actions: {Button(role: .cancel, action: {}, label: {Text(LocalizedStringKey("OK"))})}, message: {Text(LocalizedStringKey(erMessage))})
    }
    
    func showShareSheet() async {
        let content = exportTable.sheets.generate(version: routeManager.version)
        let AV = UIActivityViewController(activityItems: [content], applicationActivities: nil)
        UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
    }
    
    func sendEmail() async {
        email = try! findAdress()
        if email != [""] {
            do {
                let statBlock = diaryStatblock()
                statBlock.checkDiary()
                let content = try Data(contentsOf: exportTable.sheets.generate(version: routeManager.version) as URL)
                try emailSender.shared.sendEmail(subject: statBlock.formMailSubject(version: routeManager.version), body: statBlock.formMailBoodyMessage(version: routeManager.version), to: email, xlsxFile: content)
            } catch {
                emailErrorMessage = true
                erMessage = "На устройстве не установлен почтовый клиент"
            }
        } else {
            emailErrorMessage = true
            erMessage = "Перейдите в раздел о пациенте во  вкладке Дополительно, чтобы назначить лечащего врача. В противном случае используйте вариант сохранить на устройстве."
        }
    }
}
