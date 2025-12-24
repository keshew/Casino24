import SwiftUI

struct RocketView: View {
    @StateObject var viewModel =  RocketViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State private var progress: CGFloat = 0.0
    @State private var displayedMultiplier: CGFloat = 1.0
    @State private var isPlaying: Bool = false
    @State private var timer: Timer? = nil
    let gird = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @State private var multiplierHistory: [CGFloat] = UserDefaults.standard.array(forKey: "multiplierHistory") as? [CGFloat] ?? []
    @State private var shakeOffset: CGFloat = 0
    @State private var isFalling: Bool = false
    @State private var isShaking = false
    @State private var rotationAngle: Double = 0
    @ObservedObject private var soundManager = SoundManager.shared
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("rocketlbg")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Image("roa")
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
            
            ScrollView(showsIndicators: false) {
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
                            
                            Text("LuckyBoy")
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
                                            
                                            Text("\(viewModel.coin)")
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
                    
                    VStack(spacing: 30) {
                        ZStack {
                            Image("roa")
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
                                                
                                                Text("\(viewModel.reward)")
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
                                ZStack(alignment: .bottomLeading) {
                                    Rectangle()
                                        .fill(Color(red: 38/255, green: 19/255, blue: 30/255).opacity(0.7))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(Color(red: 154/255, green: 6/255, blue: 223/255), lineWidth: 5)
                                                .overlay(
                                                    VStack {
                                                        Image("rocket")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 60, height: 70)
                                                            .padding(.top)
                                                            .rotationEffect(.degrees(rotationAngle))
                                                            .offset(x: isShaking ? shakeOffset : 0, y: isFalling ? 250 : 0)
                                                            .animation(.linear(duration: 0.1).repeat(while: isShaking), value: isShaking)
                                                        
                                                        Text("X \(String(format: "%.2f", displayedMultiplier))")
                                                            .font(.custom("PaytoneOne-Regular", size: 20))
                                                            .foregroundStyle(.white)
                                                            .outlineText(color: .purple, width: 0.7)
                                                        
                                                        Spacer()
                                                    }
                                                )
                                        )
                                        .frame(width: UIScreen.main.bounds.size.width - 100,  height: UIScreen.main.bounds.width > 700 ? 480 : 229)
                                        .cornerRadius(14)
                                    
                                    GeometryReader { geo in
                                        ZStack(alignment: .bottomLeading) {
                                            LinearGradient(
                                                gradient: Gradient(colors: [.red, .yellow, .green]),
                                                startPoint: .bottom,
                                                endPoint: .top
                                            )
                                            .mask(
                                                Path { path in
                                                    let width = geo.size.width
                                                    let height = geo.size.height
                                                    let diagProgress = progress
                                                    
                                                    path.move(to: CGPoint(x: width * diagProgress, y: height * (1 - diagProgress)))
                                                    path.addLine(to: CGPoint(x: width * diagProgress, y: height))
                                                    path.addLine(to: CGPoint(x: 0, y: height))
                                                    path.closeSubpath()
                                                }
                                            )
                                            
                                            Path { path in
                                                let width = geo.size.width
                                                let height = geo.size.height
                                                let diagProgress = progress
                                                
                                                path.move(to: CGPoint(x: 0, y: height))
                                                path.addLine(to: CGPoint(x: width * diagProgress, y: height * (1 - diagProgress)))
                                            }
                                            .stroke(Color.white, lineWidth: 3)
                                        }
                                    }
                                    
                                    .frame(width: 306, height: 218)
                                    .onTapGesture {
                                        withAnimation(.easeInOut(duration: 0.4)) {
                                            progress += 0.1
                                            if progress > 0.4 { progress = 0.1 }
                                        }
                                    }
                                    .offset(x: 8, y: -2)
                                }
                            }
                            .frame(width: UIScreen.main.bounds.size.width - 97,  height: UIScreen.main.bounds.width > 700 ? 480 : 229)
                            .cornerRadius(12)
                            .offset(y: 2)
                        
                        Spacer()
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                if viewModel.bet >= 250 {
                                    viewModel.bet -= 50
                                }
                            }) {
                                Circle()
                                    .fill(Color(red: 154/255, green: 6/255, blue: 223/255))
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
                                .fill(Color(red: 154/255, green: 6/255, blue: 223/255))
                                .frame(width: 112, height: 42)
                                .overlay {
                                    Text("BET: \(viewModel.bet)")
                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                        .foregroundStyle(.white)
                                }
                                .cornerRadius(12)
                            
                            Button(action: {
                                if (viewModel.bet + 50) <= viewModel.coin {
                                    viewModel.bet += 50
                                }
                            }) {
                                Circle()
                                    .fill(Color(red: 154/255, green: 6/255, blue: 223/255))
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
                        
                        HStack {
                            Button(action: {
                                if isPlaying {
                                   
                                } else {
                                    launchAction()
                                }
                            }) {
                                Rectangle()
                                    .fill(Color(red: 154/255, green: 6/255, blue: 223/255))
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
                            
                            Button(action: {
                                if isPlaying {
                                    timer?.invalidate()
                                    timer = nil
                                    finalizeGame()
                                    isShaking = false
                                    shakeOffset = 0
                                    isFalling = false
                                } else {
                                }
                            }) {
                                Rectangle()
                                    .fill(Color(red: 154/255, green: 6/255, blue: 223/255))
                                    .frame(width: 112, height: 42)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 22)
                                            .stroke(.white, lineWidth: 3)
                                            .overlay {
                                                Text("Own")
                                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                                    .foregroundStyle(.white)
                                            }
                                    }
                                    .cornerRadius(22)
                            }
                            .disabled(!isPlaying)
                            .opacity(!isPlaying ? 0.5 : 1)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                }
            }
        }
    }
    
    func launchAction() {
        guard !isPlaying else { return }
        guard viewModel.bet <= viewModel.coin else {
            return
        }
        
        rotationAngle = 0
        isPlaying = true
        isFalling = false
        viewModel.coin -= viewModel.bet
        UserDefaultsManager.shared.removeCoins(viewModel.bet)
        progress = 0.0
        displayedMultiplier = 1.0
        viewModel.multiplierTextColor = Color(red: 141/255, green: 1/255, blue: 198/255)

        let won = Bool.random()
        
        withAnimation(Animation.linear(duration: 0.1).repeatForever(autoreverses: true)) {
            isShaking = true
            shakeOffset = 10
        }

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { t in
            if progress < 0.4 {
                progress += 0.01
                displayedMultiplier = 1.0 + progress * 3
                
                if !won && progress > 0.05 && Bool.random() {
                    rotationAngle = 120
                    viewModel.multiplierTextColor = .red
                    isPlaying = false
                    withAnimation(.easeIn(duration: 0.8)) {
                        isFalling = true
                    }
                    t.invalidate()
                    timer = nil
              
                    withAnimation(.easeIn(duration: 0.8)) {
                        shakeOffset = 0
                    }
        
                }
            } else {
                t.invalidate()
                timer = nil
                finalizeGame()
   
                withAnimation {
                    isShaking = false
                    shakeOffset = 0
                    isFalling = false
                }
            }
        }
    }

    func finalizeGame() {
        viewModel.multiplierTextColor = .green
        let winAmount = Int(CGFloat(viewModel.bet) * displayedMultiplier)
        viewModel.coin += winAmount
        UserDefaultsManager.shared.addCoins(winAmount)
        isPlaying = false
        
        multiplierHistory.append(displayedMultiplier)
        UserDefaults.standard.set(multiplierHistory, forKey: "multiplierHistory")
    }

    func getMultiplierHistory() -> [CGFloat] {
        return multiplierHistory
    }
    
    func fillColor(for index: Int) -> Color {
        switch index % 4 {
        case 0:
            return Color(red: 202/255, green: 0/255, blue: 171/255).opacity(0.5)
        case 1:
            return Color(red: 0/255, green: 201/255, blue: 34/255).opacity(0.5)
        case 2:
            return Color(red: 12/255, green: 12/255, blue: 201/255).opacity(0.5)
        default:
            return Color(red: 202/255, green: 0/255, blue: 171/255).opacity(0.5)
        }
    }
}

#Preview {
    RocketView()
}

extension Animation {
    func `repeat`(while condition: Bool, autoreverses: Bool = true) -> Animation {
        if condition {
            return self.repeatForever(autoreverses: autoreverses)
        } else {
            return self
        }
    }
}

extension View {
    func outlineText(color: Color, width: CGFloat) -> some View {
        modifier(StrokeModifier(strokeSize: width, strokeColor: color))
    }
}

struct StrokeModifier: ViewModifier {
    private let id = UUID()
    var strokeSize: CGFloat = 1
    var strokeColor: Color = .blue
    
    func body(content: Content) -> some View {
        content
            .padding(strokeSize*2)
            .background (Rectangle()
                .foregroundStyle(strokeColor)
                .mask({
                    outline(context: content)
                })
            )}
    
    func outline(context:Content) -> some View {
        Canvas { context, size in
            context.addFilter(.alphaThreshold(min: 0.01))
            context.drawLayer { layer in
                if let text = context.resolveSymbol(id: id) {
                    layer.draw(text, at: .init(x: size.width/2, y: size.height/2))
                }
            }
        } symbols: {
            context.tag(id)
                .blur(radius: strokeSize)
        }
    }
}
