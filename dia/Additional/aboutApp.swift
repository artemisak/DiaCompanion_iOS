//
//  aboutApp.swift
//  dia
//
//  Created by Артём Исаков on 18.12.2022.
//

import SwiftUI

struct aboutApp: View {
    var body: some View {
        List {
            Section {
                Text("Межплатформенный комплекс программного обеспечения, сочетающий традиционные методы контроля показаний сахара в крови с машинным обучением.")
            } header: {
                Text("Описание")
            }
            Section {
                Link(destination: URL(string: "https://github.com/artemisak/swiftDia/blob/main/README.md")!){Text("Политика конфиденциальности")}
            } header: {
                Text("Сопроводительные документы")
            }
            Section {
                Link(destination: URL(string: "https://github.com/artemisak")!) {Text("GitHub")}
            } header: {
                Text("Другие проекты")
            }
            Section {
                Link(destination: URL(string: "https://www.sqlite.org/index.html")!) {
                    Text("SQLite")
                }
                Link(destination: URL(string: "https://libxlsxwriter.github.io/")!) {
                    Text("libxlsxwriter")
                }
                Link(destination: URL(string: "https://cocoapods.org/")!) {
                    Text("CocoaPods")
                }
            } header: {
                Text("Использованные ресурсы")
            }
        }
        .navigationTitle("О приложении")
    }
}
