import SwiftUI

struct helper: View {
    @Binding var phelper: Bool
    var body: some View {
        VStack(spacing:0){
            Text("Помощь")
                .padding()
            Divider()
            ScrollView{
                VStack(){
                    Text("DiaCompanion GDM v. 1.0 \nПо вопросам работы с приложением - обращайтесь по адресу электронной почты: \namedi.ioakim@gmail.com \nИспользуя данное приложение вы соглашаетесь с тем, что ваши персональные данные будут храниться на вашем устройстве в виде закрытой базы данных и XLS-таблиц. Передача ваших данных осуществляется только в виде лично отправляемых вами лечащему врачу электронных писем. Ни при каких условиях ни в каких иных формах ваши данные не будут переданы третьим лицам.")
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
        .frame(minHeight: 0, maxHeight: 450)
        .padding([.leading, .trailing], 15)
    }
}
