//
//  page3.swift
//  dia
//
//  Created by Артем  on 22.08.2021.
//

import SwiftUI

struct page3: View {
    @State private var selectedFlavor = Flavor.chocolate
    enum Flavor: String, CaseIterable, Identifiable {
        case chocolate
        case vanilla
        case strawberry

        var id: String { self.rawValue }
    }
    var body: some View {
        Form {
            Section {
                Picker("Flavor", selection: $selectedFlavor) {
                    Text("Chocolate").tag(Flavor.chocolate)
                    Text("Vanilla").tag(Flavor.vanilla)
                    Text("Strawberry").tag(Flavor.strawberry)
                }
                Text("Selected flavor: \(selectedFlavor.rawValue)")
            }
        }
    }
}

struct page3_Previews: PreviewProvider {
    static var previews: some View {
        page3()
    }
}
