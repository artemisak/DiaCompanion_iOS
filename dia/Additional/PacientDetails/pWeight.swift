import SwiftUI

struct pWeight: View {
    @Binding var bWeight: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color("listButtonColor")
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack{
            Color("Popup_Background").ignoresSafeArea()
            VStack(spacing:0){
                Text("Вес до беременности, в кг")
                    .padding()
                Divider()
                VStack(spacing:0){
                    TextField("кг", text: $txt)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .keyboardType(.decimalPad)
                        .focused($focusedField)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(lineColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
                        bWeight.toggle()
                    }){
                        Text("Отменить")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        do {
                            lineColor = Color("listButtonColor")
                            pacientManager.provider.addWeight(Weight: try convert(txt: txt))
                            bWeight.toggle()
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
            txt = pacientManager.provider.getPreloadWeight()
            focusedField = true
        })
    }
}
