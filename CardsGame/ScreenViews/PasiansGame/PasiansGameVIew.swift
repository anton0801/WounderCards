import SwiftUI
import SpriteKit

// MARK: Сделать Loss (если расскладывается пасьянс более 100 ходов тогда проигрышь), сделай daily rewards, menu с 2 заблоканами играми и типа их надо открыть

struct PasiansGameVIew: View {
    
    @Environment(\.presentationMode) var presMode
    @State var infoGameVisible = false
    
    @State var gameScene: PasiansSpiderGameScene!
    
    var body: some View {
        ZStack {
            VStack {
                if let gameScene = gameScene {
                    SpriteView(scene: gameScene)
                        .ignoresSafeArea()
                }
            }
            
            if infoGameVisible {
                InfoPasiansGameView()
            }
        }
        .onAppear {
            gameScene = PasiansSpiderGameScene()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("HOME_GO"))) { _ in
            presMode.wrappedValue.dismiss()
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("INFO_GAME"))) { _ in
            withAnimation(.easeInOut) {
                infoGameVisible = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("CLOSE_INFO"))) { _ in
            withAnimation(.easeInOut) {
                infoGameVisible = false
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("RESTART_GAME"))) { _ in
            gameScene = gameScene.restartGame()
        }
    }
}

#Preview {
    PasiansGameVIew()
}
