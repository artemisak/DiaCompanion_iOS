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
                    Text("По убыванию ГИ")
                case .downGI:
                    Text("По возрастанию ГИ")
                case .relevant:
                    Text("По релевантности")
                }
                Spacer()
                Button {
                    sorting.toggle()
                } label: {
                    Image(systemName: "arrow.up.arrow.down.square").resizable().scaledToFit().frame(maxWidth: 25, maxHeight: 25)
                }
                .confirmationDialog("Порядок фильтрации", isPresented: $sorting) {
                    Button {
                        Task {
                            collection.rule = .downGI
                            await collection.assetList()
                        }
                    } label: {
                        Text("По возрастанию ГИ")
                    }
                    Button {
                        Task {
                            collection.rule = .upGI
                            await collection.assetList()
                        }
                    } label: {
                        Text("По убыванию ГИ")
                    }
                    Button {
                        Task {
                            collection.rule = .relevant
                            await collection.assetList()
                        }
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
