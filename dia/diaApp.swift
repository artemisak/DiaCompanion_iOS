import SwiftUI

@main
struct diaApp: App {
    var body: some Scene {
        WindowGroup {
            startPage()
                .dynamicTypeSize(.medium ... .xLarge)
                .environment(\.defaultMinListRowHeight, 44)
        }
    }
    init(){
        Thread.sleep(forTimeInterval: 0.2)
    }
}
