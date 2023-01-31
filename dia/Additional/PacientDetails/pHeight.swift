import SwiftUI

struct pHeight: View {
    @Binding var bHeight: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color("listButtonColor")
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack{
            Color("Popup_Background").ignoresSafeArea()
            VStack(spacing:0){
                Text("Рост до беременности, в см")
                    .padding()
                Divider()
                VStack(spacing:0){
                    TextField("см", text: $txt)
                        .focused($focusedField)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .keyboardType(.decimalPad)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(lineColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
                        bHeight.toggle()
                    }){
                        Text("Отменить")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        do {
                            lineColor = Color("listButtonColor")
                            pacientManager.provider.addHeight(Height: try convert(txt: txt))
                            bHeight.toggle()
                        } catch {
                            lineColor = Color.red
                        }
                    }){
                        Text("Сохранить")
                    }
                    .buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color("Popup_Field").cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .onAppear(perform: {
            txt = pacientManager.provider.getPreloadHeight()
            focusedField = true
        })
    }
}
