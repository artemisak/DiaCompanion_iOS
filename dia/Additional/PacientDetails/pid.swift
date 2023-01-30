import SwiftUI

struct pid: View {
    @Binding var bid: Bool
    @Binding var txt: String
    @State private var lineColor: Color = Color.black
    @FocusState var focuseField: Bool
    var body: some View {
        ZStack{
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                Text("Индивидуальный номер пациента")
                    .padding()
                Divider()
                VStack(spacing:0){
                    TextField("ID", text: $txt)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                        .keyboardType(.numberPad)
                        .focused($focuseField)
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(lineColor)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
                        bid.toggle()
                    }){
                        Text("Отменить")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        do {
                            lineColor = .black
                            pacientManager.provider.addID(id: try convertToInt(txt: txt))
                            bid.toggle()
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
        }
        .onAppear(perform: {
            txt = pacientManager.provider.getPreloadDID()
            focuseField = true
        })
    }
}
