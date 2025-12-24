import SwiftUI

struct ChangeAvaView: View {
    @StateObject var changeAvaModel =  ChangeAvaViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State  var coin = UserDefaultsManager.shared.coins
    @StateObject var manager = UserDefaultsManager.shared
    @State var img = UserDefaults.standard.string(forKey: "profileImageName")
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
                    
                        Text("Profile")
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
                    VStack(spacing: 70) {
                        Image(img ?? "av1")
                            .resizable()
                            .frame(width: 121, height: 124)
                        .padding(.top)
                        
                        LazyVGrid(columns: [GridItem(.flexible(minimum: 90, maximum: 110)), GridItem(.flexible(minimum: 90, maximum: 110)), GridItem(.flexible(minimum: 90, maximum: 110))]) {
                            ForEach(0..<9, id: \.self) { index in
                                Button(action: {
                                    let newAvatar = "av\(index + 1)"
                                    img = newAvatar
                                    UserDefaults.standard.set(newAvatar, forKey: "profileImageName")
                                }) {
                                    Image("av\(index+1)")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        
                                }
                                .opacity(img == "av\(index + 1)" ? 0.3 : 1)
                                .disabled(img == "av\(index + 1)")
                            }
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
    ChangeAvaView()
}

