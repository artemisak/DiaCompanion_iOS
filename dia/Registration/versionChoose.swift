//
//  versionChoose.swift
//  dia
//
//  Created by Артём Исаков on 18.09.2022.
//

import SwiftUI

struct versionChoose: View {
    @EnvironmentObject var routeManager: Router
    var body: some View {
        GeometryReader {g in
            ScrollView {
                VStack {
                    Button(action: {
                        Task {
                            await routeManager.setChoosed(number: 1)
                        }
                    }) {
                        Text("ГСД, диета (с прогнозированием)")
                    }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                    Button(action: {
                        Task {
                            await routeManager.setChoosed(number: 2)
                        }
                    }) {
                        Text("ГСД, диета + инсулинотерапия")
                    }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                    Button(action: {
                        Task {
                            await routeManager.setChoosed(number: 3)
                        }
                    }) {
                        Text("Дневник питания и самоконтроля")
                    }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                    Button(action: {
                        Task {
                            await routeManager.setChoosed(number: 4)
                        }
                    }) {
                        Text("Дневник питания")
                    }.buttonStyle(RoundedRectangleButtonStyle()).padding(.horizontal)
                }
                .position(x: g.size.width/2, y: g.size.height/2)
            }
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle("Выбор версии")
        .navigationBarBackButtonHidden()
    }
}
