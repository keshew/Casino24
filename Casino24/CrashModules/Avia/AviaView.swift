import SwiftUI

struct AviaView: View {
    @StateObject var viewModel =  AviaViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("bgavia")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Image("avia")
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
                        
                        Text("Avia")
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
                        Image("avia")
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
                    
                    Spacer()
                    
                    Image("plane")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 67)
                        .offset(x: viewModel.planePositionX)
                                               .rotationEffect(Angle(degrees: viewModel.planeRotation))
                    
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            if viewModel.bet >= 250 {
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
                    
                    HStack {
                        Button(action: {
                            if !viewModel.isPlaying {
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
                                            Text("Play")
                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                .foregroundStyle(.white)
                                        }
                                }
                                .cornerRadius(22)
                        }
                        
                        Button(action: {
                            if viewModel.isPlaying {
                                viewModel.collectReward()
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 59/255, green: 136/255, blue: 255/255))
                                .frame(width: 112, height: 42)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 22)
                                        .stroke(.white, lineWidth: 3)
                                        .overlay {
                                            Text("Give")
                                                .font(.custom("PaytoneOne-Regular", size: 16))
                                                .foregroundStyle(.white)
                                        }
                                }
                                .cornerRadius(22)
                        }
                        .disabled(!viewModel.isPlaying)
                        .opacity(!viewModel.isPlaying ? 0.5 : 1)
                    }
                    .padding(.bottom, 50)
                }
                .padding(.horizontal)
                .padding(.top, 15)
            }
        }
    }
}

#Preview {
    AviaView()
}

