import SwiftUI

class AztecViewModel: ObservableObject {
    let contact = AztecModel()
    @Published var slots: [[String]] = []
    @Published var coin =   UserDefaultsManager.shared.coins
    @Published var bet = 500
    let allFruits = ["az1", "az2", "az3","az4", "az5", "az6"]
    @Published var winningPositions: [(row: Int, col: Int)] = []
    @Published var isSpinning = false
    @Published var isStopSpininng = false
    @Published var isWin = false
    @Published var win = 0
    var spinningTimer: Timer?
    @ObservedObject private var soundManager = SoundManager.shared
    @Published var maxBet = 0
    
    init() {
        resetSlots()
        updateMaxBet()
    }
    
    func updateMaxBet() {
        maxBet = coin
    }

    func maxBetAction() {
        bet = maxBet
    }
    @Published var betString: String = "5" {
        didSet {
            if let newBet = Int(betString), newBet > 0 {
                bet = newBet
            }
        }
    }
    let symbolArray = [
        Symbol(image: "az1", value: "200"),
        Symbol(image: "az2", value: "200"),
        Symbol(image: "az3", value: "200"),
        Symbol(image: "az4", value: "100"),
        Symbol(image: "az5", value: "100"),
        Symbol(image: "az6", value: "100")
    ]
    
    func resetSlots() {
        slots = (0..<3).map { _ in
            (0..<5).map { _ in
                allFruits.randomElement()!
            }
        }
    }
    
    func spin() {
        UserDefaultsManager.shared.incrementAchievement("slotSpins") 
        UserDefaultsManager.shared.removeCoins(bet)
        coin =  UserDefaultsManager.shared.coins
        isSpinning = true
        soundManager.playSlot1()
        spinningTimer?.invalidate()
        winningPositions.removeAll()
        win = 0
        let columns = 5
        for col in 0..<columns {
            let delay = Double(col) * 0.4
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                var spinCount = 0
                let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                    for row in 0..<3 {
                        withAnimation(.spring(response: 0.1, dampingFraction: 1.5, blendDuration: 0)) {
                            self.slots[row][col] = self.allFruits.randomElement()!
                        }
                    }
                    spinCount += 1
                    if spinCount > 12 + col * 4 {
                        timer.invalidate()
                        if col == columns - 1 {
                            self.isSpinning = false
                            self.soundManager.stopSlot()
                            self.checkWin()
                        }
                    }
                }
                RunLoop.current.add(timer, forMode: .common)
            }
        }
    }
    
    func checkWin() {
        winningPositions = []
        var totalWin = 0
        var maxMultiplier = 0
        let minCounts = [
            "az1": 5,
            "az2": 5,
            "az3": 5,
            "az4": 5,
            "az5": 5,
            "az6": 5
        ]
        let multipliers = [
            "az1": 200,
            "az2": 200,
            "az3": 200,
            "az4": 100,
            "az5": 100,
            "az6": 100
        ]
        
        checkRows(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        checkMainDiagonal(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        checkAntiDiagonal(minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
        
        if totalWin != 0 {
            win = totalWin
            isWin = true
            UserDefaultsManager.shared.incrementAchievement("singleSpinWin", by: totalWin)
            UserDefaultsManager.shared.incrementAchievement("totalCoinsWon", by: totalWin)
            UserDefaultsManager.shared.addCoins(totalWin)
            coin = UserDefaultsManager.shared.coins
        }
    }

    private func checkMainDiagonal(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        let diagonal = [slots[0][0], slots[1][1], slots[2][2]]
        checkLine(diagonal: diagonal, positions: [(0,0), (1,1), (2,2)], minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
    }

    private func checkAntiDiagonal(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        let diagonal = [slots[0][2], slots[1][1], slots[2][0]]
        checkLine(diagonal: diagonal, positions: [(0,2), (1,1), (2,0)], minCounts: minCounts, multipliers: multipliers, totalWin: &totalWin, maxMultiplier: &maxMultiplier)
    }

    private func checkLine(diagonal: [String], positions: [(row: Int, col: Int)], minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        var currentSymbol = diagonal[0]
        var count = 1
        
        for i in 1..<diagonal.count {
            if diagonal[i] == currentSymbol {
                count += 1
            } else {
                if let minCount = minCounts[currentSymbol], count >= minCount {
                    let multiplierValue = multipliers[currentSymbol] ?? 0
                    totalWin += multiplierValue
                    if multiplierValue > maxMultiplier {
                        maxMultiplier = multiplierValue
                    }
                    let startIndex = i - count
                    for j in startIndex..<i {
                        winningPositions.append(positions[j])
                    }
                }
                currentSymbol = diagonal[i]
                count = 1
            }
        }
        
        if let minCount = minCounts[currentSymbol], count >= minCount {
            let multiplierValue = multipliers[currentSymbol] ?? 0
            totalWin += multiplierValue
            if multiplierValue > maxMultiplier {
                maxMultiplier = multiplierValue
            }
            let startIndex = diagonal.count - count
            for j in startIndex..<diagonal.count {
                winningPositions.append(positions[j])
            }
        }
    }

    private func checkRows(minCounts: [String: Int], multipliers: [String: Int], totalWin: inout Int, maxMultiplier: inout Int) {
        for row in 0..<3 {
            let rowContent = slots[row]
            var currentSymbol = rowContent[0]
            var count = 1
            
            for col in 1..<rowContent.count {
                if rowContent[col] == currentSymbol {
                    count += 1
                } else {
                    if let minCount = minCounts[currentSymbol], count >= minCount {
                        let multiplierValue = multipliers[currentSymbol] ?? 0
                        totalWin += multiplierValue
                        if multiplierValue > maxMultiplier {
                            maxMultiplier = multiplierValue
                        }
                        let startCol = col - count
                        for c in startCol..<col {
                            winningPositions.append((row: row, col: c))
                        }
                    }
                    currentSymbol = rowContent[col]
                    count = 1
                }
            }
            
            if let minCount = minCounts[currentSymbol], count >= minCount {
                let multiplierValue = multipliers[currentSymbol] ?? 0
                totalWin += multiplierValue
                if multiplierValue > maxMultiplier {
                    maxMultiplier = multiplierValue
                }
                let startCol = rowContent.count - count
                for c in startCol..<rowContent.count {
                    winningPositions.append((row: row, col: c))
                }
            }
        }
    }
}



