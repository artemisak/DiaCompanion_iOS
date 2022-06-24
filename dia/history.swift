import SwiftUI

struct history: View {
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    @State private var redirectToEnterFood: Bool = false
    @State private var date : Date = Date()
    @State private var foodItems: [String] = []
    @State private var idFordelete: [Int] = []
    @State private var ftpreviewIndex: ftype = ftype.zavtrak
    @State private var hasChanged: Bool = false
    var body: some View {
        NavigationLink(isActive: $redirectToEnterFood, destination: {enterFood(date: date, foodItems: foodItems, ftpreviewIndex: ftpreviewIndex, idForDelete: idFordelete, txtTheme: $txtTheme, hasChanged: $hasChanged)}, label: {EmptyView()}).isHidden(true)
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
                                date = convertToDate(d: i.date)
                                foodItems = []
                                for j in i.metaInfo {
                                    foodItems.append(j[0]+"////"+j[1])
                                }
                                idFordelete = []
                                for j in i.bdID {
                                    idFordelete.append(j)
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
            NavigationLink(destination: doInfoPage(info: third, date: convertToStrDate(d:second), titleName: first), label: {
                HStack {
                    Text(first)
                    Spacer()
                    Text(convertToStrDate(d:second))
                }
            }).listRowBackground(Color(red: 240/255, green: 254/255, blue: 237/255))
        }
    }
    
    @ViewBuilder
    func doInfoPage(info: [[String]], date: String, titleName: String) -> some View {
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
    
    func convertToStrDate(d:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter1.string(from: dateFormatter.date(from: d.substring(toIndex: 19))!)
    }
    
    func convertToDate(d: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter.date(from: d.substring(toIndex: 19))!
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
    
    func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach {i in
            hList.updateDB(table: hList.histList[i].type, elements: hList.histList[i].bdID)
        }
        hList.histList.remove(atOffsets: offsets)
    }
    
}
