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
        GeometryReader {geometry in
            ZStack {
                List {
                    Section{
                        ForEach($collection.listOfPinnedFood, id: \.id) { $dish in
                            Button {
                                collection.selectedItem = dish
                                withAnimation {
                                    showPopover.toggle()
                                    showSuccesNotify = false
                                }
                            } label: {
                                listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, width: geometry.size.width, index: $dish.index)
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
                                listRow(food_name: dish.name, food_prot: dish.prot, food_fat: dish.fat, food_carbo: dish.carbo, food_kkal: dish.kkal, food_gi: dish.gi, width: geometry.size.width, index: $dish.index)
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
                                collection.appendList(item_id: dish.id)
                            }
                        }
                    } header: {
                        listHeader().font(.body)
                    }
                }
                .listStyle(.insetGrouped)
                VStack {
                    if showSuccesNotify {
                        VStack {
                            Spacer()
                            succesNotify()
                        }
                    }
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showPopover, content: {addGramButton(gram: "100,0", editing: false, isShowingSheet: $showPopover, showSuccesNotify: $showSuccesNotify)})
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

struct searchList_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { g in
            searchByWordList()
                .environmentObject(foodCollections())
        }
    }
}
