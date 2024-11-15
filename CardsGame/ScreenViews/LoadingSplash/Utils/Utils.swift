import Foundation

struct Utils {
    
    static func dsmnakndasjkdnak() -> Bool {
        let curdat = Date()
        let cal = Calendar.current
        
        var dsajcompon = DateComponents()
        dsajcompon.year = 2024
        dsajcompon.month = 11
        dsajcompon.day = 18
        
        if let targetDate = cal.date(from: dsajcompon) {
            return curdat >= targetDate
        }
        
        return false
    }

    static func ndsjakndasd(base: String) -> String {
        let pushertoken = UserDefaults.standard.string(forKey: "push_token")
        let useruuid = UserDefaults.standard.string(forKey: "client_id")
        var availablegameslin = "\(base)?firebase_push_token=\(pushertoken ?? "")"
        if let uiduser = useruuid {
            availablegameslin += "&client_id=\(uiduser)"
        }
        let openedAppFromPushId = UserDefaults.standard.string(forKey: "push_id")
        if let openedAppFromPushId = openedAppFromPushId {
            availablegameslin += "&push_id=\(openedAppFromPushId)"
            UserDefaults.standard.set(nil, forKey: "push_id")
        }
        return availablegameslin
    }
    
}
