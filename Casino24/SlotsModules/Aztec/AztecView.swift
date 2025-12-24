import SwiftUI

struct AztecView: View {
    @StateObject var viewModel =  AztecViewModel()
    @State var isQues = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            ZStack(alignment: .top) {
                Color.black
                
                Image("azBg")
                    .resizable()
                
                ZStack(alignment: .bottom) {
                    Image("azt")
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
                        
                        Text("Aztec Slots")
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
                    if !isQues {
                        VStack(spacing: 30) {
                            ZStack {
                                Image("azt")
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
                                                    
                                                    Text("\(viewModel.win)")
                                                        .font(.custom("PaytoneOne-Regular", size: 14))
                                                        .foregroundStyle(.white)
                                                }
                                            }
                                    }
                                    .cornerRadius(16)
                                    .opacity(0.8)
                            }
                            .padding(.top)
                            
                            VStack(spacing: -27) {
                                Image("topazt")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 320, height: 95)
                                
                                Rectangle()
                                    .fill(.black.opacity(0.6))
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color(red: 224/255, green: 132/255, blue: 4/255), lineWidth: 5)
                                            .overlay {
                                                VStack(spacing: 10) {
                                                    ForEach(0..<3, id: \.self) { row in
                                                        HStack(spacing: 10) {
                                                            ForEach(0..<5, id: \.self) { col in
                                                                Rectangle()
                                                                    .fill(Color.black.opacity(0.1))
                                                                    .frame(width: 50, height: 50)
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 8)
                                                                            .stroke(Color.white.opacity(0.4), lineWidth: 3)
                                                                            .overlay {
                                                                                Image(viewModel.slots[row][col])
                                                                                    .resizable()
                                                                                    .aspectRatio(contentMode: .fit)
                                                                                    .frame(width: 35, height: 35)
                                                                                    .padding(.horizontal, 5)
                                                                                    .shadow(
                                                                                        color: viewModel.winningPositions.contains(where: { $0.row == row && $0.col == col }) ? Color.yellow : .clear,
                                                                                        radius: viewModel.isSpinning ? 0 : 25
                                                                                    )
                                                                            }
                                                                    }
                                                                    .cornerRadius(8)
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                    .frame(width: 320, height: 200)
                                    .cornerRadius(12)
                                    .offset(y: 2)
                            }
                            
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    if viewModel.bet >= 600 {
                                        viewModel.bet -= 100
                                    }
                                }) {
                                    Circle()
                                        .fill(Color(red: 60/255, green: 255/255, blue: 65/255))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 1/255, green: 63/255, blue: 24/255), lineWidth: 2)
                                                .overlay {
                                                    Text("-")
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(Color(red: 1/255, green: 63/255, blue: 24/255))
                                                        .offset(y: -3)
                                                }
                                        }
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(15)
                                }
                                
                                Rectangle()
                                    .fill(Color(red: 60/255, green: 255/255, blue: 65/255))
                                    .frame(width: 112, height: 42)
                                    .overlay {
                                        Text("BET: \(viewModel.bet)")
                                            .font(.custom("PaytoneOne-Regular", size: 16))
                                            .foregroundStyle(Color(red: 1/255, green: 63/255, blue: 24/255))
                                    }
                                    .cornerRadius(12)
                                
                                Button(action: {
                                    if (viewModel.bet + 100) <= viewModel.coin {
                                        viewModel.bet += 100
                                    }
                                }) {
                                    Circle()
                                        .fill(Color(red: 60/255, green: 255/255, blue: 65/255))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 1/255, green: 63/255, blue: 24/255), lineWidth: 2)
                                                .overlay {
                                                    Text("+")
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(Color(red: 1/255, green: 63/255, blue: 24/255))
                                                        .offset(y: -3)
                                                }
                                        }
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(15)
                                }
                            }
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    isQues = true
                                }) {
                                    Circle()
                                        .fill(Color(red: 60/255, green: 255/255, blue: 65/255))
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 15)
                                                .stroke(Color(red: 1/255, green: 63/255, blue: 24/255), lineWidth: 2)
                                                .overlay {
                                                    Text("?")
                                                        .font(.custom("PaytoneOne-Regular", size: 20))
                                                        .foregroundStyle(Color(red: 1/255, green: 63/255, blue: 24/255))
                                                        .offset(y: -1)
                                                }
                                        }
                                        .frame(width: 30, height: 30)
                                        .cornerRadius(15)
                                }
                                
                                Button(action: {
                                    if viewModel.coin >= viewModel.bet {
                                        viewModel.spin()
                                    }
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 60/255, green: 255/255, blue: 65/255))
                                        .frame(width: 112, height: 42)
                                        .overlay {
                                            RoundedRectangle(cornerRadius: 22)
                                                .stroke(Color(red: 1/255, green: 63/255, blue: 24/255), lineWidth: 3)
                                                .overlay {
                                                    Text("Spin")
                                                        .font(.custom("PaytoneOne-Regular", size: 16))
                                                        .foregroundStyle(Color(red: 1/255, green: 63/255, blue: 24/255))
                                                }
                                        }
                                        .cornerRadius(22)
                                }
                                
                                Circle()
                                    .fill(Color(red: 62/255, green: 74/255, blue: 253/255))
                                    .frame(width: 30, height: 30)
                                    .cornerRadius(15)
                                    .hidden()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 15)
                    } else {
                        ZStack(alignment: .topTrailing) {
                            Image("aztHold")
                                .resizable()
                                .overlay {
                                    LazyVGrid(columns: [GridItem(.flexible(minimum: 80, maximum: 80)),GridItem(.flexible(minimum: 80, maximum: 80))]) {
                                        ForEach(0..<6, id: \.self) { index in
                                            VStack {
                                                Image("az\(index + 1)")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 45, height: 47)
                                                
                                                let item = index >= 3 ? 100 : 200
                                                Text("x4=\(item)")
                                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                                    .foregroundStyle(.white)
                                                    .shadow(radius: 1)
                                            }
                                        }
                                    }
                                }
                                .frame(width: 268, height: 346)
                            
                            Button(action: {
                                isQues.toggle()
                            }) {
                                Image("close")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                            }
                            .offset(y: -10)
                        }
                        .padding(.top, 50)
                    }
                }
            }
        }
    }
}

#Preview {
    AztecView()
}

