//
//  export.swift
//  dia
//
//  Created by Артем  on 01.09.2021.
//
import SwiftUI
import UIKit

struct export: View {
    @State private var isPres: Bool = false
    @State private var isLoad: Bool = true
    @State private var path: [Any] = []
    var anatomy = Anatomy()
    var body: some View {
        ZStack {
            VStack {
                ScrollView {
                    HStack {
                        Button(action:{
                            isLoad.toggle()
                            Task {
                                path.removeAll()
                                path.append(try await anatomy.generate())
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    isLoad.toggle()
                                }
                                isPres.toggle()
                            }
                        }){
                            VStack{
                                Image("menu_xlsx")
                                Text("Показать данные в \n таблице").foregroundColor(Color.black).multilineTextAlignment(.center)
                            }
                        }
                        .sheet(isPresented: $isPres) {
                            ShareSheet(activityItems: path)
                        }
                        Button(action:{
                            _=getFoodRecords()
                        }){
                            VStack{
                                Image("menu_mail")
                                Text("Отправить данные \n врачу").foregroundColor(Color.black).multilineTextAlignment(.center)
                            }
                        }
                    }.padding(.top)
                }
                Spacer()
            }
            if !isLoad {
                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(2.5)
            }
        }
        .navigationBarTitle("Экспорт данных")
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
