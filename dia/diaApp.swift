import SwiftUI

@main
struct diaApp: App {
    var body: some Scene {
        WindowGroup {
            startPage()
                .preferredColorScheme(.light)
                .font(.system(size: 20))
        }
    }
    init(){
        Thread.sleep(forTimeInterval: 0.2)
    }
}
