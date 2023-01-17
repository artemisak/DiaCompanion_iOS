//
//  searchListHeader.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import SwiftUI

struct listHeader: View {
    @EnvironmentObject var collection: foodCollections
    @State private var sorting: Bool = false
    var body: some View {
        if collection.showListToolbar {
            HStack {
                switch collection.rule {
                case .upGI:
                    Text("Сортировка по убыванию ГИ")
                case .downGI:
                    Text("Сортировка по возрастанию ГИ")
                case .relevant:
                    Text("Сортировка по релевантности")
                }
                Spacer()
                Button {
                    sorting.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down")
                }
                .confirmationDialog("Порядок фильтрации", isPresented: $sorting) {
                    Button {
                        collection.rule = .downGI
                        collection.fillList()
                    } label: {
                        Text("По возрастанию ГИ")
                    }
                    Button {
                        collection.rule = .upGI
                        collection.fillList()
                    } label: {
                        Text("По убыванию ГИ")
                    }
                    Button {
                        collection.rule = .relevant
                        collection.fillList()
                    } label: {
                        Text("По релевантности")
                    }
                }
            }
            .padding(.vertical, 5)
            .animation(.none, value: collection.rule)
        }
    }
}

struct searchListHeader_Previews: PreviewProvider {
    static var previews: some View {
        listHeader()
    }
}
