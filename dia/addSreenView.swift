import SwiftUI

struct addSreenView: View {
    @State private var isCorrect: Bool = true
    @State private var isFavour: Bool = false
    @ObservedObject var foodList : Food
    @Binding var addScreen: Bool
    @Binding var gram: String
    @Binding var selectedFood: String
    @Binding var rating: Int
    @Binding var foodItems: [String]
    @FocusState var focusedField: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.2).ignoresSafeArea()
            VStack(spacing:0){
                HStack{
                    Image(systemName: isFavour ? "star.fill" : "star")
                        .onTapGesture {
                            let generator = UINotificationFeedbackGenerator()
                            generator.notificationOccurred(.success)
                            withAnimation(.spring()){
                                isFavour.toggle()
                            }
                            if foodList.FoodObj[foodList.FoodObj.firstIndex(where: {$0.name == selectedFood})!].rating == 0 {
                                foodList.FoodObj[foodList.FoodObj.firstIndex(where: {$0.name == selectedFood})!].rating = 1
                            } else {
                                foodList.FoodObj[foodList.FoodObj.firstIndex(where: {$0.name == selectedFood})!].rating = 0
                            }
                            changeRating(_name: selectedFood, _rating: rating)
                        }
                        .rotationEffect(.degrees(isFavour ? 217 : 0))
                        .foregroundColor(.blue)
                    Spacer()
                    Text("Добавить блюдо/продукт")
                    Spacer()
                }
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
                            foodItems.append("\(selectedFood)////\(gram)")
                            addScreen = false
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
        }
        .onAppear(perform: {
            if rating == 0 {
                isFavour = false
            } else {
                isFavour = true
            }
            gram = ""
            focusedField = true
        })
        .onDisappear(perform: {
            selectedFood = ""
        })
    }
}
