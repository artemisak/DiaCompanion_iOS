import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var isLoad: Bool = true
    private var sheets = exportTable()
    private var columns: [GridItem] =
    Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        GeometryReader { g in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        NavigationLink(destination: sugarChange()) {
                            VStack {
                                Image("menu_sugar")
                                    .scaledToFit()
                                Text("Измерение сахара")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }.buttonStyle(ChangeColorButton())
                        NavigationLink(destination: inject()) {
                            VStack {
                                Image("menu_syringe")
                                    .scaledToFit()
                                Text("Введение инсулина")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }.buttonStyle(ChangeColorButton())
                        NavigationLink(destination: enterFood()) {
                            VStack {
                                Image("menu_food")
                                    .scaledToFit()
                                Text("Прием пищи")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }.buttonStyle(ChangeColorButton())
                        NavigationLink(destination: enterAct()) {
                            VStack {
                                Image("menu_sleep")
                                    .scaledToFit()
                                Text("Физическая \nактивность и сон")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                            
                        }.buttonStyle(ChangeColorButton())
                        NavigationLink(destination: history()) {
                            VStack {
                                Image("menu_paper")
                                    .scaledToFit()
                                Text("История \nзаписей")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }.buttonStyle(ChangeColorButton())
                        Button(action:{
                            isLoad.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                isLoad.toggle()
                                let AV = UIActivityViewController(activityItems: [sheets.generate()], applicationActivities: nil)
//                                AV.overrideUserInterfaceStyle = .light
//                                UINavigationBar.appearance().overrideUserInterfaceStyle = .light
//                                UITableView.appearance().overrideUserInterfaceStyle = .light
                                UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
                            }
                        }){
                            VStack{
                                Image("menu_xlsx")
                                    .scaledToFit()
                                Text("Экспорт \nданных")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        .buttonStyle(ChangeColorButton())
                    }
                    .padding()
                    .frame(width: g.size.width)
                    .frame(minHeight: g.size.height)
                }
                if !isLoad {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(2.5)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
            ToolbarItem(placement: .keyboard, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        UIApplication.shared.dismissedKeyboard()
                    }, label: {
                        Text("Готово")
                            .foregroundColor(Color(red: 0, green: 0.590, blue: 1))
                    })
                }
            })
        }
        .ignoresSafeArea(.keyboard)
    }
}
