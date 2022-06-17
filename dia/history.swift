import SwiftUI

struct history: View {
    @Binding var txtTheme: DynamicTypeSize
    @StateObject private var hList = historyList()
    var body: some View {
        List() {
            ForEach(hList.histList, id: \.id){
                Text("\($0.name)")
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
    
}
