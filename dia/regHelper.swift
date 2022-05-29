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
                    Text("Для доступа к приложению по программе обязательного медицинского страхования обратитесь в ближайщее государственное лечебно-профилактическое учреждение согласно месту жительства.")
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding()
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
        .frame(minHeight: 0, maxHeight: 320)
        .padding([.leading, .trailing], 15)
    }
}
