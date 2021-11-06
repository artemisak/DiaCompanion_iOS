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
            Form {
                Section(header: Text("Поиск по слову")){TextField("Введние название блюда", text: $txt)}
                Section(header: Text("Поиск по категории")){
                    ForEach(FillFoodCategoryList(), id:\.self){i in
                        NavigationLink(destination: GetFoodItemsView(category: "\(i.name)")) {
                            Text("\(i.name)")
                        }.foregroundColor(.black)
                    }
                }
            }
            .navigationTitle("Добавить блюдо")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading){
                    Button(action:{
                        presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName: "chevron.backward")
                        Text("Назад")
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
    func GetFoodItemsView(category: String) -> some View {
        ScrollView{
            
        }
    }
}


struct addFoodButton_Previews: PreviewProvider {
    static var previews: some View {
        addFoodButton()
    }
}
