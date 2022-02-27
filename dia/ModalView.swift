//
//  ModalView.swift
//  dia
//
//  Created by Артем  on 19.08.2021.
//

import SwiftUI
import PDFKit

struct ModalView: View {
    @State var phelper : Bool = true
    let fileUrl = Bundle.main.url(forResource: "Help", withExtension: "pdf")!
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section(header: Text("О пациенте")){
                        NavigationLink(destination: ketonur()) {
                            Button("Добавить запись о кетонурии", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: massa()) {
                            Button("Добавить измерение массы тела", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: pacient()) {
                            Button("Данные пациента", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: poldny()) {
                            Button("Отметить полные дни", action: {})
                        }.foregroundColor(.black)
                        NavigationLink(destination: PDFKitView(url: fileUrl)
                                        .navigationBarTitleDisplayMode(.inline)) {
                            Button("Обучение", action: {})
                        }.foregroundColor(.black)
//                        Button("Обучение", action: {
//                            PDFKitView(url: fileUrl)
//                        }).foregroundColor(.black)
                        Button("Помощь", action: {
                            phelper = false
                        })
                        .foregroundColor(.black)
                    }
                }
                if !phelper {
                    helper(phelper: $phelper)
                        .ignoresSafeArea()
                }
            }
            .navigationTitle("Дополнительно")
        }
    }
}

struct PDFKitView: View {
    var url: URL
    var body: some View {
        PDFKitRepresentedView(url)
    }
}

struct PDFKitRepresentedView: UIViewRepresentable {
    let url: URL
    init(_ url: URL) {
        self.url = url
    }

    func makeUIView(context: UIViewRepresentableContext<PDFKitRepresentedView>) -> PDFKitRepresentedView.UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: self.url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PDFKitRepresentedView>) {
        // Update the view.
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView()
    }
}


