import SwiftUI

struct FastGamesView: View {
    @StateObject var fastGamesModel =  FastGamesViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State  var coin = UserDefaultsManager.shared.coins
    @State var gam1 = false
    @State var gam2 = false
    @State var gam3 = false
    @State var gam4 = false
    
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
                            NotificationCenter.default.post(name: Notification.Name("RefreshData"), object: nil)
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(.white)
                                .offset(y: 1)
                        }
                        
                        Text("Fast Games")
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
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        ForEach(0..<4, id: \.self) { index in
                            Button(action: {
                                switch index {
                                case 0: gam1 = true
                                case 1: gam2 = true
                                case 2: gam3 = true
                                case 3: gam4 = true
                                default:
                                    gam1 = true
                                }
                            }) {
                                Image("fast\(index + 1)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 151)
                            }
                        }
                        
                        ForEach(6..<9, id: \.self) { index in
                            Button(action: {
                                
                            }) {
                                Image("slot7")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 350, height: 151)
                            }
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
        .fullScreenCover(isPresented: $gam1) {
            AviaView()
        }
        .fullScreenCover(isPresented: $gam2) {
            MinesView()
        }
        .fullScreenCover(isPresented: $gam3) {
            PlinkoView()
        }
        .fullScreenCover(isPresented: $gam4) {
            RocketView()
        }
    }
}

#Preview {
    FastGamesView()
}

