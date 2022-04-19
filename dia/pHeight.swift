import SwiftUI

struct pHeight: View {
    @Binding var bHeight: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color.black
    var body: some View {
        VStack(spacing:0){
            Text("Рост до беременности, в см")
                .padding()
            Divider()
            VStack(spacing:0){
                TextField("см", text: $txt)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .keyboardType(.decimalPad)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.black)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }.padding()
            Divider()
            HStack(){
                Button(action: {
                    txt = ""
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
                        addHeight(Height: try convert(txt: txt))
                        txt = ""
                        lineColor = Color.black
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
}
