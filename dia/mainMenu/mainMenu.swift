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
                    Text("Сегодня - \(localDate.formatted())")
                    Image(systemName: consumption.sunImage.rawValue)
                }.font(.caption)
            }
            Section {
                NavigationLink {
                    enterFood(enabled: false, sugar: "", date: localDate, ftpreviewIndex: ftype.zavtrak, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("meal").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Приемы пищи")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    sugarChange(t: "", date: localDate, isAct:  false, bool1: 0, spreviewIndex: .natoshak, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("sugar_level").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Измерение сахара")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    inject(t: "", date: localDate, previewIndex: injectType.ultra, previewIndex1: injects.natoshak, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("insulin").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Введение инсулина")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    enterAct(t: "", date: localDate, actpreviewIndex: act.zar, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("workout").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Физическая активность")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    massa(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("weight").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Измерение веса")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
                NavigationLink {
                    ketonur(t: "", date: localDate, idForDelete: [], hasChanged: .constant(false))
                } label: {
                    HStack {
                        Image("keton").resizable().scaledToFit().frame(width: 44, height: 44)
                        Text("Уровень кетонурии")
                    }
                    .foregroundColor(Color("listButtonColor"))
                }
            } header: {
                Text("Разделы дневника").font(.caption)
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
                    history()
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
        .alert("Статус операции", isPresented: $emailErrorMessage, actions: {Button(role: .cancel, action: {}, label: {Text("OK")})}, message: {Text(erMessage)})
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
                diaryStatblock.statBlock.checkDiary()
                let content = try Data(contentsOf: exportTable.sheets.generate(version: routeManager.version) as URL)
                try emailSender.shared.sendEmail(subject: diaryStatblock.statBlock.formMailSubject(version: routeManager.version), body: diaryStatblock.statBlock.formMailBoodyMessage(version: routeManager.version), to: email, xlsxFile: content)
            } catch {
                emailErrorMessage = true
                erMessage = "На устройстве не установлен почтовый клиент"
            }
        } else {
            emailErrorMessage = true
            erMessage = "Перейдите в карту пациента (раздел Дополительно), чтобы назначить лечащего врача. В противном случае используйте вариант сохранить на устройстве."
        }
    }
}

struct mainMenu_Previews: PreviewProvider {
    static var previews: some View {
        mainMenu()
    }
}
