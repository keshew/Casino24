import SwiftUI

class AviaViewModel: ObservableObject {
    let contact = AviaModel()
    @Published var coin: Int = UserDefaultsManager.shared.coins
     @Published var bet: Int = 200
     @Published var reward: Int = 0
     @Published var isPlaying: Bool = false
     @Published var planeRotation: Double = 0
     @Published var planePositionX: CGFloat = -130
     @ObservedObject private var soundManager = SoundManager.shared
     
     private var fallWorkItem: DispatchWorkItem?
     private var rewardTimer: Timer?
     
     func startGame() {
         guard !isPlaying else { return }
         guard bet <= coin, bet >= 50 else { return }
         soundManager.playWrong()
         isPlaying = true
         reward = 0
         UserDefaultsManager.shared.removeCoins(bet)
         coin = UserDefaultsManager.shared.coins

         planeRotation = 0
         planePositionX = -130

         withAnimation(.linear(duration: 3)) {
             planePositionX = 150
         }

         startRewardIncrement()

         fallWorkItem?.cancel()

         let fallItem = DispatchWorkItem { [weak self] in
             guard let self = self else { return }
             self.stopRewardIncrement()

             withAnimation(.linear(duration: 2)) {
                 self.planeRotation = 45
                 self.planePositionX = 300
             }

             DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                 self.reward = 0
                 self.isPlaying = false
                 self.resetPlanePosition()
                 self.soundManager.stopWrong()
             }
         }
         fallWorkItem = fallItem

         let randomDelay = Double.random(in: 1.0...5.0)
         DispatchQueue.main.asyncAfter(deadline: .now() + randomDelay, execute: fallItem)

     }

     func collectReward() {
         guard isPlaying else { return }
         self.soundManager.stopWrong()
         stopRewardIncrement()
         UserDefaultsManager.shared.addCoins(reward)
         coin = UserDefaultsManager.shared.coins
         reward = 0
         isPlaying = false
         resetPlanePosition()
         fallWorkItem?.cancel()
         fallWorkItem = nil
     }

     private func resetPlanePosition() {
         withAnimation(.easeOut(duration: 1)) {
             planeRotation = 0
             planePositionX = -130
         }
     }

     private func startRewardIncrement() {
         rewardTimer?.invalidate()
         rewardTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
             guard let self = self, self.isPlaying else { return }
             let increment = Int(Double(self.bet) * 0.1)
             self.reward = min(self.reward + increment, self.bet * 10)
         }
     }

     private func stopRewardIncrement() {
         rewardTimer?.invalidate()
         rewardTimer = nil
     }
 }
