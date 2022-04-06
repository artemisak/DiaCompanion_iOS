
import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var isLoad: Bool = true
    var sheets = exportTable()
    var columns: [GridItem] =
             Array(repeating: .init(.flexible()), count: 2)
    var body: some View {
        GeometryReader { g in
            ZStack {
                ScrollView {
                    LazyVGrid(columns: columns) {
                        NavigationLink(destination: sugarChange()) {
                            VStack {
                                Image("menu_sugar")
                                Text("Измерение сахара")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        NavigationLink(destination: inject()) {
                            VStack {
                                Image("menu_syringe")
                                Text("Введение инсулина")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }

                        }
                        NavigationLink(destination: enterFood()) {
                            VStack {
                                Image("menu_food")
                                Text("Прием пищи")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        NavigationLink(destination: enterAct()) {
                            VStack {
                                Image("menu_sleep")
                                Text("Физическая \nактивность и сон")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }

                        }
                        NavigationLink(destination: history()) {
                            VStack {
                                Image("menu_paper")
                                Text("История записей")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        Button(action:{
                            isLoad.toggle()
                            DispatchQueue.main.asyncAfter(deadline: .now()+0.2){
                                isLoad.toggle()
                                let AV = UIActivityViewController(activityItems: [sheets.generate()], applicationActivities: nil)
                                UIApplication.shared.currentUIWindow()?.rootViewController?.present(AV, animated: true, completion: nil)
                            }
                        }){
                            VStack{
                                Image("menu_xlsx")
                                Text("Экспорт данных")
                                    .foregroundColor(Color.black)
                                    .multilineTextAlignment(.center)
                            }
                        }

                    }.position(x: g.size.width/2, y: g.size.height/2)
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
