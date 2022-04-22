import SwiftUI
import PDFKit

struct ModalView: View {
    @State private var phelper : Bool = false
    @State private var fileUrl = Bundle.main.url(forResource: "help", withExtension: "pdf")!
    @State private var pFio: Bool = false
    @State private var pV: Bool = false
    @State private var pDate: Bool = false
    @State private var bStart: Bool = false
    @State private var bWeek: Bool = false
    @State private var bid: Bool = false
    @State private var bWeight: Bool = false
    @State private var bHeight: Bool = false
    @State private var vDate = Date()
    @State private var txt: String = ""
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
                    NavigationLink(destination: pacient(pFio: $pFio, pV: $pV, pDate: $pDate, bStart: $bStart, bWeek: $bWeek, bid: $bid, bWeight: $bWeight, bHeight: $bHeight)) {
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
        .customPopupView(isPresented: $bWeek, popupView: { weekS(bWeek: $bWeek) })
        .customPopupView(isPresented: $pV, popupView: { currentV(pV:$pV) })
        .customPopupView(isPresented: $pFio, popupView: { fio(pFio: $pFio, txt: $txt) })
        .customPopupView(isPresented: $pDate, popupView: { bday(pDate: $pDate, vDate: $vDate) })
        .customPopupView(isPresented: $bStart, popupView: { dStart(bStart: $bStart, vDate: $vDate) })
        .customPopupView(isPresented: $bid, popupView: { pid(bid: $bid, txt: $txt) })
        .customPopupView(isPresented: $bWeight, popupView: { pWeight(bWeight: $bWeight, txt: $txt) })
        .customPopupView(isPresented: $bHeight, popupView: { pHeight(bHeight: $bHeight, txt: $txt) })
    }
}

struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor: Color
    let animation: Animation?
    
    var body: some View {
        ZStack{
        content()
            .animation(nil, value: isPresented)
            .blur(radius: isPresented ? 1.5 : 0)
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
            .animation(animation, value: isPresented)
        }
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
