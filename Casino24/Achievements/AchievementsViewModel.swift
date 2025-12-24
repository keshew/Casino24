import SwiftUI

class AchievementsViewModel: ObservableObject {
    @Published var achievements: [Achievements] = []
    private let manager = UserDefaultsManager.shared
    
    init() {
        loadAchievements()
    }
    
    private func loadAchievements() {
        achievements = [
            Achievements(name: "Stable", desc: "Play fast game 1000 times", image: "ach1",
                        goal: 1000, currentStep: manager.getAchievementProgress("fastGamePlays"), reward: 800),
            Achievements(name: "Lucky", desc: "Win 5,000 coins in 1 spin", image: "ach2",
                        goal: 5000, currentStep: manager.getAchievementProgress("singleSpinWin"), reward: 600),
            Achievements(name: "Experienced", desc: "Win 30,000 coins in total", image: "ach3",
                        goal: 30000, currentStep: manager.getAchievementProgress("totalCoinsWon"), reward: 500),
            Achievements(name: "Scroller", desc: "Spin 100 slot games", image: "ach4",
                        goal: 100, currentStep: manager.getAchievementProgress("slotSpins"), reward: 200)
        ]
    }
}
