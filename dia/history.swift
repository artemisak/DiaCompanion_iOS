//
//  history.swift
//  dia
//
//  Created by Артем  on 31.08.2021.
//

import SwiftUI

struct history: View {
    @State private var multiSelection = Set<UUID>()
    struct Food: Identifiable, Hashable {
        let name: String
        let id = UUID()
    }
    @State private var FoodN = [Food(name: "Пиво"),
                        Food(name: "Рыба"),
                        Food(name: "Колбаса"),
                        Food(name: "Сыр"),
                        Food(name: "Виноград"),
                        Food(name: "Овощи"),
                        Food(name: "Фрукты")
    ]
    var body: some View {
        List() {
            ForEach(FoodN, id: \.id){
                Text("\($0.name)")
            }.onDelete(perform: removeRows)
             .onMove(perform: move)
        }
        .navigationTitle("История записей")
        .toolbar {
            EditButton()
                .environment(\.locale, Locale.init(identifier: "ru"))
        }
    }
    func move(from source: IndexSet, to destination: Int) {
            FoodN.move(fromOffsets: source, toOffset: destination)
        }
    func removeRows(at offsets: IndexSet){
        FoodN.remove(atOffsets: offsets)
    }
}

struct history_Previews: PreviewProvider {
    static var previews: some View {
        history()
    }
}
