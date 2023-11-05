//
//  customList.swift
//  listing
//
//  Created by Артём Исаков on 02.01.2023.
//

import SwiftUI

struct searchByWordList: View {
    @EnvironmentObject var collection: foodCollections
    @State private var showPopover: Bool = false
    @State private var showSuccesNotify: Bool = false
    var body: some View {
        ZStack {
            List {
                Section {
                    ForEach($collection.listOfPinnedFood, id: \.id) { $dish in
                        Button {
                            collection.selectedItem = dish
                            withAnimation {
                                showPopover.toggle()
                                showSuccesNotify = false
                            }
                        } label: {
                            listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, index: $dish.index)
                        }
                        .tint(Color("listButtonColor"))
                        .swipeActions(edge: .trailing){
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    withAnimation {
                                        collection.pinRow(item_id: dish.id, case_id: 1)
                                        collection.removeRow(item_id: dish.id, case_id: 1)
                                    }
                                })
                            } label: {
                                Label("", systemImage: "star.slash")
                            }
                            .tint(.blue)
                        }
                    }
                }
                Section {
                    ForEach($collection.listOfFood, id: \.id) { $dish in
                        Button {
                            collection.selectedItem = dish
                            withAnimation {
                                showPopover.toggle()
                                showSuccesNotify = false
                            }
                        } label: {
                            listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, index: $dish.index)
                        }
                        .tint(Color("listButtonColor"))
                        .swipeActions(edge: .trailing) {
                            Button {
                                DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: {
                                    withAnimation {
                                        collection.pinRow(item_id: dish.id, case_id: 0)
                                        collection.removeRow(item_id: dish.id, case_id: 0)
                                    }
                                })
                            } label: {
                                Label("", systemImage: "star")
                            }
                            .tint(.blue)
                        }
                        .onAppear {
                            if collection.isSearching {
                                collection.appendList(item_id: dish.id)
                            }
                        }
                    }
                } header: {
                    listHeader().font(.body)
                } footer: {
                    if collection.showListToolbar {
                        Text("База данных - проприетарная собственность ФГБУ НМИЦ им. В.А. Алмазова")
                            .font(.caption)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                    }
                }
            }
            .listStyle(.grouped)
            VStack {
                if showSuccesNotify {
                    VStack {
                        Spacer()
                        succesNotify()
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showPopover, content: {addGramButton(gram: "100,0", editing: false, isShowingSheet: $showPopover, showSuccesNotify: $showSuccesNotify).dynamicTypeSize(.medium)})
        .onChange(of: showSuccesNotify, perform: {newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now()+1.85, execute: {
                    withAnimation {
                        showSuccesNotify = false
                    }
                })
            }
        })
    }
}
