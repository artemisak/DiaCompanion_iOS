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
        searchViewsGroup()
            .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
            .onReceive(collection.$textToSearch, perform: {_ in
                collection.fillList()
            })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        enterPoint()
    }
}
