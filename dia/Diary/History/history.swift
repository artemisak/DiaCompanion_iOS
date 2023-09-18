import SwiftUI
import Algorithms

struct deselectRow: Identifiable, Hashable {
    var id = UUID()
    var name: String
    var selected = true
}

struct fillterPicker: View {
    @Binding var listOfValues : [deselectRow]
    var body: some View {
        List(listOfValues) {i in
            Button {
                listOfValues[listOfValues.firstIndex(where: {$0.id == i.id})!].selected = listOfValues[listOfValues.firstIndex(where: {$0.id == i.id})!].selected ? false : true
            } label: {
                HStack{
                    Text(i.name)
                    Spacer()
                    if i.selected {
                        Image(systemName: "checkmark").foregroundColor(.blue)
                    }
                }
            }
        }
        .listStyle(.plain)
    }
}

struct history: View {
    enum fillterBy: String, CaseIterable, Identifiable {
        case day = "День"
        case week = "Неделя"
        case all = "Все записи"
        var id : Self { self }
    }
    @StateObject private var hList = historyList()
    @EnvironmentObject var collection: foodCollections
    @State private var fillterDefault = fillterBy.week
    @State public var deselected = [deselectRow(name: "Измерение сахара"), deselectRow(name: "Иньекции инсулина"), deselectRow(name: "Прием пищи"), deselectRow(name: "Физическая нагрузка"), deselectRow(name: "Уровень кетонов в моче"), deselectRow(name: "Измерение массы тела")]
    @State private var redirectToEnterFood: Bool = false
    @State private var redirectToEnterAct: Bool = false
    @State private var redirectToEnterInject: Bool = false
    @State private var redirectToEnterSugar: Bool = false
    @State private var redirectToEnterKetonur: Bool = false
    @State private var redirectToEnterMassa: Bool = false
    @State private var sugar: String = ""
    @State private var enabled: Bool = false
    @State private var date : Date = Date()
    @State private var idFordelete: [Int] = []
    @State private var ftpreviewIndex: ftype = ftype.zavtrak
    @State private var actTime: String = ""
    @State private var actDate: Date = Date()
    @State private var actPreviewIndex: act = act.zar
    @State private var tInject : String = ""
    @State private var dateInject : Date = Date()
    @State private var previewIndexInject : injectType = .ultra
    @State private var previewIndexInject1 : injects = .natoshak
    @State private var tSugar : String = ""
    @State private var dateSugar : Date = Date()
    @State private var isActSugar : Bool = false
    @State private var spreviewIndexSugar : selectedvar = selectedvar.natoshak
    @State private var hasChanged: Bool = false
    @State private var tKetonur: String = ""
    @State private var dateKetonur: Date = Date()
    @State private var tMassa: String = ""
    @State private var dateMassa: Date = Date()
    @State private var recommendMessage: String = ""
    @State private var isVisible: Bool = false
    @State private var isLoad: Bool = true
    var body: some View {
        VStack(spacing: .zero) {
            VStack(spacing: .zero){
                NavigationLink(isActive: $redirectToEnterFood, destination: {enterFood(enabled: enabled, sugar: sugar, date: date, ftpreviewIndex: ftpreviewIndex, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                NavigationLink(isActive: $redirectToEnterAct, destination: {enterAct(t: actTime, date: actDate, actpreviewIndex: actPreviewIndex, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                NavigationLink(isActive: $redirectToEnterInject, destination: {inject(t: tInject, date: dateInject, previewIndex: previewIndexInject, previewIndex1: previewIndexInject1, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                NavigationLink(isActive: $redirectToEnterSugar, destination: {sugarChange(t: tSugar, date: dateSugar, isAct: isActSugar, spreviewIndex: spreviewIndexSugar, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                NavigationLink(isActive: $redirectToEnterKetonur, destination: {ketonur(t: tKetonur, date: dateKetonur, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
                NavigationLink(isActive: $redirectToEnterMassa, destination: {massa(t: tMassa, date: dateMassa, idForDelete: idFordelete, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).hidden()
            }
            Picker("Фильтр", selection: $fillterDefault, content: {
                Text("День").tag(fillterBy.day)
                Text("Неделя").tag(fillterBy.week)
                Text("Все записи").tag(fillterBy.all)
            })
            .onChange(of: fillterDefault, perform: {i in
                let df = DateFormatter()
                let calendar = Calendar.current
                df.dateFormat = "HH:mm dd.MM.yyyy"
                let now = Date.now
                let weekAgo = now.addingTimeInterval(-60*60*24*7)
                switch i {
                case .day:
                    hList.fillterList = hList.histList.filter({calendar.dateComponents([.day, .month, .year], from: df.date(from: $0.date)!) == calendar.dateComponents([.day, .month, .year], from: now)})
                case .week:
                    hList.fillterList = hList.histList.filter({df.date(from: $0.date)! >= weekAgo})
                case .all:
                    hList.fillterList = hList.histList
                }
            })
            .labelsHidden()
            .pickerStyle(.segmented)
            .padding()
            List {
                ForEach(Array(hList.fillterList.map({$0.getDate()}).uniqued()), id: \.self) {day in
                    Section {
                        ForEach(hList.fillterList.filter({$0.getDate() == day}), id: \.id){ i in
                            doRow(first: i.name, second: i.date, third: i.metaInfo, typeOfRow: i.type)
                                .swipeActions(edge: .trailing , content: {
                                    Button {
                                        removeRow(at: IndexSet(integer: hList.histList.firstIndex(of: i)!))
                                    } label: {
                                        Image(systemName: "trash.fill")
                                    }
                                    .tint(.red)
                                })
                                .swipeActions(edge: .trailing, content: {
                                    Button {
                                        if i.type == 0 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            date = convertToDate(d: i.date)
                                            collection.editedFoodItems = []
                                            for (j, k) in zip(i.metaInfo, i.metaInfo.indices) {
                                                collection.editedFoodItems.append(foodItem(table_id: i.tbID[k], name: j[0], prot: Double(j[2])!, fat: Double(j[3])!, carbo: Double(j[4])!*100/Double(j[1])!, kkal: Double(j[5])!, gi: Double(j[6])!, index: 0, position: Int(k), gram: Double(j[1])!)
                                                )
                                            }
                                            if i.metaInfo.last![8] != "0.0" {
                                                sugar = i.metaInfo.last![8]
                                                enabled = true
                                            } else {
                                                sugar = ""
                                                enabled = false
                                            }
                                            switch i.name.split(separator: " ")[0] {
                                            case "Завтрак":
                                                ftpreviewIndex = .zavtrak
                                            case "Обед":
                                                ftpreviewIndex = .obed
                                            case "Ужин":
                                                ftpreviewIndex = .uzin
                                            case "Перекусы":
                                                ftpreviewIndex = .perekus
                                            default:
                                                ftpreviewIndex = .zavtrak
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterFood = true
                                            })
                                        }
                                        else if i.type == 1 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            actTime = i.metaInfo[0][1]
                                            actDate = convertToDate(d: i.date)
                                            switch i.metaInfo[0][0]{
                                            case "Зарядка":
                                                actPreviewIndex = act.zar
                                            case "Сон":
                                                actPreviewIndex = act.sleep
                                            case "Ходьба":
                                                actPreviewIndex = act.hod
                                            case "Спорт":
                                                actPreviewIndex = act.sport
                                            case "Уборка в квартире":
                                                actPreviewIndex = act.uborka
                                            case "Работа в огороде":
                                                actPreviewIndex = act.rabota
                                            default:
                                                actPreviewIndex = act.zar
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterAct = true
                                            })
                                        }
                                        else if i.type == 2 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            tInject = i.metaInfo[0][0]
                                            dateInject = convertToDate(d: i.date)
                                            switch i.metaInfo[0][1] {
                                            case "Натощак":
                                                previewIndexInject1 = injects.natoshak
                                            case "Завтрак":
                                                previewIndexInject1 = injects.zavtrak
                                            case "Обед":
                                                previewIndexInject1 = injects.obed
                                            case "Ужин":
                                                previewIndexInject1 = injects.uzin
                                            case "Дополнительно":
                                                previewIndexInject1 = injects.dop
                                            default:
                                                previewIndexInject1 = injects.natoshak
                                            }
                                            switch i.metaInfo[0][2] {
                                            case "Ультракороткий":
                                                previewIndexInject = injectType.ultra
                                            case "Короткий":
                                                previewIndexInject = injectType.kor
                                            case "Пролонгированный":
                                                previewIndexInject = injectType.prolong
                                            default:
                                                previewIndexInject = injectType.ultra
                                            }
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterInject = true
                                            })
                                        }
                                        else if i.type == 3 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            tSugar = i.metaInfo[0][0]
                                            dateSugar = convertToDate(d: i.date)
                                            switch i.metaInfo[0][1] {
                                            case "Натощак":
                                                spreviewIndexSugar = .natoshak
                                            case "После завтрака":
                                                spreviewIndexSugar = .zavtrak
                                            case "После обеда":
                                                spreviewIndexSugar = .obed
                                            case "После ужина":
                                                spreviewIndexSugar = .uzin
                                            case "Дополнительно":
                                                spreviewIndexSugar = .dop
                                            case "При родах":
                                                spreviewIndexSugar = .rodi
                                            default:
                                                spreviewIndexSugar = .natoshak
                                            }
                                            isActSugar = try! convertToInt(txt: i.metaInfo[0][2]).intToBool
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterSugar = true
                                            })
                                        }
                                        else if i.type == 4 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            tKetonur = i.metaInfo[0][0]
                                            dateKetonur = convertToDate(d: i.date)
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterKetonur = true
                                            })
                                        }
                                        else if i.type == 5 {
                                            idFordelete = []
                                            for j in i.bdID {
                                                idFordelete.append(j)
                                            }
                                            tMassa = i.metaInfo[0][0]
                                            dateMassa = convertToDate(d: i.date)
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.01, execute: {
                                                redirectToEnterMassa = true
                                            })
                                        }
                                    } label: {
                                        Image(systemName: "pencil")
                                    }
                                    .tint(.orange)
                                })
                        }.listRowSeparator(.hidden)
                    } header: {
                        Text(day).font(.caption)
                    }
                }
            }
        }
        .task {
            if hList.histList.isEmpty {
                hList.FillHistoryList()
                hList.fillterList = hList.histList
            }
            if hasChanged {
                let df = DateFormatter()
                df.dateFormat = "HH:mm dd.MM.yyyy"
                let now = Date.now
                let weekAgo = now.addingTimeInterval(-60*60*24*7)
                switch fillterDefault {
                case .day:
                    hList.refillHistoryList()
                    hList.fillterList = hList.histList.filter({df.date(from: $0.date) == now})
                case .week:
                    hList.refillHistoryList()
                    hList.fillterList = hList.histList.filter({df.date(from: $0.date)! >= weekAgo})
                case .all:
                    hList.refillHistoryList()
                    hList.fillterList = hList.histList
                }
            }
        }
        .navigationTitle("История")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                NavigationLink {
                    fillterPicker(listOfValues: $deselected)
                } label: {
                    Image(systemName: "gear")
                }
            })
        }
    }
    
    @ViewBuilder
    func doRow(first: String, second: String, third: [[String]], typeOfRow: Int) -> some View {
        if (typeOfRow == 0 && deselected[2].selected) {
            NavigationLink(destination: doFoodInfoPage(info: third, date: second, titleName: first), label: {
                HStack {
                    Image("meal").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
        else if (typeOfRow == 1 && deselected[3].selected) {
            NavigationLink(destination: doActInfoPage(info: third, date: second), label: {
                HStack {
                    Image("workoutSleep").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
        else if (typeOfRow == 2 && deselected[1].selected) {
            NavigationLink(destination: doInjectInfoPage(info: third, date: second), label: {
                HStack {
                    Image("insulin").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
        else if (typeOfRow == 3 && deselected[0].selected) {
            NavigationLink(destination: doInjectSugarPage(info: third, date: second), label: {
                HStack {
                    Image("sugar_level").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
        else if (typeOfRow == 4 && deselected[4].selected) {
            NavigationLink(destination: doKetonurInfoPage(info: third, date: second), label: {
                HStack {
                    Image("keton").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
        else if (typeOfRow == 5 && deselected[5].selected) {
            NavigationLink(destination: doMassaInfoPage(info: third, date: second), label: {
                HStack {
                    Image("weight").resizable().scaledToFit().frame(width: 36, height: 36)
                    Text(first)
                    Spacer()
                    HStack(alignment: .center){
                        Text(second[0..<5])
                    }.frame(width: 75)
                }.foregroundColor(Color("listButtonColor"))
            })
        }
    }
    
    @ViewBuilder
    func doFoodInfoPage(info: [[String]], date: String, titleName: String) -> some View {
        List {
            Section {
                ForEach(calcSum(info: info), id: \.self){
                    Text("\($0)")
                }
            } header: {
                Text("Дополнительная информация").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время приема").font(.caption)
            }
            Section {
                ForEach(info, id: \.self){foodItem in
                    VStack(alignment: .leading) {
                        indicatorGroup(gi: .constant(round(Double(foodItem[6])!)), carbo: .constant(round(Double(foodItem[4])!)), gl: .constant(round(Double(foodItem[7])!)))
                        Text("\(foodItem[0])")
                    }.padding(.vertical, 7)
                }
            } header: {
                Text("Список блюд").font(.caption)
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(titleName)
    }
    
    @ViewBuilder
    func doActInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][1])
            } header: {
                Text("Длительность, мин.").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время начала").font(.caption)
            }
            Section {
                Text(info[0][0])
            } header: {
                Text("Тип нагрузки").font(.caption)
            }
        }
        .navigationTitle("Физическая активность")
    }
    
    @ViewBuilder
    func doInjectInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Кол-во ед.").font(.caption)
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Прием пищи").font(.caption)
            }
            Section {
                Text(info[0][2])
            } header: {
                Text("Тип действия").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.caption)
            }
        }.navigationTitle("Введение инсулина")
    }
    
    @ViewBuilder
    func doInjectSugarPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Уровень сахара в крови ммоль/л").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время").font(.caption)
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Период").font(.caption)
            }
        }.navigationTitle("Измерение сахара")
    }
    
    @ViewBuilder
    func doKetonurInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Общая информация").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.caption)
            }
        }
        .navigationTitle("Уровень кетонов в моче")
    }
    
    @ViewBuilder
    func doMassaInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Общая информация").font(.caption)
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.caption)
            }
        }
        .navigationTitle("Измерение массы тела")
    }
    
    func removeRow(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach {i in
            deleteAndSave(idToDelete: hList.fillterList[i].bdID, table: hList.fillterList[i].type, info: [hList.fillterList[i].date, hList.fillterList[i].name])
            hList.histList.removeAll(where: {$0.bdID == hList.fillterList[i].bdID && $0.type == hList.fillterList[i].type && $0.date == hList.fillterList[i].date && $0.name == hList.fillterList[i].name})
        }
        hList.fillterList.remove(atOffsets: offsets)
    }
    
    func convertToDate(d: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter.date(from: d)!
    }
    
    func calcSum(info: [[String]]) -> [String] {
        var calc: [Double] = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
        var res: [String] = ["","","","","","",""]
        for i in 0...info.count-1 {
            calc[0] = calc[0] + Double(info[i][1])!
            calc[1] = calc[1] + Double(info[i][2])!
            calc[2] = calc[2] + Double(info[i][3])!
            calc[3] = calc[3] + Double(info[i][4])!
            calc[4] = calc[4] + Double(info[i][5])!
            calc[5] = round((calc[5] + Double(info[i][6])!*Double(info[i][4])!)*10)/10
            calc[6] = round((calc[6] + Double(info[i][6])!*Double(info[i][4])!/100)*10)/10
        }
        res[0] = "Масса: " + "\(round(calc[0]*10)/10)"
        res[1] = "Белки: " + "\(round(calc[1]*10)/10)"
        res[2] = "Жиры: " + "\(round(calc[2]*10)/10)"
        res[3] = "Углеводы: " + "\(round(calc[3]*10)/10)"
        res[4] = "ККал: " + "\(round(calc[4]*10)/10)"
        res[5] = "ГИ: " + "\(round((calc[5]/calc[3])*10)/10)"
        res[6] = "ГН: " + "\(round(calc[6]*10)/10)"
        if info.last![8] != "0.0" && info.last![9] != "0.0" {
            res.append("УГК до приема пищи: \(info.last![8])")
            res.append("Вероятность гипергликемии: \(info.last![9])%")
        }
        return res
    }
}
