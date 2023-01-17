import SwiftUI

struct mainPage: View {
    @EnvironmentObject var islogin: Router
    @EnvironmentObject var collection: foodCollections
    @State private var localDate: Date = Date()
    @State private var showModal: Bool = false
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        GeometryReader { g in
            ScrollView {
                LazyVGrid(columns: columns) {
                    if islogin.version != 4 {
                        NavigationLink(destination: sugarChange(t: "", date: localDate, isAct:  false, bool1: 0, spreviewIndex: .natoshak, idForDelete: [], hasChanged: .constant(false))) {
                            VStack {
                                Image("menu_sugar")
                                    .scaledToFit()
                                Text("Измерение сахара")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                            }
                        }.buttonStyle(ChangeColorButton()).simultaneousGesture(TapGesture().onEnded({localDate = Date()}))
                        NavigationLink(destination: inject(t: "", date: localDate, previewIndex: injectType.ultra, previewIndex1: injects.natoshak, idForDelete: [], hasChanged: .constant(false))) {
                            VStack {
                                Image("menu_syringe")
                                    .scaledToFit()
                                Text("Введение инсулина")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                            }
                        }.buttonStyle(ChangeColorButton()).simultaneousGesture(TapGesture().onEnded({localDate = Date()}))
                    }
                    NavigationLink(destination: enterFood(enabled: false, sugar: "", date: localDate, ftpreviewIndex: ftype.zavtrak, idForDelete: [], hasChanged: .constant(false))) {
                        VStack {
                            Image("menu_food")
                                .scaledToFit()
                            Text("Прием пищи")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton()).simultaneousGesture(TapGesture().onEnded({localDate = Date()}))
                    NavigationLink(destination: enterAct(t: "", date: localDate, actpreviewIndex: act.zar, idForDelete: [], hasChanged: .constant(false))) {
                        VStack {
                            Image("menu_sleep")
                                .scaledToFit()
                            Text("Физическая \nактивность и сон")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton()).simultaneousGesture(TapGesture().onEnded({localDate = Date()}))
                    NavigationLink(destination: history()) {
                        VStack {
                            Image("menu_paper")
                                .scaledToFit()
                            Text("История записей")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: export()) {
                        VStack {
                            Image("menu_chart")
                                .scaledToFit()
                            Text("Экспорт данных")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                }
                .padding()
                .frame(width: g.size.width)
                .frame(minHeight: g.size.height)
            }
        }
        .navigationTitle("ДиаКомпаньон")
        .toolbar(content: {
            ToolbarItem(placement: .automatic) {
                Button(action: {showModal.toggle()}){
                    Image(systemName: "line.3.horizontal")
                }
                .buttonStyle(ButtonAndLink()).foregroundColor(Color.accentColor)
                .sheet(isPresented: $showModal) {
                    ModalView()
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: addCustomMeal()) {
                    Image(systemName: "plus")
                }.buttonStyle(ButtonAndLink()).foregroundColor(Color.accentColor)
            }
        })
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
