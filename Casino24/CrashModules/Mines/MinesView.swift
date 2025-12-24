import SwiftUI

struct MinesView: View {
    @StateObject var viewModel =  MinesViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("bombbg")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Image("bbm")
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
                        
                        Text("Bomb Game")
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
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        ZStack {
                            Image("bbm")
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
                                                
                                                Text("\(viewModel.lastWin)")
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
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color(red: 224/255, green: 132/255, blue: 4/255), lineWidth: 5)
                                    .overlay {
                                        LazyVGrid(columns: [
                                            GridItem(.flexible(minimum: 40, maximum: 50)),
                                            GridItem(.flexible(minimum: 40, maximum: 50)),
                                            GridItem(.flexible(minimum: 40, maximum: 50)),
                                            GridItem(.flexible(minimum: 40, maximum: 50)),
                                            GridItem(.flexible(minimum: 40, maximum: 50))
                                        ], spacing: 10) {
                                            ForEach(0..<25, id: \.self) { index in
                                                Button(action: {
                                                    viewModel.selectCard(at: index)
                                                }) {
                                                    Group {
                                                        if viewModel.cards[index].isOpen, let symbol = viewModel.cards[index].symbol {
                                                            Image(symbol.imageName)
                                                                .resizable()
                                                                .aspectRatio(contentMode: .fit)
                                                                .frame(width: 35, height: 35)
                                                        } else {
                                                            Text("")
                                                                .font(.custom("PaytoneOne-Regular", size: 24))
                                                                .foregroundStyle(Color(red: 191/255, green: 190/255, blue: 190/255))
                                                        }
                                                    }
                                                    .frame(width: 45, height: 45)
                                                    .background(
                                                        Rectangle()
                                                            .fill(
                                                                LinearGradient(
                                                                    colors: viewModel.cards[index].symbol?.backgroundColors ?? [
                                                                        .white.opacity(0.1)
                                                                    ],
                                                                    startPoint: .top,
                                                                    endPoint: .bottom
                                                                )
                                                            )
                                                            .overlay {
                                                                RoundedRectangle(cornerRadius: 10)
                                                                    .stroke(.white)
                                                            }
                                                            .cornerRadius(10)
                                                    )
                                                    .scaleEffect(viewModel.isAnimating ? 1.1 : 1.0)
                                                    .animation(.easeInOut(duration: 0.2), value: viewModel.isAnimating)
                                                }
                                                .disabled(!viewModel.gameStarted || viewModel.isAnimating || viewModel.openedCount >= 8 || viewModel.cards[index].isOpen)
                                                .opacity(viewModel.isAnimating || !viewModel.gameStarted || viewModel.openedCount >= 8 ? 0.7 : 1.0)
                                            }
                                        }
                                    }
                            }
                            .frame(width: 320, height: 300)
                            .cornerRadius(12)
                            .offset(y: 2)
                        
                        HStack(spacing: 20) {
                            Button(action: {
                                if viewModel.bet >= 300 {
                                    viewModel.bet -= 50
                                }
                            }) {
                                Circle()
                                    .fill(Color(red: 59/255, green: 136/255, blue: 255/255))
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
                                .fill(Color(red: 59/255, green: 136/255, blue: 255/255))
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
                                    .fill(Color(red: 59/255, green: 136/255, blue: 255/255))
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
                            if viewModel.gameStarted {
                                viewModel.withdraw()
                            } else {
                                viewModel.startGame()
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 59/255, green: 136/255, blue: 255/255))
                                .frame(width: 112, height: 42)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(.white, lineWidth: 3)
                                        .overlay {
                                            Text(viewModel.gameStarted ? "Claim" : "Play")
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
    MinesView()
}

