//
//  recomendationView.swift
//  dia
//
//  Created by Артём Исаков on 02.11.2023.
//

import SwiftUI

struct recomendationView: View {
    @Binding var recomendations: [recomendation]
    @Binding var caution: Bool
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                List {
                    ForEach(recomendations, id: \.id){ rec in
                        Section {
                            Text(LocalizedStringKey(rec.text))
                        } footer: {
                            if caution && (rec == recomendations.last) {
                                Text("Точность прогноза может быть снижена. Внесите необходимые для корректной работы алгоритма данные в разделе о пациенте.").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .navigationTitle("Диетические рекомендации")
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            NavigationView {
                List {
                    ForEach(recomendations, id: \.id){ rec in
                        Section {
                            Text(LocalizedStringKey(rec.text))
                        } footer: {
                            if caution && (rec == recomendations.last) {
                                Text("Точность прогноза может быть снижена. Внесите необходимые для корректной работы алгоритма данные в разделе о пациенте.").font(.caption).frame(minWidth: 0, maxWidth: .infinity).multilineTextAlignment(.center)
                            }
                        }
                    }
                }
                .navigationTitle("Диетические рекомендации")
                .navigationBarTitleDisplayMode(.inline)
            }.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
