import SpriteKit
import Combine
import SwiftUI

class GameData: ObservableObject {
    @Published var reward: Double = 0.0
    @Published var bet: Int = 300

    @Published var balance: Int = UserDefaultsManager.shared.coins
    @Published var isPlayTapped: Bool = false
    @Published var labels: [String] = ["1x", "1.5x", "2x", "5x", "10x", "5x", "2x", "1.5x", "1x"]
    
    var createBallPublisher = PassthroughSubject<Void, Never>()
    
    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: balance)) ?? "\(balance)"
    }
    
    
    func decreaseBet() {
        if bet - 100 >= 100 {
            bet -= 100
        }
    }
    func increaseBet() {
        let newBet = bet + 100
        if newBet <= balance {
            bet = newBet
        }
    }
    
    
    func dropBalls() {
        guard bet <= balance else {
            return
        }
        UserDefaultsManager.shared.playGame()
        let _ = UserDefaultsManager.shared.removeCoins(bet)
        UserDefaultsManager.shared.playGame()
        balance = UserDefaultsManager.shared.coins
        reward = 0.0
        isPlayTapped = true
        createBallPublisher.send(())
    }
    
    func resetGame() {
        bet = 300
        reward = 0
        isPlayTapped = false
    }
    
    func addWin(_ amount: Double) {
        reward += amount
    }
    
    func finishGame() {
        UserDefaultsManager.shared.addCoins(Int(reward))
        balance = UserDefaultsManager.shared.coins
        reward = 0
        isPlayTapped = false
    }
}

class GameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: GameData? {
        didSet {
        }
    }
    
    let ballCategory: UInt32 = 0x1 << 0
    let obstacleCategory: UInt32 = 0x1 << 1
    let ticketCategory: UInt32 = 0x1 << 2
    
    var ballsInPlay: Int = 0
    var ballNodes: [SKSpriteNode] = []
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        size = UIScreen.main.bounds.size
        backgroundColor = .clear
        
        createObstacles()
        createTickets()
        createInitialBalls()
        
        game?.createBallPublisher.sink { [weak self] in
            self?.launchBalls()
        }.store(in: &cancellables)
    }
    
    var cancellables = Set<AnyCancellable>()
    
    override func update(_ currentTime: TimeInterval) {
        super.update(currentTime)
        
        for (index, ball) in ballNodes.enumerated().reversed() {
            if ball.position.y < 0 || ball.position.x < 0 || ball.position.x > size.width {
                ball.removeFromParent()
                ballNodes.remove(at: index)
                ballsInPlay -= 1
                createBall(atIndex: index)
            }
        }
    }
    
    func createObstacles() {
        let numberOfRows = size.width > 700 ? 7 : 7
        let obstacleSize = CGSize(width: size.width > 700 ? 30 : 10, height: size.width > 700 ? 40 : 19)
        let horizontalSpacing: CGFloat = size.width > 700 ? 90 : 25
        let verticalSpacing: CGFloat = size.width > 700 ? 105 : 65

        for row in 0..<numberOfRows {
            let countInRow = 3 + row
            let totalWidth = CGFloat(countInRow) * (obstacleSize.width + horizontalSpacing) - horizontalSpacing
            let xOffset = (size.width - totalWidth) / 2 + obstacleSize.width / 2
            
            let baseY = size.width > 700 ? size.height / 1.35 : size.height / 1.32
            let yPosition = baseY - CGFloat(row) * (obstacleSize.height + verticalSpacing)
            
            for col in 0..<countInRow {
                let obstacle = SKSpriteNode(imageNamed: "obstacle")
                obstacle.size = obstacleSize
                let xPosition = xOffset + CGFloat(col) * (obstacleSize.width + horizontalSpacing)
                obstacle.position = CGPoint(x: xPosition, y: yPosition)
                
                obstacle.physicsBody = SKPhysicsBody(circleOfRadius: obstacleSize.width / 2.0)
                obstacle.physicsBody?.isDynamic = false
                obstacle.physicsBody?.categoryBitMask = obstacleCategory
                obstacle.physicsBody?.contactTestBitMask = ballCategory
                
                addChild(obstacle)
            }
        }
    }
    
    func createTickets() {
        guard let game = self.game else { return }
        let labels = game.labels
        let count = labels.count
        let ticketWidth: CGFloat = size.width > 700 ? 100 : 32
        let horizontalSpacing: CGFloat = 10
        let totalWidth = CGFloat(count) * (ticketWidth + horizontalSpacing) - horizontalSpacing
        let xOffset = (size.width - totalWidth) / 2 + ticketWidth / 2
        let yPosition = (size.width > 700 ? size.height / 27.5 : size.height / 17.5)

        for i in 0..<count {
            let label = SKLabelNode(text: labels[i])
            label.fontName = "PaytoneOne-Regular"
            label.fontSize = size.width > 700 ? 34 : 21
            label.fontColor = UIColor(red: 253/255, green: 255/255, blue: 193/255, alpha: 1)
            label.verticalAlignmentMode = .center
            label.horizontalAlignmentMode = .center
            label.position = CGPoint(x: 0, y: 0)
            label.xScale = size.width > 700 ? 1.0 : 0.7
            label.yScale = 1
            label.name = "ticket_\(i)"


            let backgroundSize = CGSize(width: ticketWidth + 10, height: label.frame.height + (size.width > 700 ? 40 : 25))
            let backgroundNode = SKShapeNode(rectOf: backgroundSize, cornerRadius: 3)
            let turquoiseColor = UIColor(red: 35/255, green: 212/255, blue: 238/255, alpha: 1.0)
            backgroundNode.fillColor = .clear
            backgroundNode.strokeColor = turquoiseColor
            backgroundNode.lineWidth = 2.0
            backgroundNode.position = CGPoint(x: xOffset + CGFloat(i) * (ticketWidth + horizontalSpacing), y: yPosition)
            backgroundNode.zPosition = label.zPosition - 1

            backgroundNode.physicsBody = SKPhysicsBody(rectangleOf: backgroundSize)
            backgroundNode.physicsBody?.isDynamic = false
            backgroundNode.physicsBody?.categoryBitMask = ticketCategory
            backgroundNode.physicsBody?.contactTestBitMask = ballCategory

            backgroundNode.addChild(label)

            addChild(backgroundNode)
        }
    }
    
    func createInitialBalls() {
        ballNodes.forEach { $0.removeFromParent() }
        ballNodes.removeAll()
        ballsInPlay = 0
        
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: size.width > 700 ? 35 : 13, height: size.width > 700 ? 52 : 26)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let game = game else { return }
        
        let ballCategory = self.ballCategory
        let ticketCategory = self.ticketCategory
        
        var ballNode: SKNode?
        var ticketNode: SKNode?
        
        if contact.bodyA.categoryBitMask == ballCategory {
            ballNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ballCategory {
            ballNode = contact.bodyB.node
        }
        
        if contact.bodyA.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyA.node
        } else if contact.bodyB.categoryBitMask == ticketCategory {
            ticketNode = contact.bodyB.node
        }
        
        guard let ball = ballNode as? SKSpriteNode,
              let ticketBackground = ticketNode as? SKShapeNode else {
            return
        }
        
        guard let ticketLabel = ticketBackground.children.compactMap({ $0 as? SKLabelNode }).first(where: {
            $0.name?.starts(with: "ticket_") == true
        }) else {
            print("Ticket label not found as child of ticket background node")
            return
        }
        
        guard let multiplier = parseMultiplier(from: ticketLabel.text) else {
            print("Failed to parse multiplier from label \(ticketLabel.text ?? "")")
            return
        }
        
        let win = Double(game.bet) * multiplier
        game.addWin(win)
        UserDefaultsManager.shared.incrementAchievement("totalCoinsWon", by: Int(win))
        UserDefaultsManager.shared.incrementAchievement("singleSpinWin", by: Int(win))
        
        ball.removeFromParent()
        if let index = ballNodes.firstIndex(of: ball) {
            ballNodes.remove(at: index)
        }
        
        ballsInPlay -= 1
        
        createBall(atIndex: 0)
        
        checkBallsStopped()
    }
    
    func createBall(atIndex index: Int) {
        let ball = SKSpriteNode(imageNamed: "ball")
        ball.size = CGSize(width: size.width > 700 ? 35 : 13, height: size.width > 700 ? 52 : 26)
        ball.position = CGPoint(x: size.width / 2,
                                y: size.height / 1.15)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 3)
        ball.physicsBody?.restitution = 0.0
        ball.physicsBody?.friction = 0.0
        ball.physicsBody?.linearDamping = 0.0
        ball.physicsBody?.allowsRotation = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = ballCategory
        ball.physicsBody?.contactTestBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.collisionBitMask = obstacleCategory | ticketCategory
        ball.physicsBody?.isDynamic = true
        
        addChild(ball)
        ballNodes.append(ball)
        ballsInPlay += 1
    }
    
    func launchBalls() {
        for (_, ball) in ballNodes.enumerated() {
            UserDefaultsManager.shared.incrementAchievement("fastGamePlays")
            ball.physicsBody?.affectedByGravity = true
            
            let randomXImpulse = CGFloat.random(in: -0.01...0.01)
            
            ball.physicsBody?.applyImpulse(CGVector(dx: randomXImpulse, dy: 0))
        }
    }
    
    private func parseMultiplier(from text: String?) -> Double? {
        guard let text = text?.lowercased().replacingOccurrences(of: "x", with: "") else { return nil }
        return Double(text)
    }
    
    private func checkBallsStopped() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self = self, let game = self.game else { return }
            let movingBalls = self.ballNodes.filter {
                guard let body = $0.physicsBody else { return false }
                return body.velocity.dx > 5 || body.velocity.dy > 5
            }
            if movingBalls.isEmpty && game.isPlayTapped {
                game.finishGame()
            }
        }
    }
}

struct PlinkoView: View {
    @StateObject var viewModel =  PlinkoViewModel()
    @Environment(\.presentationMode) var presentationMode
    @StateObject var gameModel = GameData()
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("bgplink")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Image("plink")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 140)
                        .clipped()
                    
                    Rectangle()
                        .fill(Color(red: 46/255, green: 41/255, blue: 41/255))
                        .frame(height: 140)
                        .opacity(0.8)
                    
                    Rectangle()
                        .fill(Color(red: 232/255, green: 186/255, blue: 186/255).opacity(0.2))
                        .frame(height: 1)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 17) {
                HStack {
                    HStack {
                        Button(action: {
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .offset(y: 1)
                        }
                        
                        Text("Plinko")
                            .font(.custom("PaytoneOne-Regular", size: 22))
                            .foregroundStyle(.white)
                    }
                    
                    Spacer()
                    
                    Rectangle()
                        .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.8))
                        .overlay {
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color(red: 232/255, green: 186/255, blue: 186/255), lineWidth: 1)
                                .overlay {
                                    HStack {
                                        Image("coin")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                        
                                        Text("\(gameModel.balance)")
                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                            .foregroundStyle(.white)
                                    }
                                }
                        }
                        .frame(width: 110, height: 45)
                        .cornerRadius(12)
                }
                .padding(.horizontal, 20)
                .padding(.top, UIScreen.main.bounds.width > 700 ? 50 : 15)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        ZStack {
                            Image("plink")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 128, height: 48)
                                .cornerRadius(16)
                                .clipped()
                            
                            Rectangle()
                                .fill(Color(red: 46/255, green: 41/255, blue: 41/255))
                                .frame(width: 128, height: 48)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white)
                                        .overlay {
                                            VStack {
                                                Text("Win:")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white)
                                                
                                                Text("\(Int(gameModel.reward))")
                                                    .font(.custom("PaytoneOne-Regular", size: 14))
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                }
                                .cornerRadius(16)
                                .opacity(0.8)
                        }
                        .padding(.top)
                        
                        Rectangle()
                            .fill(.black.opacity(0.6))
                            .overlay {
                                SpriteView(scene: viewModel.createGameScene(gameData: gameModel), options: [.allowsTransparency])
                                    .frame(width: UIScreen.main.bounds.width > 700 ? 450 : 310, height: UIScreen.main.bounds.width > 700 ? 400 : 300)
                            }
                            .frame(width: UIScreen.main.bounds.width > 700 ? 570 : 320, height: UIScreen.main.bounds.width > 700 ? 500 : 310)
                            .cornerRadius(12)
                            .offset(y: 2)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                gameModel.decreaseBet()
                            }) {
                                Circle()
                                    .fill(Color(red: 148/255, green: 59/255, blue: 255/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.white, lineWidth: 2)
                                            .overlay {
                                                Text("-")
                                                    .font(.custom("PaytoneOne-Regular", size: 20))
                                                    .foregroundStyle(.white)
                                                    .offset(y: -3)
                                            }
                                    }
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                            }
                            
                            Rectangle()
                                .fill(Color(red: 148/255, green: 59/255, blue: 255/255))
                                .frame(width: 112, height: 42)
                                .overlay {
                                    Text("BET: \(gameModel.bet)")
                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                        .foregroundStyle(.white)
                                }
                                .cornerRadius(12)
                            
                            Button(action: {
                                gameModel.increaseBet()
                            }) {
                                Circle()
                                    .fill(Color(red: 148/255, green: 59/255, blue: 255/255))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 15)
                                            .stroke(.white, lineWidth: 2)
                                            .overlay {
                                                Text("+")
                                                    .font(.custom("PaytoneOne-Regular", size: 20))
                                                    .foregroundStyle(.white)
                                                    .offset(y: -3)
                                            }
                                    }
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                            }
                        }
                        
                        Button(action: {
                            withAnimation {
                                gameModel.dropBalls()
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 148/255, green: 59/255, blue: 255/255))
                                .frame(width: 112, height: 42)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(.white, lineWidth: 3)
                                        .overlay {
                                            Text("Play")
                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                .foregroundStyle(.white)
                                        }
                                }
                                .cornerRadius(22)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                }
            }
        }
    }
}

#Preview {
    PlinkoView()
}

