import SwiftUI

@main
struct Casino24App: App {
    
    init() {
        let stats = UserDefaultsManager.shared
        let key = "didAddInitialCoins"
        if !UserDefaults.standard.bool(forKey: key) {
            stats.addCoins(5000)
            UserDefaults.standard.set("av1", forKey: "profileImageName")
            UserDefaults.standard.set(true, forKey: "isMusicOn")
            UserDefaults.standard.set(true, forKey: key)
        }
    }
    
    var body: some Scene {
        WindowGroup {
            LoadingView()
        }
    }
}
