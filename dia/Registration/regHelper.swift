import SwiftUI

struct regHelper: View {
    var body: some View {
        ScrollView {
            Text("Для доступа к приложению по программе обязательного медицинского страхования обратитесь за пригласительным кодом в ближайщее государственное лечебно-профилактическое учреждение согласно месту жительства. И пройдите регистрацию по ссылке: http://diacompanion.ru/register.").foregroundColor(Color("listButtonColor")).padding()
        }
        .navigationTitle("Помощь")
    }
}
