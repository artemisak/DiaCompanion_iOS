import SwiftUI

@main
struct diaApp: App {
    @State public var main_font = DynamicTypeSize.xLarge
    var body: some Scene {
        WindowGroup {
            startPage(txtTheme: $main_font)
                .environment(\.locale, Locale.init(identifier: "ru"))
                .dynamicTypeSize(main_font)
                .environment(\.defaultMinListRowHeight, 52.5)
                .onAppear(perform: {
                    let x = UIScreen.main.bounds.size.width
                    let y = UIScreen.main.bounds.size.height
                    if (x == 375 && y == 812) {
                        // MARK: iphone 12(13) mini standart / 12(13) Pro Max zoomed
                        main_font = DynamicTypeSize.xLarge
                    } else if (x == 320 && y == 693) {
                        // MARK: iphone 12(13) zoomed / 12(13) mini zoomed
                        main_font = DynamicTypeSize.medium
                    } else if (x == 390 && y == 844) {
                        // MARK: iphone 12(13) standart
                        main_font = DynamicTypeSize.xLarge
                    } else if (x == 428 && y == 926) {
                        // MARK: iphone 12(13) Pro Max
                        main_font = DynamicTypeSize.xxLarge
                    } else if (x == 375 && y == 812) {
                        // MARK: iphone 11 zoomed / 11 Pro Max zoomed
                        main_font = DynamicTypeSize.xxLarge
                    } else if (x == 414 && y == 896) {
                        // MARK: iphone 11 standart / 11 Pro max standart/ iphone Xr standart
                        main_font = DynamicTypeSize.xLarge
                    } else if (x == 375 && y == 667) {
                        // MARK: iphone 8 (SE3) standart
                        main_font = DynamicTypeSize.xLarge
                    } else if (x == 320 && y == 568) {
                        // MARK: iphone 8 (SE3) zoomed
                        main_font = DynamicTypeSize.small
                    } else if (x == 414 && y == 736) {
                        // MARK: iphone 8 Plus standart
                        main_font = DynamicTypeSize.xxLarge
                    } else if (x == 375 && y == 667) {
                        // MARK: iphone 8 Plus zoomed
                        main_font = DynamicTypeSize.xLarge
                    } else if (x < 320 || y < 568) {
                        main_font = DynamicTypeSize.medium
                    }
                })
        }
    }
    init(){
        Thread.sleep(forTimeInterval: 0.20)
    }
}
