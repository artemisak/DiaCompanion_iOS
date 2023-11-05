//
//  catList.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import SwiftUI

struct listOfGroups: View {
    @EnvironmentObject var collection: foodCollections
    var body: some View {
        if #available(iOS 16, *){
            List {
                Section {
                    ForEach(collection.listOfGroups, id: \.id) {element in
                        NavigationLink(destination: {
                            inGroupList(category: element.category)
                                .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
                        }, label: {
                            Text(LocalizedStringKey(element.category))
                        })
                    }
                } header: {
                    Text("Категории продуктов").font(.body)
                }
            }
        } else {
            List {
                Section {
                    ForEach(collection.listOfGroups, id: \.id) {element in
                        NavigationLink(destination: {
                            inGroupList(category: element.category)
                                .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
                                .onSubmit(of: .search){
                                    Task {
                                        await collection.assetList()
                                    }
                                }
                        }, label: {
                            Text(LocalizedStringKey(element.category))
                        })
                    }
                } header: {
                    Text("Категории продуктов").font(.body)
                }
            }
        }
    }
}
