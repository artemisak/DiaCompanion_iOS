import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @State public var recommendMessage: String = ""
    @State public var isVisible: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    @Binding var isnt: Bool
    var body: some View {
        GeometryReader { g in
            ScrollView {
                LazyVGrid(columns: columns) {
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
                    NavigationLink(destination: enterFood(enabled: false, sugar: "", date: Date(), foodItems: [], ftpreviewIndex: ftype.zavtrak, idForDelete: [], recommendMessage: $recommendMessage, isVisible: $isVisible, txtTheme: $txtTheme, hasChanged: .constant(false))) {
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
            .alert(isPresented: $isVisible) {
                Alert(title: Text("Рекомендации"), message: Text(recommendMessage), dismissButton: .default(Text("ОК")))
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal, content: {Text("ДиаКомпаньон").font(.headline).fixedSize()})
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {showModal.toggle()}){
                    Image(systemName: "line.3.horizontal")
                }
                .sheet(isPresented: $showModal) {
                    ModalView(txtTheme: $txtTheme, isnt: $isnt).dynamicTypeSize(txtTheme)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea(.keyboard)
    }
}
