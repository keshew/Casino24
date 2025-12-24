import SwiftUI

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @Binding var isShow: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(.black.opacity(0.7))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.white, lineWidth: 4)
                            .overlay {
                                VStack(spacing: 20) {
                                    VStack(spacing: 8) {
                                        Text("Settings")
                                            .font(.custom("PaytoneOne-Regular", size: 24))
                                            .foregroundStyle(.white)
                                        
                                        Rectangle()
                                            .fill(.white)
                                            .frame(height: 3)
                                    }
                                    
                                    HStack {
                                        Text("Music")
                                            .font(.custom("PaytoneOne-Regular", size: 24))
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    settingsModel.isMusicOn = true
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(.black.opacity(0.7))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(settingsModel.isMusicOn ? .white : .white.opacity(0.6), lineWidth: 2)
                                                            .overlay {
                                                                Image(systemName: "speaker.wave.3.fill")
                                                                    .foregroundStyle(settingsModel.isMusicOn ? .white : .white.opacity(0.6))
                                                            }
                                                    }
                                                    .frame(width: 38, height: 38)
                                                    .cornerRadius(6)
                                            }
                                            
                                            Button(action: {
                                                withAnimation {
                                                    settingsModel.isMusicOn = false
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(.black.opacity(0.7))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(!settingsModel.isMusicOn ? .white : .white.opacity(0.6), lineWidth: 2)
                                                            .overlay {
                                                                Image(systemName: "speaker.slash.fill")
                                                                    .foregroundStyle(!settingsModel.isMusicOn ? .white : .white.opacity(0.6))
                                                            }
                                                    }
                                                    .frame(width: 38, height: 38)
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                    
                                    HStack {
                                        Text("Sound")
                                            .font(.custom("PaytoneOne-Regular", size: 24))
                                            .foregroundStyle(.white)
                                        
                                        Spacer()
                                        
                                        HStack {
                                            Button(action: {
                                                withAnimation {
                                                    settingsModel.isSoundOn = true
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(.black.opacity(0.7))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(settingsModel.isSoundOn ? .white : .white.opacity(0.6), lineWidth: 2)
                                                            .overlay {
                                                                Image(systemName: "speaker.wave.3.fill")
                                                                    .foregroundStyle(settingsModel.isSoundOn ? .white : .white.opacity(0.6))
                                                            }
                                                    }
                                                    .frame(width: 38, height: 38)
                                                    .cornerRadius(6)
                                            }
                                            
                                            Button(action: {
                                                withAnimation {
                                                    settingsModel.isSoundOn = false
                                                }
                                            }) {
                                                Rectangle()
                                                    .fill(.black.opacity(0.7))
                                                    .overlay {
                                                        RoundedRectangle(cornerRadius: 6)
                                                            .stroke(!settingsModel.isSoundOn ? .white : .white.opacity(0.6), lineWidth: 2)
                                                            .overlay {
                                                                Image(systemName: "speaker.slash.fill")
                                                                    .foregroundStyle(!settingsModel.isSoundOn ? .white : .white.opacity(0.6))
                                                            }
                                                    }
                                                    .frame(width: 38, height: 38)
                                                    .cornerRadius(6)
                                            }
                                        }
                                    }
                                    .padding(.horizontal, 25)
                                }
                            }
                    }
                    .frame(width: 265, height: 210)
                    .cornerRadius(16)
                
                Button(action: {
                    isShow = false
                }) {
                    Image("close")
                        .resizable()
                        .frame(width: 40, height: 40)
                }
                .offset(x: 10, y: -10)
            }
        }
    }
}

#Preview {
    SettingsView(isShow: .constant(false))
}

