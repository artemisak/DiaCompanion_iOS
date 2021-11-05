//
//  ex.swift
//  dia
//
//  Created by Артем  on 29.08.2021.
//

import SwiftUI

struct ex: View {
    struct Ocean: Identifiable, Hashable {
        let name: String
        let id = UUID()
    }
    private var oceans = [
        Ocean(name: ""),
        Ocean(name: ""),
        Ocean(name: ""),
        Ocean(name: ""),
        Ocean(name: "")
    ]
    @State private var multiSelection = Set<UUID>()

    var body: some View {
        List(oceans, selection: $multiSelection) {
            Text($0.name)
        }
        .navigationTitle("Oceans")
        .toolbar { EditButton() }
        .listStyle(InsetGroupedListStyle())
        Text("\(multiSelection.count) selections")
    }
}

struct ex_Previews: PreviewProvider {
    static var previews: some View {
        ex()
    }
}
