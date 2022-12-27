import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject var islogin: Router
    @Binding var txtTheme: DynamicTypeSize
    var body: some View {
        GeometryReader { g in
            ScrollView {
                LazyVGrid(columns: columns) {
                    if islogin.version != 4 {
                        NavigationLink(destination: sugarChange(t: "", date: Date(), isAct:  false, bool1: 0, spreviewIndex: .natoshak, idForDelete: [], txtTheme: $txtTheme, hasChanged: .constant(false))) {
                            VStack {
                                Image("menu_sugar")
                                    .scaledToFit()
                                Text("Измерение сахара")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                            }
                        }.buttonStyle(ChangeColorButton())
                        NavigationLink(destination: inject(t: "", date: Date(), previewIndex: injectType.ultra, previewIndex1: injects.natoshak, idForDelete: [], txtTheme: $txtTheme, hasChanged: .constant(false))) {
                            VStack {
                                Image("menu_syringe")
                                    .scaledToFit()
                                Text("Введение инсулина")
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(Color.black)
                            }
                        }.buttonStyle(ChangeColorButton())
                    }
                    NavigationLink(destination: enterFood(enabled: false, sugar: "", date: Date(), foodItems: [], ftpreviewIndex: ftype.zavtrak, idForDelete: [], txtTheme: $txtTheme, hasChanged: .constant(false))) {
                        VStack {
                            Image("menu_food")
                                .scaledToFit()
                            Text("Прием пищи")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: enterAct(t: "", date: Date(), actpreviewIndex: act.zar, idForDelete: [], txtTheme: $txtTheme, hasChanged: .constant(false))) {
                        VStack {
                            Image("menu_sleep")
                                .scaledToFit()
                            Text("Физическая \nактивность и сон")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: history(txtTheme: $txtTheme)) {
                        VStack {
                            Image("menu_paper")
                                .scaledToFit()
                            Text("История записей")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: export(txtTheme: $txtTheme)) {
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
                    ModalView(txtTheme: $txtTheme).dynamicTypeSize(txtTheme)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                NavigationLink(destination: addCustomMeal(txtTheme: $txtTheme)) {
                    Image(systemName: "plus")
                }.buttonStyle(ButtonAndLink()).foregroundColor(Color.accentColor)
            }
        })
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden()
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}
