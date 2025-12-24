import SwiftUI

class SettingsViewModel: ObservableObject {
    @ObservedObject private var soundManager = SoundManager.shared
    
    @Published var isMusicOn: Bool {
        didSet {
            UserDefaults.standard.set(isMusicOn, forKey: "isMusicOn")
            soundManager.toggleMusic()
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    @Published var isSoundOn: Bool {
        didSet {
            UserDefaults.standard.set(isSoundOn, forKey: "isSoundOn")
            NotificationCenter.default.post(name: Notification.Name("UserResourcesUpdated"), object: nil)
        }
    }
    
    init() {
        self.isMusicOn = UserDefaults.standard.bool(forKey: "isMusicOn")
        self.isSoundOn = UserDefaults.standard.bool(forKey: "isSoundOn")
    }
}
