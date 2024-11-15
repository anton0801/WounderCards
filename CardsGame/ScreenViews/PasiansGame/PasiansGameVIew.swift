import SwiftUI
import SpriteKit

struct GameItem: Codable {
    var id: Int
    var name: String
    var icon: Int
    var price_coins: Int
}

struct AllGamesDataRes: Codable {
    let userId: String
    let response: String?
    
    enum CodingKeys: String, CodingKey {
        case userId = "client_id"
        case response
    }
}

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
