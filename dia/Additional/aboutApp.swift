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
                Link(destination: URL(string: "https://www.elibrary.ru/item.asp?id=47313305")!){Text("Обоснование медицинского подхода к исследованию")}
                Link(destination: URL(string: "https://www.elibrary.ru/item.asp?id=49883928")!){Text("Связь кишечной микробиоты с прогнозированием ППГО")}
                Link(destination: URL(string: "https://www.elibrary.ru/item.asp?id=46602070")!){Text("Разработка базы данных с ГИ")}
            } header: {
                Text("Описание").font(.caption)
            }
            Section {
                Link(destination: URL(string: "https://github.com/artemisak/swiftDia/blob/main/README.md")!){Text("Политика конфиденциальности")}
            } header: {
                Text("Сопроводительные документы").font(.caption)
            }
            Section {
                Link(destination: URL(string: "https://github.com/artemisak")!) {Text("GitHub")}
            } header: {
                Text("Другие проекты").font(.caption)
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
                Text("Использованные ресурсы").font(.caption)
            }
        }
        .navigationTitle("О приложении")
    }
}
