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
            }
        }
        .navigationTitle("Продукты питания")
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .animation(.none, value: isSearching)
        .task {
            collection.resetConfigurationValues()
            collection.listOfFood = []
            collection.listOfPinnedFood = []
        }
    }
}

struct searchingGroup_Previews: PreviewProvider {
    static var previews: some View {
        searchViewsGroup()
    }
}
