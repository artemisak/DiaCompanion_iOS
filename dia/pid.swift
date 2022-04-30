import SwiftUI

struct pid: View {
    @Binding var bid: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color.black
    var body: some View {
        VStack(spacing:0){
            Text("Индивидуальный номер пациента")
                .padding()
            Divider()
            VStack(spacing:0){
                TextField("ID", text: $txt)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .keyboardType(.numberPad)
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
                        bid.toggle()
                    }
                }){
                    Text("Отменить")
                }
                .buttonStyle(TransparentButton())
                Divider()
                Button(action: {
                    do {
                        lineColor = .black
                        addID(id: try convertToInt(txt: txt))
                        withAnimation {
                            bid.toggle()
                        }
                    } catch {
                        lineColor = .red
                    }
                }){
                    Text("Сохранить")
                }
                .buttonStyle(TransparentButton())
            }.frame(height: 50)
        }
        .background(Color.white.cornerRadius(10))
        .padding([.leading, .trailing], 15)
        .onAppear(perform: {txt = ""})
    }
}
