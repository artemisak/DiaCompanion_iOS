//
//  testingView.swift
//  dia
//
//  Created by Артём Исаков on 29.07.2022.
//

import SwiftUI

struct testingView: View {
    @State private var searchedText: String = ""
    @StateObject var basket = fruits()
    var body: some View {
        List {
            ForEach(basket.apples.filter({$0.name.contains(searchedText) || searchedText.isEmpty}).sorted(by: {$0.range < $1.range}), id: \.self){ i in
                if i.range == 0 {
                    Button(action: {
                        let tapedIndex = String(basket.apples.firstIndex(where: {$0.name == i.name})!)
                        basket.apples[Int(tapedIndex)!].range = 1
                    }, label: {
                        Text("\(i.name)")
                    }).listRowBackground(Color.green.opacity(0.3))
                } else {
                    Button(action: {
                        let tapedIndex = String(basket.apples.firstIndex(where: {$0.name == i.name})!)
                        basket.apples[Int(tapedIndex)!].range = 0
                    }, label: {
                        Text("\(i.name)")
                    })
                }
            }
        }
        .navigationTitle("Fruits")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .always))
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: {subView(basket: basket)}, label: {Image(systemName: "arrow.forward").foregroundColor(.blue)})
            }
        }
        .task {
            basket.apples.removeAll()
            basket.fillBasket()
        }
        .navigationViewStyle(.stack)
    }
}

struct subView: View {
    @State private var searchedText: String = ""
    @State private var lastObj: Int = 0
    @ObservedObject var basket: fruits
    var body: some SwiftUI.View {
        List {
            ForEach(basket.apples.filter({$0.name.contains(searchedText) || searchedText.isEmpty}).sorted(by: {$0.range < $1.range}), id: \.self){i in
                if i.range == 0 {
                    Button(action: {
                        let tapedIndex = String(basket.apples.firstIndex(where: {$0.name == i.name})!)
                        basket.apples[Int(tapedIndex)!].range = 1
                    }, label: {
                        Text("\(i.name)")
                    })
                    .listRowBackground(Color.green.opacity(0.3))
                } else {
                    Button(action: {
                        let tapedIndex = String(basket.apples.firstIndex(where: {$0.name == i.name})!)
                        basket.apples[Int(tapedIndex)!].range = 0
                    }, label: {
                        Text("\(i.name)")
                    })
                    .onAppear {
                        if !basket.apples.isEmpty && !searchedText.isEmpty && i.name == basket.apples.last!.name {
                            lastObj += 15
                            basket.searchFromDB(searchedText, lastObj)
                        }
                    }
                }
            }
        }
        .navigationTitle("More dishes")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchedText, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchedText, perform: {i in
            if !i.isEmpty {
                basket.searchFromDB(i,0)
            } else {
                basket.apples.removeAll()
            }
        })
    }
}

struct testingView_Previews: PreviewProvider {
    static var previews: some View {
        testingView()
    }
}
