//
//  foodList.swift
//  dia
//
//  Created by Артём Исаков on 22.09.2023.
//

import SwiftUI

struct foodList: View {
    @EnvironmentObject var collection: foodCollections
    @Binding var showEditView: Bool
    @Binding var id0: Int
    var body: some View {
        ForEach((collection.whereToSave == varToSave.addedFoodItems) ? $collection.addedFoodItems : $collection.editedFoodItems, id: \.id) {$i in
            VStack(alignment: .leading) {
                indicatorGroup(gi: $i.gi, carbo: $i.weightedСarbo, gl: $i.gl)
                Text("\(i.name) (\(i.gram!, specifier: "%.1f") г.)")
            }
            .padding(.vertical, 7)
            .swipeActions {
                Button(action: {
                    if collection.whereToSave == .addedFoodItems {
                        removeRows(i: collection.addedFoodItems.firstIndex(where: {$0.id == i.id})!)
                    } else {
                        removeRows(i: collection.editedFoodItems.firstIndex(where: {$0.id == i.id})!)
                    }
                }, label: {
                    Image(systemName: "trash.fill")
                })
                .tint(Color.red)
            }
            .swipeActions {
                Button(action: {
                    if collection.whereToSave == .addedFoodItems {
                        id0 = collection.addedFoodItems.firstIndex(where: {$0.id == i.id})!
                        collection.selectedItem = i
                        withAnimation(.default){
                            showEditView = true
                        }
                    } else {
                        id0 = collection.editedFoodItems.firstIndex(where: {$0.id == i.id})!
                        collection.selectedItem = i
                        withAnimation(.default){
                            showEditView = true
                        }
                    }
                }, label: {
                    Image(systemName: "pencil")
                })
                .tint(Color.orange)
            }
        }
    }
    func removeRows(i: Int){
        if collection.whereToSave == .addedFoodItems {
            collection.addedFoodItems.remove(at: i)
        } else {
            collection.editedFoodItems.remove(at: i)
        }
    }
}
