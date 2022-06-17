import SwiftUI

struct pHeight: View {
    @Binding var bHeight: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color.black
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack{
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                Text("Рост до беременности, в см")
                    .padding()
                Divider()
                VStack(spacing:0){
                    TextField("см", text: $txt)
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
                        withAnimation {
                            bHeight.toggle()
                        }
                    }){
                        Text("Отменить")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        do {
                            lineColor = Color.black
                            addHeight(Height: try convert(txt: txt))
                            withAnimation {
                                bHeight.toggle()
                            }
                        } catch {
                            lineColor = Color.red
                        }
                    }){
                        Text("Сохранить")
                    }
                    .buttonStyle(TransparentButton())
                }.frame(height: 50)
            }
            .background(Color.white.cornerRadius(10))
            .padding([.leading, .trailing], 15)
        }
        .onAppear(perform: {
            txt = ""
            focusedField = true
        })
    }
}
