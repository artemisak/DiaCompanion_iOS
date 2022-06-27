import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var hasChanged: Bool = false
    @Binding var txtTheme: DynamicTypeSize
    var columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        GeometryReader { g in
            ScrollView {
                LazyVGrid(columns: columns) {
                    NavigationLink(destination: sugarChange(txtTheme: $txtTheme)) {
                        VStack {
                            Image("menu_sugar")
                                .scaledToFit()
                            Text("Измерение сахара")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: inject(txtTheme: $txtTheme)) {
                        VStack {
                            Image("menu_syringe")
                                .scaledToFit()
                            Text("Введение инсулина")
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.black)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: enterFood(date: Date(), foodItems: [], ftpreviewIndex: ftype.zavtrak, idForDelete: [], txtTheme: $txtTheme, hasChanged: $hasChanged)) {
                        VStack {
                            Image("menu_food")
                                .scaledToFit()
                            Text("Прием пищи")
                                .foregroundColor(Color.black)
                                .multilineTextAlignment(.center)
                        }
                    }.buttonStyle(ChangeColorButton())
                    NavigationLink(destination: enterAct(t: "", date: Date(), actpreviewIndex: act.zar, idForDelete: [], txtTheme: $txtTheme, hasChanged: $hasChanged)) {
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .principal, content: {Text("ДиаКомпаньон").font(.headline).fixedSize()})
            ToolbarItem(placement: .navigationBarTrailing){
                Button(action: {showModal.toggle()}){
                    Image(systemName: "line.3.horizontal")
                }
                .sheet(isPresented: $showModal) {
                    ModalView().dynamicTypeSize(txtTheme)
                }
            }
        }
        .ignoresSafeArea(.keyboard)
        .onAppear(perform: {
            hasChanged = false
        })
    }
}
