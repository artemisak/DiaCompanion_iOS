import SwiftUI

struct helper: View {
    @Binding var phelper: Bool
    var body: some View {
        List {
            Section {
                Text("По вопросам сотрудничества обращайтесь по адресу электронной почты Национального Медицинского Исследовательского Центра: ncmu@almazovcentre.ru.")
            } header: {
                Text("Центр персонализированной медицины").font(.body)
            }
            Section {
                VStack {
                    Text(LocalizedStringKey("Дополнительную информацию о сотрудниках, курирующих проект, можно получить на странице [Научно-Исследовательской Лаборатории Метаболических Заболеваний и Микробиоты](https://ncmu.almazovcentre.ru/about/struktura-i-podrazdeleniya/nauchno-issledovatelskiy-otdel-geneticheskikh-riskov-i-personifitsirovannoy-profilaktiki/nil-metabolicheskikh-zabolevaniy-i-mikrobioty/)"))
                }
            } header: {
                Text("Исследовательская лаборатория").font(.body)
                
            }
        }
        .navigationTitle("Контакты")
    }
}
