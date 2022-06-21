import SwiftUI

struct history: View {
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    var body: some View {
        List {
            ForEach(hList.histList, id: \.id){
                doRow(first: $0.name, second: $0.date, third: $0.metaInfo)
            }.onDelete(perform: removeRows)
                .onMove(perform: move)
        }
        .lineLimit(2)
        .listStyle(.plain)
        .task {
            if hList.histList.isEmpty {
                await hList.FillHistoryList()
            }
        }
        .navigationTitle("История записей")
        .toolbar {
            EditButton().dynamicTypeSize(txtTheme)
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        hList.histList.move(fromOffsets: source, toOffset: destination)
    }
    
    func removeRows(at offsets: IndexSet) {
        offsets.sorted(by: > ).forEach {i in
            hList.updateDB(element: hList.histList[i].name)
        }
        hList.histList.remove(atOffsets: offsets)
    }
    
    func doRow(first: String, second: String, third: [[String]]) -> some View {
        NavigationLink(destination: doInfoPage(info: third, date: convertToStrDate(d:second)), label: {
            HStack {
                Text(first)
                Spacer()
                Text(convertToStrDate(d:second))
            }
        })
    }
    
    func convertToStrDate(d:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter1.string(from: dateFormatter.date(from: d.substring(toIndex: 19))!)
    }
    
    func doInfoPage(info: [[String]], date: String) -> some View {
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
            }
            Section {
                ForEach(info, id: \.self){
                    Text("\($0[0])")
                }
            } header: {
                Text("Список блюд")
            }
        }
        .navigationTitle("Прием пищи")
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
