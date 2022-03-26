
import SwiftUI

struct mainPage: View {
    @State private var showModal: Bool = false
    @State private var isPres: Bool = false
    @State private var isLoad: Bool = true
    @State private var path: [Any] = []
    var anatomy = Anatomy()
    var body: some View {
        GeometryReader { g in
            ZStack {
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
                            Button(action:{
                                Task {
                                    do {
                                        isLoad.toggle()
                                        path.removeAll()
                                        path.append(try await anatomy.generate())
                                        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                                            isLoad.toggle()
                                            isPres.toggle()
                                        }
                                    }
                                    catch {
                                        print(error)
                                    }
                                }
                            }){
                                VStack{
                                    Image("menu_xlsx")
                                    Text("Экспорт данных").foregroundColor(Color.black).multilineTextAlignment(.center)
                                }
                            }
                            .sheet(isPresented: $isPres) {
                                ShareSheet(activityItems: path)
                            }
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

struct ShareSheet: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ShareSheet>) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<ShareSheet>) {
    }
}
