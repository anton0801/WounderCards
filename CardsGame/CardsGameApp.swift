import SwiftUI

@main
struct CardsGameApp: App {
    
    @UIApplicationDelegateAdaptor(CardsGameDelegate.self) var cardsGameDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class CardsGameDelegate: NSObject, UIApplicationDelegate {
    
    static var orientation = UIInterfaceOrientationMask.landscape
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return CardsGameDelegate.orientation
    }

}
