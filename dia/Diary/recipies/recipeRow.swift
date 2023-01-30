//
//  recipeRow.swift
//  dia
//
//  Created by Артём Исаков on 21.01.2023.
//

import SwiftUI

struct recipeRow: View {
    @Environment(\.editMode) private var editing
    @State var name: String
    @State var table_id: Int
    @State var item: [recipe]
    var body: some View {
        List {
            ForEach(item, id: \.id){i in
                Text("\(i.item), \(i.gram.formatted(.number)) г.")
            }
        }
        .navigationTitle(name)
    }
}

struct recipeRow_Previews: PreviewProvider {
    static var previews: some View {
        recipeRow(name: "Суп-пюре", table_id: 14, item: [recipe(item: "Картофель", table_id: 490, gram: 150), recipe(item: "Грибы", table_id: 134, gram: 45)])
    }
}
