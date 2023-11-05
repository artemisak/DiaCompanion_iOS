//
//  recomendationView.swift
//  dia
//
//  Created by Артём Исаков on 02.11.2023.
//

import SwiftUI

struct recomendationView: View {
    @Binding var recomendations: [recomendation]
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List(recomendations, id: \.id) { rec in
                    Section {
                        Text("\(rec.text)")
                    }
                }
                .navigationTitle("Диетические рекомендации")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            NavigationView {
                List(recomendations, id: \.id) { rec in
                    Section {
                        Text("\(rec.text)")
                    }
                }
                .navigationTitle("Диетические рекомендации")
                .navigationBarTitleDisplayMode(.inline)
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
