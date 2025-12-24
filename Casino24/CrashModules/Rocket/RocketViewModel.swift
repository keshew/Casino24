import SwiftUI

class RocketViewModel: ObservableObject {
    let contact = RocketModel()
    @Published var coin: Int = UserDefaultsManager.shared.coins
     @Published var bet: Int = 200
     @Published var reward: Int = 0
    @Published var multiplierTextColor: Color = Color(red: 141/255, green: 1/255, blue: 198/255)
}
