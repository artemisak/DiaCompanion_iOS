import SwiftUI

struct addSreenView: View {
    @State private var isCorrect: Bool = true
    @Binding var addScreen: Bool
    @Binding var gram: String
    @Binding var selectedFood: String
    @Binding var foodItems: [foodToSave]
    @Binding var successedSave: Bool
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                Text("Добавить блюдо/продукт")
                .padding()
                Divider()
                VStack(){
                    TextField("Вес, в граммах", text: $gram)
                        .focused($focusedField)
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
                        addScreen = false
                    }){
                        Text("Назад")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        do {
                            _ = try convertToInt(txt: gram)
                            isCorrect = true
                            foodItems.append(foodToSave(name: "\(selectedFood)////\(gram)"))
                            addScreen = false
                            focusedField = false
                            successedSave = true
                        }
                        catch {
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
        }
        .task {
            focusedField = true
        }
        .onAppear(perform: {
            gram = ""
        })
        .onDisappear(perform: {
            selectedFood = ""
        })
    }
}
