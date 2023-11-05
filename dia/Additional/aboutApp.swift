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
                Text("Межплатформенный комплекс программного обеспечения, сочетающий традиционные методы контроля показаний глюкозы в крови с машинным обучением.")
                Link(destination: URL(string: "https://pubmed.ncbi.nlm.nih.gov/37361536/")!, label: {
                    Text("Описание медицинского подхода")
                })
                Link(destination: URL(string: "https://link.springer.com/article/10.1007/s10527-020-09931-3")!, label: {
                    Text("Описание методологии наблюдения пациента")
                })
                Link(destination: URL(string: "https://ieeexplore.ieee.org/document/9281297")!, label: {
                    Text("Принципы разработки модели машинного обучения")
                })
                Link(destination: URL(string: "https://mhealth.jmir.org/2018/1/e6/")!, label: {
                    Text("Принципы разработки системы мониторинга")
                })
                Link(destination: URL(string: "https://www.mdpi.com/2072-6643/12/2/302")!, label: {
                    Text("Роль ГИ и ГН в прогнозировании УГК")
                })
                Link(destination: URL(string: "https://www.endocrine-abstracts.org/ea/0090/ea0090EP235")!, label: {
                    Text("Роль микробиома в прогнозировании УГК")
                })
                Link(destination: URL(string: "https://www.elibrary.ru/item.asp?id=46602070")!, label: {Text("Разработка базы данных с ГИ")
                })
            } header: {
                Text("Описание").font(.body)
            }
            Section {
                Link(destination: URL(string: "https://diacompanion.ru/document_policy_confidentiality")!, label: {
                    Text("Политика конфиденциальности")
                })
                Link(destination: URL(string: "https://diacompanion.ru/document_user_agreement")!, label: {
                    Text("Пользовательское соглашение")
                })
            } header: {
                Text("Документы").font(.body)
            }
            Section {
                Link(destination: URL(string: "https://ncmu.almazovcentre.ru/issledovaniya/")!, label: {
                    Text("Проекты НЦМУ Персонализированной медицины")
                })
            } header: {
                Text("Другие проекты").font(.body)
            }
            Section {
                Link(destination: URL(string: "https://www.sqlite.org/index.html")!, label: {
                    Text("SQLite")
                })
                Link(destination: URL(string: "https://libxlsxwriter.github.io/")!, label: {
                    Text("libxlsxwriter")
                })
                Link(destination: URL(string: "https://www.deepl.com/translator")!, label: {
                    Text("DeepL")
                })
            } header: {
                Text("Использованные ресурсы").font(.body)
            }
        }
        .navigationTitle("О приложении")
    }
}
