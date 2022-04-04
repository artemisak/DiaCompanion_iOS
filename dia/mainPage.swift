
import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var isLoad: Bool = true
    var sheets = exportTable()
    var body: some View {
        GeometryReader { g in
            ZStack {
                ScrollView {
                    HStack {
                        VStack {
                            NavigationLink(destination: sugarChange()) {
                                VStack {
                                    Image("menu_sugar")
                                    Text("Изм. сахара")
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
                                    Text("Активность и сон").foregroundColor(Color.black).multilineTextAlignment(.center)
                                        .font(.system(size: 17))
                                }
                                
                            }
                            .padding(.top, 26.3)
                            Button(action:{
                                isLoad.toggle()
                                let AV = UIActivityViewController(activityItems: [sheets.generate()], applicationActivities: nil)
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                    isLoad.toggle()
                                    UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
                                }
                            }){
                                VStack{
                                    Image("menu_xlsx")
                                    Text("Экспорт данных").foregroundColor(Color.black).multilineTextAlignment(.center).font(.system(size: 17))
                                }
                            }
                            .padding(.top, 26.3)
                        }
                    }
                    .position(x: g.size.width/2, y: g.size.height/2)
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
        }
        
    }
}

public extension UIApplication {
    func currentUIWindow() -> UIWindow? {
        let connectedScenes = UIApplication.shared.connectedScenes
            .filter({
                $0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
        
        let window = connectedScenes.first?
            .windows
            .first { $0.isKeyWindow }
        
        return window
        
    }
}
