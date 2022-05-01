import SwiftUI

struct regHelper: View {
    @Binding var phelper: Bool
    var body: some View {
        VStack(spacing:0){
            Text("Помощь")
                .padding()
            Divider()
            ScrollView{
                VStack(){
                    Text("Для получения логина и пароля обратитесь в ближайщее лечебно профилактическое отделение Национального Медицинского Исследовательского Центра имени В.А.Алмазова (НИЛ метаболических заболеваний у беременных Института эндокринологии, НИЛ метаболических заболеваний и микробиоты)")
                        .fixedSize(horizontal: false, vertical: true)
                }
            }.padding()
            Divider()
            Button(action: {
                withAnimation {
                    phelper.toggle()
                }
            }){
                Text("OK")
            }
            .buttonStyle(TransparentButton())
        }
        .background(Color.white.cornerRadius(10))
        .frame(minHeight: 0, maxHeight: 355)
        .padding([.leading, .trailing], 15)
    }
}
