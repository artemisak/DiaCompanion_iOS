//
//  addButtonView.swift
//  ДиаКомпаньон Beta
//
//  Created by Артём Исаков on 13.01.2023.
//

import SwiftUI
import Combine

struct addGramButton: View {
    @EnvironmentObject var collection: foodCollections
    @State var gram: String
    @State var editing: Bool
    @Binding var isShowingSheet: Bool
    @Binding var showSuccesNotify: Bool
    var body: some View {
        if #available(iOS 16, *) {
            NavigationStack {
                List {
                    Section {
                        TextField("", text: $gram, prompt: Text("Граммы")).labelsHidden()
                            .keyboardType(.decimalPad)
                            .onReceive(Just(gram)) { newValue in
                                let filtered = newValue.filter { "0123456789,.".contains($0) }
                                if filtered != newValue {
                                    gram = filtered
                                }
                            }
                    } header: {
                        Text("Информация о продукте").font(.body)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button {
                            do {
                                switch collection.whereToSave {
                                case .addedFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.addedFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.addedFoodItems[collection.addedFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                case .editingFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.editedFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.editedFoodItems[collection.editedFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                case .recipeFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.recipeFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.recipeFoodItems[collection.recipeFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        } label: {
                            Text(editing ? "Сохранить" : "Добавить")
                        }
                    })
                }
                .navigationTitle(LocalizedStringKey(collection.selectedItem!.name))
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            NavigationView {
                List {
                    Section {
                        TextField("", text: $gram, prompt: Text("Граммы")).labelsHidden()
                            .keyboardType(.decimalPad)
                            .onReceive(Just(gram)) { newValue in
                                let filtered = newValue.filter { "0123456789,.".contains($0) }
                                if filtered != newValue {
                                    gram = filtered
                                }
                            }
                    } header: {
                        Text("Масса продукта в граммах").font(.body)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Button {
                            do {
                                switch collection.whereToSave {
                                case .addedFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.addedFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.addedFoodItems[collection.addedFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                case .editingFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.editedFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.editedFoodItems[collection.editedFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                case .recipeFoodItems:
                                    if !editing {
                                        collection.selectedItem!.gram = try convert(txt: gram)
                                        collection.recipeFoodItems.append(collection.selectedItem!)
                                        isShowingSheet.toggle()
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                                            withAnimation {
                                                showSuccesNotify = true
                                            }
                                        })
                                    } else {
                                        collection.recipeFoodItems[collection.recipeFoodItems.firstIndex(where: {$0.id == collection.selectedItem!.id})!].gram = try convert(txt: gram)
                                        isShowingSheet.toggle()
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        } label: {
                            Text(editing ? "Сохранить" : "Добавить")
                        }
                    })
                }
                .navigationTitle(LocalizedStringKey(collection.selectedItem!.name))
                .navigationBarTitleDisplayMode(.inline)
            }.navigationViewStyle(.stack)
            
        }
    }
}
