//
//  ContentView.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import SwiftUI

struct enterPoint: View {
    @EnvironmentObject var collection: foodCollections
    var body: some View {
        if #available(iOS 16, *){
            searchViewsGroup()
                .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
                .onReceive(collection.$textToSearch.debounce(for: .seconds(0.25), scheduler: DispatchQueue.main), perform: {_ in
                    Task {
                        await collection.assetList()
                    }
                })
        } else {
            searchViewsGroup()
                .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
                .onSubmit(of: .search){
                    Task {
                        await collection.assetList()
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        enterPoint()
    }
}
