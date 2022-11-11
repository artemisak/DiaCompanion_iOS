import SwiftUI

struct regHelper: View {
    @Binding var phelper: Bool
    var body: some View {
        ScrollView {
            Text("Для доступа к приложению по программе обязательного медицинского страхования обратитесь в ближайщее государственное лечебно-профилактическое учреждение согласно месту жительства.").foregroundColor(.black)
        }
        .padding()
        .navigationTitle("Помощь")
    }
}
