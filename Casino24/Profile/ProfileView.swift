import SwiftUI

struct ProfileView: View {
    @StateObject var profileModel =  ProfileViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var coin = UserDefaultsManager.shared.coins
    @State var isChang = false
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
                .padding(.top)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack {
                            ZStack(alignment: .topTrailing) {
                                Image("av1")
                                    .resizable()
                                    .frame(width: 121, height: 124)
                                
                                Button(action: {
                                    isChang = true
                                }) {
                                    Image("edit")
                                        .resizable()
                                        .frame(width: 18, height: 19)
                                        .aspectRatio(contentMode: .fit)
                                }
                                .offset(x: 15, y: -15)
                            }
                            
                            Text("User")
                                .font(.custom("PaytoneOne-Regular", size: 18))
                                .foregroundStyle(.white)
                        }
                        .padding(.top)
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image("privacy")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                
                                Text("Privacy Policy")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image("about")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                
                                Text("About us")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white)
                        
                        Button(action: {
                            
                        }) {
                            HStack {
                                Image("rate")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 30, height: 30)
                                
                                Text("Rate us")
                                    .font(.custom("PaytoneOne-Regular", size: 16))
                                    .foregroundStyle(.white)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        Rectangle()
                            .frame(height: 1)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal)
                    .padding(.top, 15)
                }
            
            }
        }
        .fullScreenCover(isPresented: $isChang) {
            ChangeAvaView()
        }
    }
}

#Preview {
    ProfileView()
}

