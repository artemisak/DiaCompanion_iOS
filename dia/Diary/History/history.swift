import SwiftUI

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
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    @State private var fillterDefault = fillterBy.all
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
    @State private var foodItems: [foodToSave] = []
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
    @State private var bool1Sugar : Int = 0
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
                NavigationLink(isActive: $redirectToEnterFood, destination: {enterFood(enabled: enabled, sugar: sugar, date: date, foodItems: foodItems, ftpreviewIndex: ftpreviewIndex, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
                NavigationLink(isActive: $redirectToEnterAct, destination: {enterAct(t: actTime, date: actDate, actpreviewIndex: actPreviewIndex, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
                NavigationLink(isActive: $redirectToEnterInject, destination: {inject(t: tInject, date: dateInject, previewIndex: previewIndexInject, previewIndex1: previewIndexInject1, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
                NavigationLink(isActive: $redirectToEnterSugar, destination: {sugarChange(t: tSugar, date: dateSugar, isAct: isActSugar, bool1: bool1Sugar, spreviewIndex: spreviewIndexSugar, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
                NavigationLink(isActive: $redirectToEnterKetonur, destination: {ketonur(t: tKetonur, date: dateKetonur, idForDelete: idFordelete, hasChanged: $hasChanged, txtTheme: $txtTheme)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
                NavigationLink(isActive: $redirectToEnterMassa, destination: {massa(t: tMassa, date: dateMassa, idForDelete: idFordelete, hasChanged: $hasChanged, txtTheme: $txtTheme)}, label: {EmptyView()}).buttonStyle(TransparentButton()).isHidden(true)
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
                ForEach(hList.fillterList, id: \.id){ i in
                    doRow(first: i.name, second: i.date, third: i.metaInfo, typeOfRow: i.type)
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                removeRows(at: IndexSet(integer: hList.histList.firstIndex(of: i)!))
                            } label: {
                                Image(systemName: "trash.fill")
                            }
                            .tint(.red)
                        })
                        .swipeActions(edge: .trailing, allowsFullSwipe: true, content: {
                            Button {
                                if i.type == 0 {
                                    idFordelete = []
                                    for j in i.bdID {
                                        idFordelete.append(j)
                                    }
                                    date = convertToDate(d: i.date)
                                    foodItems = []
                                    for (j, k) in zip(i.metaInfo, i.metaInfo.indices) {
                                        foodItems.append(foodToSave(name: j[0]+"////"+j[1]+"////"+"\(i.tbID[k])"))
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
                                    redirectToEnterFood = true
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
                                    redirectToEnterAct = true
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
                                    redirectToEnterInject = true
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
                                    bool1Sugar = try! convertToInt(txt: i.metaInfo[0][2])
                                    redirectToEnterSugar = true
                                }
                                else if i.type == 4 {
                                    idFordelete = []
                                    for j in i.bdID {
                                        idFordelete.append(j)
                                    }
                                    tKetonur = i.metaInfo[0][0]
                                    dateKetonur = convertToDate(d: i.date)
                                    redirectToEnterKetonur = true
                                }
                                else if i.type == 5 {
                                    idFordelete = []
                                    for j in i.bdID {
                                        idFordelete.append(j)
                                    }
                                    tMassa = i.metaInfo[0][0]
                                    dateMassa = convertToDate(d: i.date)
                                    redirectToEnterMassa = true
                                }
                            } label: {
                                Image(systemName: "pencil")
                            }
                            .tint(.orange)
                        })
                }
            }
            .lineLimit(2)
            .listStyle(.grouped)
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
        .navigationTitle("История записей")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing, content: {
                NavigationLink {
                    fillterPicker(listOfValues: $deselected).navigationBarTitleDisplayMode(.inline)
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
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 240/255, green: 254/255, blue: 237/255))
        }
        else if (typeOfRow == 1 && deselected[3].selected) {
            NavigationLink(destination: doActInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 249/255, green: 252/255, blue: 209/255))
        }
        else if (typeOfRow == 2 && deselected[1].selected) {
            NavigationLink(destination: doInjectInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 238/255, green: 249/255, blue: 253/255))
        }
        else if (typeOfRow == 3 && deselected[0].selected) {
            NavigationLink(destination: doInjectSugarPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 254/255, green: 242/255, blue: 246/255))
        }
        else if (typeOfRow == 4 && deselected[4].selected) {
            NavigationLink(destination: doKetonurInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            })
        }
        else if (typeOfRow == 5 && deselected[5].selected) {
            NavigationLink(destination: doMassaInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
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
                Text("Дополнительная информация").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время приема").font(.system(size: 15.5))
            }
            Section {
                ForEach(info, id: \.self){
                    Text("\($0[0])")
                }
            } header: {
                Text("Список блюд").font(.system(size: 15.5))
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
                Text("Длительность, мин.").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время начала").font(.system(size: 15.5))
            }
            Section {
                Text(info[0][0])
            } header: {
                Text("Тип нагрузки").font(.system(size: 15.5))
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
                Text("Кол-во ед.").font(.system(size: 15.5))
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Прием пищи").font(.system(size: 15.5))
            }
            Section {
                Text(info[0][2])
            } header: {
                Text("Тип действия").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.system(size: 15.5))
            }
        }.navigationTitle("Введение инсулина")
    }
    
    @ViewBuilder
    func doInjectSugarPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Уровень сахара в крови ммоль/л").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время").font(.system(size: 15.5))
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Период").font(.system(size: 15.5))
            }
        }.navigationTitle("Измерение сахара")
    }
    
    @ViewBuilder
    func doKetonurInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Общая информация").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.system(size: 15.5))
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
                Text("Общая информация").font(.system(size: 15.5))
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения").font(.system(size: 15.5))
            }
        }
        .navigationTitle("Измерение массы тела")
    }
    
    func removeRows(at offsets: IndexSet) {
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
            res.append("УСК до приема пищи: " + info.last![8])
            res.append("Прогнозируемый УСК после: " + info.last![9])
        }
        return res
    }
}
