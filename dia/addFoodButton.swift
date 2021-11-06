//
//  addFoodButton.swift
//  dia
//
//  Created by Артем  on 05.11.2021.
//

import SwiftUI

struct addFoodButton: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var txt: String = ""
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Поиск по слову")){TextField("Введние название блюда", text: $txt)}
                Section(header: Text("Поиск по категории")){
                    ForEach(FillFoodCategoryList(), id:\.self){i in
                        NavigationLink(destination: GetFoodCategoryItemsView(category: "\(i.name)")) {
                            Text("\(i.name)")
                        }.foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Добавить блюдо")
        }
    }
    func GetFoodCategoryItemsView(category: String) -> some View {
        List {
            Section {
                ForEach(GetFoodCategoryItems(_category: category), id:\.self){i in
                    Button(action: {}){Text("\(i.name)")}
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle(category)
        .navigationBarTitleDisplayMode(.inline)
        .interactiveDismissDisabled()
    }
}


struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton()
    }
}
