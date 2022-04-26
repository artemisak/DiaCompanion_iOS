import SwiftUI

@main
struct diaApp: App {
    var body: some Scene {
        WindowGroup {
            startPage()
                .dynamicTypeSize(.medium)
        }
    }
    init(){
        Thread.sleep(forTimeInterval: 0.2)
    }
}
