import SwiftUI

struct LoadingView: View {
    @ObservedObject private var soundManager = SoundManager.shared
    @State var isMain = false
    
    var body: some View {
        ZStack {
            Color.black
                .overlay {
                    Image("bgloading")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .ignoresSafeArea()
            
            VStack {
                Text("WELCOME!\nNAME GAME")
                    .font(.custom("PaytoneOne-Regular", size: 34))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Image("iconloading")
                    .resizable()
                    .frame(width: 100, height: 100)
                
                Spacer()
                
                ProgressView()
                    .tint(.white)
                    .scaleEffect(1.5)
            }
            .padding(.vertical, 110)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                isMain = true
            }
        }
        .fullScreenCover(isPresented: $isMain) {
            MainView()
        }
    }
}

#Preview {
    LoadingView()
}
