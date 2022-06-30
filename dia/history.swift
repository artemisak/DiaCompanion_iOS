import SwiftUI

struct history: View {
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    @State private var redirectToEnterFood: Bool = false
    @State private var redirectToEnterAct: Bool = false
    @State private var redirectToEnterInject: Bool = false
    @State private var redirectToEnterSugar: Bool = false
    @State private var redirectToEnterKetonur: Bool = false
    @State private var redirectToEnterMassa: Bool = false
    @State private var date : Date = Date()
    @State private var foodItems: [String] = []
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
    var body: some View {
        NavigationLink(isActive: $redirectToEnterFood, destination: {enterFood(date: date, foodItems: foodItems, ftpreviewIndex: ftpreviewIndex, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).isHidden(true)
        NavigationLink(isActive: $redirectToEnterAct, destination: {enterAct(t: actTime, date: actDate, actpreviewIndex: actPreviewIndex, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).isHidden(true)
        NavigationLink(isActive: $redirectToEnterInject, destination: {inject(t: tInject, date: dateInject, previewIndex: previewIndexInject, previewIndex1: previewIndexInject1, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).isHidden(true)
        NavigationLink(isActive: $redirectToEnterSugar, destination: {sugarChange(t: tSugar, date: dateSugar, isAct: isActSugar, bool1: bool1Sugar, spreviewIndex: spreviewIndexSugar, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).isHidden(true)
        NavigationLink(isActive: $redirectToEnterKetonur, destination: {ketonur(t: tKetonur, date: dateKetonur, idForDelete: idFordelete, hasChanged: $hasChanged, txtTheme: $txtTheme)}, label: {EmptyView()}).isHidden(true)
        NavigationLink(isActive: $redirectToEnterMassa, destination: {massa(t: tMassa, date: dateMassa, idForDelete: idFordelete, hasChanged: $hasChanged, txtTheme: $txtTheme)}, label: {EmptyView()}).isHidden(true)
        List {
            ForEach(hList.histList, id: \.id){ i in
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
                                for j in i.metaInfo {
                                    foodItems.append(j[0]+"////"+j[1])
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
                                tKetonur = i.metaInfo[0][0]
                                dateKetonur = convertToDate(d: i.date)
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
        .listStyle(.plain)
        .task {
            if hList.histList.isEmpty {
                await hList.FillHistoryList()
            }
            if hasChanged {
                hList.histList.removeAll()
                await hList.FillHistoryList()
                hasChanged = false
            }
        }
        .navigationTitle("История записей")
    }
    
    @ViewBuilder
    func doRow(first: String, second: String, third: [[String]], typeOfRow: Int) -> some View {
        if typeOfRow == 0 {
            NavigationLink(destination: doFoodInfoPage(info: third, date: second, titleName: first), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 240/255, green: 254/255, blue: 237/255))
        }
        else if typeOfRow == 1 {
            NavigationLink(destination: doActInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 249/255, green: 252/255, blue: 209/255))
        }
        else if typeOfRow == 2 {
            NavigationLink(destination: doInjectInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 238/255, green: 249/255, blue: 253/255))
        }
        else if typeOfRow == 3 {
            NavigationLink(destination: doInjectSugarPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            }).listRowBackground(Color(red: 254/255, green: 242/255, blue: 246/255))
        }
        else if typeOfRow == 4 {
            NavigationLink(destination: doKetonurInfoPage(info: third, date: second), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(second)
                }
            })
        }
        else if typeOfRow == 5 {
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
                Text("Дополнительная информация")
            }
            Section {
                Text(date)
            } header: {
                Text("Время приема")
            }
            Section {
                ForEach(info, id: \.self){
                    Text("\($0[0])")
                }
            } header: {
                Text("Список блюд")
            }
        }
        .navigationTitle(titleName)
    }
    
    @ViewBuilder
    func doActInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][1])
            } header: {
                Text("Длительность, мин.")
            }
            Section {
                Text(date)
            } header: {
                Text("Время начала")
            }
            Section {
                Text(info[0][0])
            } header: {
                Text("Тип нагрузки")
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
                Text("Кол-во ед.")
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Прием пищи")
            }
            Section {
                Text(info[0][2])
            } header: {
                Text("Тип действия")
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения")
            }
        }.navigationTitle("Введение инсулина")
    }
    
    @ViewBuilder
    func doInjectSugarPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Уровень сахара в кроми ммоль/л")
            }
            Section {
                Text(date)
            } header: {
                Text("Период")
            }
            Section {
                Text(info[0][1])
            } header: {
                Text("Период")
            }
        }.navigationTitle("Измерение сахара")
    }
    
    @ViewBuilder
    func doKetonurInfoPage(info: [[String]], date: String) -> some View {
        List {
            Section {
                Text(info[0][0])
            } header: {
                Text("Общая информация")
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения")
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
                Text("Общая информация")
            }
            Section {
                Text(date)
            } header: {
                Text("Время измерения")
            }
        }
        .navigationTitle("Измерение массы тела")
    }
    
    func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach {i in
            deleteFromBD(idToDelete: hList.histList[i].bdID, table: hList.histList[i].type)
        }
        hList.histList.remove(atOffsets: offsets)
    }
    
    func convertToDate(d: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter.date(from: d)!
    }
    
    func calcSum(info: [[String]]) -> [String] {
        var calc: [String] = ["0", "0", "0", "0", "0", "0"]
        for i in 0...info.count-1 {
            calc[0] = String(round(Double(calc[0])!) + round(Double(info[i][1])!))
            calc[1] = String(round(Double(calc[1])!) + round(Double(info[i][2])!))
            calc[2] = String(round(Double(calc[2])!) + round(Double(info[i][3])!))
            calc[3] = String(round(Double(calc[3])!) + round(Double(info[i][4])!))
            calc[4] = String(round(Double(calc[4])!) + round(Double(info[i][5])!))
            calc[5] = String(round(Double(calc[5])!) + round(Double(info[i][6])!))
        }
        calc[0] = "Масса: "+calc[0]
        calc[1] = "Белки: "+calc[1]
        calc[2] = "Жиры: "+calc[2]
        calc[3] = "Углводы: "+calc[3]
        calc[4] = "ККал: "+calc[4]
        calc[5] = "ГИ: "+calc[5]
        return calc
    }
    
}
