import SwiftUI

struct helper: View {
    @Binding var phelper: Bool
    var body: some View {
        ScrollView {
            Text("DiaCompanion GDM v. 1.0 \nПо вопросам работы с приложением - обращайтесь по адресу электронной почты: \namedi.ioakim@gmail.com \nИспользуя данное приложение вы соглашаетесь с тем, что ваши персональные данные будут храниться на вашем устройстве в виде закрытой базы данных и XLS-таблиц. Передача ваших данных осуществляется только в виде лично отправляемых вами лечащему врачу электронных писем. Ни при каких условиях ни в каких иных формах ваши данные не будут переданы третьим лицам.")
        }
        .padding()
        .navigationTitle("Помощь")
    }
}