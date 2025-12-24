import SwiftUI

class PlinkoViewModel: ObservableObject {
    let contact = PlinkoModel()
    func createGameScene(gameData: GameData) -> GameSpriteKit {
        let scene = GameSpriteKit()
        scene.game  = gameData
        return scene
    }
}
