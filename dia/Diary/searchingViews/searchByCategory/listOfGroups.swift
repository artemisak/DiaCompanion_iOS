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
        List(collection.listOfGroups, id: \.id) {element in
            NavigationLink(destination: {
                inGroupList(category: element.category)
                    .searchable(text: $collection.textToSearch, placement: .navigationBarDrawer(displayMode: .always))
            }, label: {
                Text(element.category)
            })
        }
        .task {
            collection.retrieveCat()
        }
    }
}

struct listOfGroups_Previews: PreviewProvider {
    static var previews: some View {
        listOfGroups()
    }
}
