import SwiftUI

struct addSreenView: View {
    @Binding var addScreen: Bool
    @Binding var gram: String
    @Binding var selectedFood: String
    @Binding var foodItems: [String]
    var body: some View {
        ZStack{
            Color(.black)
                .opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture{withAnimation(.linear){addScreen.toggle()}}
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
                        .foregroundColor(.black)
                        .padding(.leading, 16)
                        .padding(.trailing, 16)
                }.padding()
                Divider()
                HStack(){
                    Button(action: {
                        gram = ""
                        selectedFood = ""
                        addScreen.toggle()
                    }){
                        Text("Назад")
                    }
                    .buttonStyle(TransparentButton())
                    Divider()
                    Button(action: {
                        foodItems.append("\(selectedFood)//\(gram)")
                        gram = ""
                        selectedFood = ""
                        addScreen.toggle()
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
}
