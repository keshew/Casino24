import SwiftUI

class MinesViewModel: ObservableObject {
    let contact = MinesModel()
    @Published var coin = UserDefaultsManager.shared.coins
    @Published var bet: Int = 250
    @Published var lastWin: Int = 0
    
    @Published var openedCount = 0
    @Published var gameStarted = false
    @Published var currentMultiplier = 1.0
    @Published var isAnimating = false
    
    var currentWin: Int {
        Int(bet * Int(currentMultiplier))
    }
    
    @Published var cards: [CardState] = Array(repeating: CardState(isOpen: false, symbol: nil), count: 25)
    
    enum CardSymbol: String, CaseIterable {
        case bomb, coinses
        
        var imageName: String {
            rawValue
        }
        
        var isVolcan: Bool {
            self == .bomb
        }
        
        var backgroundColors: [Color] {
            if isVolcan {
                return [
                    Color(red: 255/255, green: 9/255, blue: 1/255),
                    Color(red: 124/255, green: 33/255, blue: 11/255)
                ]
            } else {
                return [
                    Color(red: 3/255, green: 255/255, blue: 18/255),
                    Color(red: 10/255, green: 124/255, blue: 18/255)
                ]
            }
        }
    }
    
    struct CardState {
        var isOpen: Bool
        var symbol: CardSymbol?
    }
    
    func startGame() {
        guard !gameStarted, bet <= coin else { return }
        UserDefaultsManager.shared.incrementAchievement("fastGamePlays")
        UserDefaultsManager.shared.removeCoins(bet)
        coin = UserDefaultsManager.shared.coins
        
        gameStarted = true
        openedCount = 0
        currentMultiplier = 1.0
        isAnimating = false
        resetCards()
    }
    
    func withdraw() {
        guard gameStarted else { return }
        
        let winAmount = Int(Double(bet) * currentMultiplier)
        UserDefaultsManager.shared.addCoins(winAmount)
        coin = UserDefaultsManager.shared.coins
        
        lastWin = winAmount
        UserDefaultsManager.shared.incrementAchievement("singleSpinWin", by: winAmount)
        UserDefaultsManager.shared.incrementAchievement("totalCoinsWon", by: winAmount)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.resetGame()
        }
    }
    
    func selectCard(at index: Int) {
        guard gameStarted,
              !cards[index].isOpen,
              openedCount < 8,
              !isAnimating else { return }
        
        isAnimating = true
        
        let isVolcan = Double.random(in: 0...1) < 0.5
        let randomSymbol: CardSymbol = isVolcan ? .bomb : CardSymbol.allCases.filter { !$0.isVolcan }.randomElement()!
        
        cards[index].isOpen = true
        cards[index].symbol = randomSymbol
        openedCount += 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.handleCardResult(symbol: randomSymbol)
        }
    }
    
    private func handleCardResult(symbol: CardSymbol) {
        if symbol.isVolcan {
            finishGameWithLoss()
        } else {
            currentMultiplier *= 1.5
        }
        isAnimating = false
    }
    
    private func finishGameWithWin() {
        let winAmount = Int(Double(bet) * currentMultiplier)
        UserDefaultsManager.shared.addCoins(winAmount)
        coin = UserDefaultsManager.shared.coins
        UserDefaultsManager.shared.recordWin(winAmount)
        lastWin = winAmount
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.resetGame()
        }
    }
    
    private func finishGameWithLoss() {
        lastWin = 0
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.resetGame()
        }
    }
    
    private func resetGame() {
        cards = Array(repeating: CardState(isOpen: false, symbol: nil), count: 25)
        openedCount = 0
        gameStarted = false
        currentMultiplier = 1.0
        isAnimating = false
    }
    
    private func resetCards() {
        cards = Array(repeating: CardState(isOpen: false, symbol: nil), count: 25)
    }
}
