import SwiftUI

class UserDefaultsManager: ObservableObject {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    private let achievementsKey = "achievements"
    private let missionsKey = "missions"
    
    var coins: Int {
        get { defaults.integer(forKey: "coins") }
        set { defaults.set(newValue, forKey: "coins") }
    }
    
    func addCoins(_ amount: Int) {
        coins += amount
    }
    
    func removeCoins(_ amount: Int) {
        coins = max(coins - amount, 0)
    }
    
    @Published var firstSpinCompleted = false {
        didSet { defaults.set(firstSpinCompleted, forKey: "firstSpinCompleted") }
    }
    
    @Published var consecutiveWins = 0 {
        didSet { defaults.set(consecutiveWins, forKey: "consecutiveWins") }
    }
    
    @Published var singleSpinMaxWin = 0 {
        didSet { defaults.set(singleSpinMaxWin, forKey: "singleSpinMaxWin") }
    }
    
    @Published var slotsPlayed = 0 {
        didSet { defaults.set(slotsPlayed, forKey: "slotsPlayed") }
    }
    
    @Published var maxBetCount = 0 {
        didSet { defaults.set(maxBetCount, forKey: "maxBetCount") }
    }
    
    @Published var totalSpins = 0 {
        didSet { defaults.set(totalSpins, forKey: "totalSpins") }
    }
    
    @Published var currentXP: Int = 0 {
        didSet {
            defaults.set(currentXP, forKey: "currentXP")
            checkLevelUp()
        }
    }
    
    @Published var profileImageName: String = "profileImg1" {
        didSet {
            defaults.set(profileImageName, forKey: "profileImageName")
        }
    }
    
    @Published var currentLevel: Int = 1 {
        didSet {
            defaults.set(currentLevel, forKey: "currentLevel")
        }
    }
    
    @Published var minesRevealed: Int = 0 {
        didSet { defaults.set(minesRevealed, forKey: "minesRevealed") }
    }
    
    @Published var coinFlipsWon: Int = 0 {
        didSet { defaults.set(coinFlipsWon, forKey: "coinFlipsWon") }
    }
    
    @Published var crashCashouts5x: Int = 0 {
        didSet { defaults.set(crashCashouts5x, forKey: "crashCashouts5x") }
    }
    
    @Published var totalGamesPlayed: Int = 0 {
        didSet { defaults.set(totalGamesPlayed, forKey: "totalGamesPlayed") }
    }
    
    @Published var maxBetAmount: Int = 0 {
        didSet { defaults.set(maxBetAmount, forKey: "maxBetAmount") }
    }
    
    @Published var maxMultiplierWon: Double = 0 {
        didSet { defaults.set(maxMultiplierWon, forKey: "maxMultiplierWon") }
    }
    
    @Published var fruitSlotsWins: Int = 0 {
        didSet { defaults.set(fruitSlotsWins, forKey: "fruitSlotsWins") }
    }
    
    @Published var classicSlotsWins: Int = 0 {
        didSet { defaults.set(classicSlotsWins, forKey: "classicSlotsWins") }
    }
    
    @Published var goldSlotsWins: Int = 0 {
        didSet { defaults.set(goldSlotsWins, forKey: "goldSlotsWins") }
    }
    
    @Published var achievementsData: [String: Int] = [:] {
        didSet {
            defaults.set(try? JSONEncoder().encode(achievementsData), forKey: "achievementsData")
            checkAchievementsCompletion()
        }
    }

    private func checkAchievementsCompletion() {
        let achievementConfigs: [(key: String, goal: Int, reward: Int)] = [
            ("fastGamePlays", 1000, 800),
            ("singleSpinWin", 5000, 600),
            ("totalCoinsWon", 30000, 500),
            ("slotSpins", 100, 200)
        ]
        
        for config in achievementConfigs {
            if achievementsData[config.key, default: 0] >= config.goal &&
               !defaults.bool(forKey: "achievement_\(config.key)_claimed") {
                defaults.set(true, forKey: "achievement_\(config.key)_claimed")
                addCoins(config.reward)
                print("🎉 Achievement \(config.key) completed! +\(config.reward) coins")
            }
        }
    }
    
    func incrementAchievement(_ key: String, by amount: Int = 1) {
        achievementsData[key, default: 0] += amount
        objectWillChange.send()
    }

    func getAchievementProgress(_ key: String) -> Int {
        achievementsData[key, default: 0]
    }
    
    func loadAchievementsData() {
        if let data = defaults.data(forKey: "achievementsData"),
           let decoded = try? JSONDecoder().decode([String: Int].self, from: data) {
            achievementsData = decoded
        }
    }
    
    @Published var totalWins: Int = 0 {
        didSet { defaults.set(totalWins, forKey: "totalWins") }
    }
    
    @Published var totalCoinsWon: Int = 0 {
        didSet { defaults.set(totalCoinsWon, forKey: "totalCoinsWon") }
    }
    
    private init() {
        loadAllData()
        loadAchievementsData()
    }
    
    private func loadAllData() {
        firstSpinCompleted = defaults.bool(forKey: "firstSpinCompleted")
        consecutiveWins = defaults.integer(forKey: "consecutiveWins")
        singleSpinMaxWin = defaults.integer(forKey: "singleSpinMaxWin")
        slotsPlayed = defaults.integer(forKey: "slotsPlayed")
        maxBetCount = defaults.integer(forKey: "maxBetCount")
        totalSpins = defaults.integer(forKey: "totalSpins")
        coins = defaults.integer(forKey: "coins")
        
        let savedLevel = defaults.integer(forKey: "currentLevel")
        currentLevel = savedLevel > 0 ? savedLevel : 1
        
        if let savedProfileImg = defaults.string(forKey: "profileImageName") {
            profileImageName = savedProfileImg
        } else {
            profileImageName = "profileImg1"
        }
        
        currentXP = defaults.integer(forKey: "currentXP")
        minesRevealed = defaults.integer(forKey: "minesRevealed")
        coinFlipsWon = defaults.integer(forKey: "coinFlipsWon")
        crashCashouts5x = defaults.integer(forKey: "crashCashouts5x")
        totalGamesPlayed = defaults.integer(forKey: "totalGamesPlayed")
        maxBetAmount = defaults.integer(forKey: "maxBetAmount")
        
        if let multiplier = defaults.value(forKey: "maxMultiplierWon") as? Double {
            maxMultiplierWon = multiplier
        }
        
        fruitSlotsWins = defaults.integer(forKey: "fruitSlotsWins")
        classicSlotsWins = defaults.integer(forKey: "classicSlotsWins")
        goldSlotsWins = defaults.integer(forKey: "goldSlotsWins")
        totalWins = defaults.integer(forKey: "totalWins")
        totalCoinsWon = defaults.integer(forKey: "totalCoinsWon")
    }
    
    func addXP(_ amount: Int) {
        currentXP += amount
    }
    
    func playGame() {
        addXP(10)
    }
    
    private func checkLevelUp() {
        while currentXP >= currentLevel * 1000 {
            currentLevel += 1
            print("🎉 Level Up! Now level \(currentLevel)")
        }
    }
    
    var xpProgress: Double {
        let xpForCurrentLevel = (currentLevel - 1) * 1000
        let xpNeededForNextLevel = currentLevel * 1000
        let progress = Double(currentXP - xpForCurrentLevel) / Double(xpNeededForNextLevel - xpForCurrentLevel)
        return min(progress, 1.0)
    }
    
    var xpToNextLevel: Int {
        currentLevel * 1000 - currentXP
    }
    
    func completeFirstSpin() {
        if !firstSpinCompleted {
            firstSpinCompleted = true
        }
    }
    
    func addConsecutiveWin() {
        consecutiveWins += 1
    }
    
    func resetConsecutiveWins() {
        consecutiveWins = 0
    }
    
    func updateSingleSpinWin(_ amount: Int) {
        if amount > singleSpinMaxWin {
            singleSpinMaxWin = amount
        }
    }
    
    func playSlotGame() {
        slotsPlayed += 1
    }
    
    func placeMaxBet() {
        maxBetCount += 1
    }
    
    func completeSpin() {
        totalSpins += 1
    }
    
    func recordWin(_ winAmount: Int) {
        totalWins += 1
        totalCoinsWon += winAmount
    }
    
    func resetAllData() {
        coins = 0
        firstSpinCompleted = false
        consecutiveWins = 0
        singleSpinMaxWin = 0
        slotsPlayed = 0
        maxBetCount = 0
        totalSpins = 0
        currentXP = 0
        profileImageName = "profileImg1"
        currentLevel = 1
        minesRevealed = 0
        coinFlipsWon = 0
        crashCashouts5x = 0
        totalGamesPlayed = 0
        maxBetAmount = 0
        maxMultiplierWon = 0
        fruitSlotsWins = 0
        classicSlotsWins = 0
        goldSlotsWins = 0
        totalWins = 0
        totalCoinsWon = 0
        
        addCoins(5000)
        
        let keysToRemove = [
            "coins", "firstSpinCompleted", "consecutiveWins", "singleSpinMaxWin",
            "slotsPlayed", "maxBetCount", "totalSpins", "currentXP",
            "profileImageName", "currentLevel", "minesRevealed", "coinFlipsWon",
            "crashCashouts5x", "totalGamesPlayed", "maxBetAmount", "maxMultiplierWon",
            "fruitSlotsWins", "classicSlotsWins", "goldSlotsWins", "totalWins",
            "totalCoinsWon"
        ]
        
        for key in keysToRemove {
            defaults.removeObject(forKey: key)
        }
        
        defaults.removeObject(forKey: achievementsKey)
        defaults.removeObject(forKey: missionsKey)
    }
}
