import SwiftUI
import FirebaseCore
import FirebaseMessaging


extension Notification.Name {
    static let hideNavigation = Notification.Name("hide_navigation")
    static let backDeddy = Notification.Name("runner_back")
    static let showNavigation = Notification.Name("show_navigation")
    static let reloadDeddys = Notification.Name("reload_runner")
}

@main
struct CardsGameApp: App {
    
    @UIApplicationDelegateAdaptor(CardsGameDelegate.self) var cardsGameDelegate
    
    var body: some Scene {
        WindowGroup {
            LoadingSplashScreenView()
        }
    }
    
}

class CardsGameDelegate: NSObject, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    static var orientation = UIInterfaceOrientationMask.all
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        promptUserNotifications(application: application)
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if let openPushId = response.notification.request.content.userInfo["push_id"] as? String {
            UserDefaults.standard.set(openPushId, forKey: "push_id")
        }
        completionHandler()
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return CardsGameDelegate.orientation
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        messaging.token { token, _ in
            guard let token = token else {
                return
            }
            UserDefaults.standard.set(token, forKey: "push_token")
            NotificationCenter.default.post(name: Notification.Name("fcm_received"), object: nil, userInfo: nil)
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let openPushId = notification.request.content.userInfo["push_id"] as? String {
            UserDefaults.standard.set(openPushId, forKey: "push_id")
        }
        completionHandler([.badge, .sound, .alert])
    }

}

extension CardsGameDelegate {
    func promptUserNotifications(application: UIApplication) {
        if #available(iOS 10.0, *){
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: { _, _ in
                    
                }
            )
        } else {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
    }
}
