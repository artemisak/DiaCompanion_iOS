//
//  ModalView.swift
//  dia
//
//  Created by Артем  on 19.08.2021.
//

import SwiftUI
import PDFKit

struct ModalView: View {
    @State private var phelper : Bool = false
    @State private var fileUrl = Bundle.main.url(forResource: "help", withExtension: "pdf")!
    var body: some View {
        NavigationView {
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
                        .navigationTitle("Обучение")
                        .navigationBarTitleDisplayMode(.inline)) {
                            Button("Обучение", action: {})
                        }.foregroundColor(.black)
                    Button("Помощь", action: {
                        withAnimation {
                            phelper.toggle()
                        }
                    })
                    .foregroundColor(.black)
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Дополнительно")
        }
        .customPopupView(isPresented: $phelper, popupView: { helper(phelper: $phelper) })
    }
}

struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?
    
    var body: some View {
        content()
            .animation(nil, value: isPresented)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)
    }
}

extension View {
    func customPopupView<PopupView>(isPresented: Binding<Bool>, popupView: @escaping () -> PopupView, backgroundColor: Color = .black.opacity(0.3), animation: Animation? = .default) -> some View where PopupView: View {
        return CustomPopupView(isPresented: isPresented, content: { self }, popupView: popupView, backgroundColor: backgroundColor, animation: animation)
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


