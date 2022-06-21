import SwiftUI

struct history: View {
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    var body: some View {
        List() {
            ForEach(hList.histList, id: \.id){
                doRow(first: $0.name, second: $0.date)
            }.onDelete(perform: removeRows)
                .onMove(perform: move)
        }
        .lineLimit(2)
        .listStyle(.plain)
        .task {
            await hList.FillHistoryList()
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
    func doRow(first: String, second: String) -> some View {
        HStack {
            Text(first)
            Spacer()
            Text(convertToDate(d:second))
        }
    }
    func convertToDate(d:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "HH:mm dd.MM.yyyy"
        return dateFormatter1.string(from: dateFormatter.date(from: d.substring(toIndex: 19))!)
    }
}
