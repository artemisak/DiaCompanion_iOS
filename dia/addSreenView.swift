import SwiftUI

struct addSreenView: View {
    @Binding var addScreen: Bool
    @Binding var gram: String
    @Binding var selectedFood: String
    @Binding var foodItems: [String]
    @State var isCorrect: Bool = true
    var body: some View {
        VStack(spacing:0){
            Text("Добавить блюдо/продукт")
                .padding()
            Divider()
            VStack(){
                TextField("Вес, в граммах", text: $gram)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .keyboardType(.numberPad)
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isCorrect ? .black : .red)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
            }.padding()
            Divider()
            HStack(){
                Button(action: {
                    addScreen.toggle()
                }){
                    Text("Назад")
                }
                .buttonStyle(TransparentButton())
                Divider()
                Button(action: {
                    do {
                        _ = try convertToInt(txt: gram)
                        isCorrect = true
                        foodItems.append("\(selectedFood)//\(gram)")
                        addScreen.toggle()
                    } catch {
                        isCorrect = false
                    }

                }){
                    Text("Сохранить")
                }
                .buttonStyle(TransparentButton())
            }.frame(height: 50)
        }
        .background(Color.white.cornerRadius(10))
        .padding([.leading, .trailing], 15)
        .onAppear(perform: {gram = ""})
        .onDisappear(perform: {selectedFood = ""})
    }
}
