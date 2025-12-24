import SwiftUI

struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    @State  var coin = UserDefaultsManager.shared.coins
    @State var isPro = false
    @State var isAch = false
    @State var isSet = false
    @State var isSlot = false
    @State var isCR = false
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("bgmain")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.8))
                        .frame(height: 180)
                    
                    Rectangle()
                        .fill(Color(red: 232/255, green: 186/255, blue: 186/255).opacity(0.2))
                        .frame(height: 1)
                }
            }
            .ignoresSafeArea()
            
            VStack(spacing: 14) {
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Hello!")
                                .font(.custom("PaytoneOne-Regular", size: 24))
                                .foregroundStyle(LinearGradient(colors: [Color(red: 238/255, green: 35/255, blue: 35/255),
                                                                         Color(red: 232/255, green: 163/255, blue: 113/255)], startPoint: .leading, endPoint: .trailing))
                            
                            Text("User")
                                .font(.custom("PaytoneOne-Regular", size: 24))
                                .foregroundStyle(.white)
                        }
                        
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
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            isPro = true
                        }) {
                            Image("pr")
                                .resizable()
                                .frame(width: 38, height: 38)
                        }
                        
                        Button(action: {
                            isAch = true
                        }) {
                            Image("ac")
                                .resizable()
                                .frame(width: 38, height: 38)
                        }
                        
                        Button(action: {
                            isSet = true
                        }) {
                            Image("set")
                                .resizable()
                                .frame(width: 38, height: 38)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        VStack(spacing: 20) {
                            HStack {
                                Text("Slots")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    isSlot = true
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 228/255, green: 234/255, blue: 241/255).opacity(0.2))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.white, lineWidth: 2)
                                                .overlay {
                                                    HStack {
                                                        Text("See all")
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(.white)
                                                        
                                                        Image(systemName: "chevron.right")
                                                            .font(.system(size: 12, weight: .semibold))
                                                            .foregroundStyle(.white)
                                                        
                                                    }
                                                }
                                        }
                                        .frame(width: 80, height: 26)
                                        .cornerRadius(20)
                                }
                            }
                            
                            Rectangle()
                                .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.6))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white, lineWidth: 2)
                                        .overlay {
                                            HStack(spacing: 0) {
                                                ForEach(0..<4, id: \.self) { index in
                                                    Button(action: {
                                                        isSlot = true
                                                    }) {
                                                        Image("slo\(index + 1)")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 90, height: 139)
                                                    }
                                                }
                                            }
                                        }
                                }
                                .frame(width: 365, height: 151)
                                .cornerRadius(16)
                        }
                        
                        VStack(spacing: 20) {
                            HStack {
                                Text("Fast games")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Button(action: {
                                    isCR = true
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 228/255, green: 234/255, blue: 241/255).opacity(0.2))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(.white, lineWidth: 2)
                                                .overlay {
                                                    HStack {
                                                        Text("See all")
                                                            .font(.custom("PaytoneOne-Regular", size: 12))
                                                            .foregroundStyle(.white)
                                                        
                                                        
                                                        Image(systemName: "chevron.right")
                                                            .font(.system(size: 12, weight: .semibold))
                                                            .foregroundStyle(.white)
                                                        
                                                    }
                                                }
                                        }
                                        .frame(width: 80, height: 26)
                                        .cornerRadius(20)
                                }
                            }
                            
                            Rectangle()
                                .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.6))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white, lineWidth: 2)
                                        .overlay {
                                            HStack(spacing: 0) {
                                                ForEach(0..<4, id: \.self) { index in
                                                    Button(action: {
                                                        isCR = true
                                                    }) {
                                                        Image("fas\(index + 1)")
                                                            .resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                            .frame(width: 90, height: 120)
                                                    }
                                                }
                                            }
                                        }
                                }
                                .frame(width: 365, height: 151)
                                .cornerRadius(16)
                        }
                        
                        VStack(spacing: 20) {
                            HStack {
                                Text("Mysterious")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white.opacity(0.6))
                                
                                Spacer()
                                
                                Rectangle()
                                    .fill(Color(red: 228/255, green: 234/255, blue: 241/255).opacity(0.2))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(.white, lineWidth: 2)
                                            .overlay {
                                                HStack {
                                                    Text("Soon...")
                                                        .font(.custom("PaytoneOne-Regular", size: 12))
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                    }
                                    .frame(width: 80, height: 26)
                                    .cornerRadius(20)
                                    .opacity(0.6)
                            }
                            
                            Rectangle()
                                .fill(Color(red: 46/255, green: 41/255, blue: 41/255).opacity(0.6))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(.white, lineWidth: 2)
                                        .overlay {
                                            HStack(spacing: 0) {
                                                ForEach(0..<4, id: \.self) { index in
                                                    Image("mys\(index + 1)")
                                                        .resizable()
                                                        .aspectRatio(contentMode: .fit)
                                                        .frame(width: 90, height: 139)
                                                }
                                            }
                                        }
                                }
                                .frame(width: 365, height: 151)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                }
            
            }
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: Notification.Name("RefreshData"), object: nil, queue: .main) { _ in
                self.coin = UserDefaultsManager.shared.coins
            }
        }
        .fullScreenCover(isPresented: $isCR) {
            FastGamesView()
        }
        .fullScreenCover(isPresented: $isPro) {
            ProfileView()
        }
        .fullScreenCover(isPresented: $isAch) {
            AchievementsView()
        }
        .fullScreenCover(isPresented: $isSlot) {
            SlotsView()
        }
    }
}

#Preview {
    MainView()
}

