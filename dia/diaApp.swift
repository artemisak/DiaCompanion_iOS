import SwiftUI

@main
struct diaApp: App {
    @State private var main_font = DynamicTypeSize.xLarge
    var body: some Scene {
        WindowGroup {
            if #available(iOS 16, *){
                startPage()
                    .dynamicTypeSize(.small ... .xLarge)
                    .accessibilityIgnoresInvertColors(true)
                    .environment(\.defaultMinListRowHeight, 55)
                    .scrollDismissesKeyboard(.immediately)
                    .scrollIndicators(.hidden)
//                    .onAppear {
//                        do {
//                            _ = try predictManager.provider.getPredict(meal_type_n: 2, gi: 42.3, gl: 28.4, carbo: 34.0, carbo_b6h: 42.0, prot_b6h: 43.9, fat_b6h: 45.3, BG: 7.5, BMI: 26.026, HbA1C_V1: 5.4, TG_V1: 2.21, Hol_V1: 6.03, fasting_glu: 5.37, pregnancy_week: 25.0)
//                        } catch {
//                            print(error)
//                        }
//                    }
            } else {
                startPage()
                    .dynamicTypeSize(.small ... .xLarge)
                    .accessibilityIgnoresInvertColors(true)
                    .environment(\.defaultMinListRowHeight, 55)
                    .onAppear {
                        UIScrollView.appearance().keyboardDismissMode = .onDrag
                        UITableView.appearance().showsVerticalScrollIndicator = false
                    }
                    
            }
        }
    }
}

// MARK: diffrent types of DynamicTypeSize objects
//.onAppear {
//    let x = UIScreen.main.bounds.size.width
//    let y = UIScreen.main.bounds.size.height
//    if (x == 375 && y == 812) {
//        // MARK: iphone 12(13) mini standart / 12(13) Pro Max zoomed
//        main_font = DynamicTypeSize.xLarge
//    } else if (x == 320 && y == 693) {
//        // MARK: iphone 12(13) zoomed / 12(13) mini zoomed
//        main_font = DynamicTypeSize.medium
//    } else if (x == 390 && y == 844) {
//        // MARK: iphone 12(13) standart
//        main_font = DynamicTypeSize.xLarge
//    } else if (x == 428 && y == 926) {
//        // MARK: iphone 12(13) Pro Max
//        main_font = DynamicTypeSize.xxLarge
//    } else if (x == 375 && y == 812) {
//        // MARK: iphone 11 zoomed / 11 Pro Max zoomed
//        main_font = DynamicTypeSize.xxLarge
//    } else if (x == 414 && y == 896) {
//        // MARK: iphone 11 standart / 11 Pro max standart/ iphone Xr standart
//        main_font = DynamicTypeSize.xLarge
//    } else if (x == 375 && y == 667) {
//        // MARK: iphone 8 (SE3) standart
//        main_font = DynamicTypeSize.xLarge
//    } else if (x == 320 && y == 568) {
//        // MARK: iphone 8 (SE3) zoomed
//        main_font = DynamicTypeSize.small
//    } else if (x == 414 && y == 736) {
//        // MARK: iphone 8 Plus standart
//        main_font = DynamicTypeSize.xxLarge
//    } else if (x == 375 && y == 667) {
//        // MARK: iphone 8 Plus zoomed
//        main_font = DynamicTypeSize.xLarge
//    } else if (x < 320 || y < 568) {
//        main_font = DynamicTypeSize.medium
//    }
//}
