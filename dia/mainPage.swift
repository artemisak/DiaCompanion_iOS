
import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    var body: some View {
        GeometryReader { g in
            ScrollView {
                HStack {
                    VStack {
                        NavigationLink(destination: sugarChange()) {
                            VStack {
                                Image("menu_sugar")
                                Text("Измерение сахара")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        NavigationLink(destination: enterFood()) {
                            VStack {
                                Image("menu_food")
                                Text("Прием пищи")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }.padding(.vertical, 26.3)
                        NavigationLink(destination: history()) {
                            VStack {
                                Image("menu_paper")
                                Text("История записей")
                                    .font(.system(size: 17))
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }.padding(.trailing)
                    VStack {
                        NavigationLink(destination: inject()) {
                            VStack {
                                Image("menu_syringe")
                                Text("Введение инсулина").foregroundColor(Color.black).multilineTextAlignment(.center)
                                    .font(.system(size: 17))
                            }
                            
                        }
                        NavigationLink(destination: enterAct()) {
                            VStack {
                                Image("menu_sleep")
                                Text("Физическая \n активность и сон").foregroundColor(Color.black).multilineTextAlignment(.center)
                                    .font(.system(size: 17))
                            }
                            
                        }
                        .padding(.top, 26.3)
                        NavigationLink(destination: export()) {
                            VStack {
                                Image("menu_chart")
                                Text("Эскпорт данных").foregroundColor(Color.black).multilineTextAlignment(.center)
                                    .font(.system(size: 17))
                            }
                        }
                    }
                }
                .position(x: g.size.width/2, y: g.size.height/2)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("ДиаКомпаньон")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {showModal.toggle()}){
                    Image(systemName: "line.3.horizontal")
                }
                .sheet(isPresented: $showModal) {
                    ModalView()
                }
            }
        }
        
    }
}
