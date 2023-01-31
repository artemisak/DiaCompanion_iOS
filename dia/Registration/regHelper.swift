import SwiftUI

struct regHelper: View {
    var body: some View {
        ScrollView {
            Text("Для доступа к приложению по программе обязательного медицинского страхования обратитесь в ближайщее государственное лечебно-профилактическое учреждение согласно месту жительства.").foregroundColor(Color("listButtonColor")).padding()
        }
        .navigationTitle("Помощь")
    }
}
