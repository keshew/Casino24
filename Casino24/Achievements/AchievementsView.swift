import SwiftUI

struct Achievements: Codable, Identifiable {
    var id = UUID()
    var name: String
    var desc: String
    var image: String
    var goal: Int
    var currentStep: Int
    var reward: Int
    
    var isDone: Bool {
        currentStep >= goal
    }
}

struct AchievementsView: View {
    @StateObject var achievementsModel =  AchievementsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State  var coin = UserDefaultsManager.shared.coins
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("bgmain")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.8))
                        .frame(height: 140)
                    
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
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .offset(y: 1)
                        }
                        
                        Text(" Achievements")
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
                                        
                                        Text("\(coin)")
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
                    VStack(spacing: 20) {
                        ForEach(achievementsModel.achievements, id: \.id) { item in
                            Rectangle()
                                .fill(.black.opacity(0.4))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white, lineWidth: 2)
                                        .overlay {
                                            VStack {
                                                HStack(alignment: .top) {
                                                    VStack(alignment: .leading) {
                                                        Text(item.name)
                                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                                            .foregroundStyle(.white)
                                                        
                                                        Text(item.desc)
                                                            .font(.custom("PaytoneOne-Regular", size: 14))
                                                            .foregroundStyle(.white.opacity(0.7))
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    VStack {
                                                        Image(item.image)
                                                            .resizable()
                                                            .frame(width: 48, height: 48)
                                                        
                                                        Text("\(item.currentStep)/\(item.goal)")
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(.white)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    
                                                    Text("Reward: \(item.reward) coins")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(Color(red: 255/255, green: 185/255, blue: 86/255))
                                                }
                                                
                                                VStack {
                                                    let progress = Double(item.currentStep) / Double(item.goal)
                                                    let progressText = "\(item.currentStep)/\(item.goal)"
                                                    let percentText = "\(Int(progress * 100))%"
                                                    
                                                    HStack {
                                                        Text("Progress: \(progressText)")
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(.white)
                                                        
                                                        Spacer()
                                                        
                                                        Text(percentText)
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(.white)
                                                    }
                                                    
                                                    GeometryReader { geometry in
                                                        ZStack(alignment: .leading) {
                                                            Rectangle()
                                                                .fill(.white.opacity(0.5))
                                                                .frame(width: geometry.size.width, height: geometry.size.height)
                                                            
                                                            Rectangle()
                                                                .fill(Color(red: 60/255, green: 212/255, blue: 66/255))
                                                                .frame(width: geometry.size.width * min(progress, 1.0), height: geometry.size.height)
                                                        }
                                                    }
                                                    .frame(height: 10)
                                                    .cornerRadius(10)
                                                }
                                            }
                                            .padding(.horizontal)
                                        }
                                }
                                .frame(height: 141)
                                .cornerRadius(16)
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
    AchievementsView()
}

