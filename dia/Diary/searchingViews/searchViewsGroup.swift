//
//  searchingGroup.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import SwiftUI

struct searchViewsGroup: View {
    @Environment(\.isSearching) private var isSearching
    @EnvironmentObject var collection: foodCollections
    var body: some View {
        VStack {
            if isSearching {
                searchByWordList()
            }
            else {
                listOfGroups()
                    .task {
                        collection.clearAllList()
                    }
            }
        }
        .navigationTitle("Продукты питания")
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(.keyboard)
        .animation(.none, value: isSearching)
        .onChange(of: isSearching, perform: {_ in
            collection.resetConfigurationValues()
        })
    }
}

struct searchingGroup_Previews: PreviewProvider {
    static var previews: some View {
        searchViewsGroup()
    }
}
