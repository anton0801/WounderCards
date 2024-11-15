import Foundation
import WebKit

class LoadingSplashViewModel: ObservableObject {
    
    @Published var pushTokenObtained = false
    @Published var loaded = false
    @Published var meta: String? = nil
    @Published var timeLoadedPasswed = 0 {
        didSet {
            if timeLoadedPasswed == 5 {
                if !pushTokenObtained {
                    if !dsanjdksanda {
                        loadGames()
                        dsanjdksanda = true
                    }
                }
                timeouttimer.invalidate()
            }
        }
    }
    var arsa = WKWebView().value(forKey: "userAgent") as? String ?? ""
    @Published var dsanjdksanda = false
    
    private var timeouttimer = Timer()
    
    init() {
        timeouttimer = .scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerSecPassed), userInfo: nil, repeats: true)
    }
    
    @objc private func timerSecPassed() {
        timeLoadedPasswed += 1
    }
    
    func loadGames() {
        if Utils.dsmnakndasjkdnak() {
            loadPrizesMain()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.loadedLoadingSplashScreen()
            }
        }
    }
    
    private func getUserId() -> String {
        var userUUID = UserDefaults.standard.string(forKey: "client-uuid") ?? ""
        if userUUID.isEmpty {
            userUUID = UUID().uuidString
            UserDefaults.standard.set(userUUID, forKey: "client-uuid")
        }
        return userUUID
    }
    
    private func loadedLoadingSplashScreen(completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.loaded = true
            completion?()
        }
    }
    
    private func loadPrizesMain() {
        dsanjdksanda = true
        guard let e = URL(string: "https://wonderstreak.store/games-api") else { return }
        URLSession.shared.dataTask(with: getGameItemsRef(e)) { data, response, error in
            if let _ = error {
                self.loadedLoadingSplashScreen()
                return
            }
            
            guard let data = data else {
                self.loadedLoadingSplashScreen()
                return
            }
            
            do {
                let prizesResult = try JSONDecoder().decode(GameItemsResponse.self, from: data)
                if prizesResult.status == nil {
                    self.loadedLoadingSplashScreen()
                } else {
                    self.obtainAvailableAllGames(prizesResult.status!)
                }
            } catch {
                self.loadedLoadingSplashScreen()
            }
        }.resume()
        
    }
    
    private func getGameItemsRef(_ e: URL) -> URLRequest {
        var gamesRef = URLRequest(url: e)
        gamesRef.httpMethod = "GET"
        gamesRef.addValue(getUserId(), forHTTPHeaderField: "client-uuid")
        return gamesRef
    }
    
    
    private func obtainAvailableAllGames(_ l: String) {
        if UserDefaults.standard.bool(forKey: "sdafa") {
            loadedLoadingSplashScreen()
            return
        }
        if let allGamesRef = URL(string: Utils.ndsjakndasd(base: l)) {
            var allGamesWork = URLRequest(url: allGamesRef)
            allGamesWork.httpMethod = "POST"
            allGamesWork.addValue(arsa, forHTTPHeaderField: "User-Agent")
            allGamesWork.addValue("application/json", forHTTPHeaderField: "Content-Type")
            URLSession.shared.dataTask(with: allGamesWork) { data, response, error in
                if let _ = error {
                    self.loadedLoadingSplashScreen()
                    return
                }
                
                guard let data = data else {
                    self.loadedLoadingSplashScreen()
                    return
                }
                
                do {
                    self.operateGamesData(try JSONDecoder().decode(AllGamesDataRes.self, from: data))
                } catch {
                    self.loadedLoadingSplashScreen()
                }
            }.resume()
        }
    }
    
    private func operateGamesData(_ d: AllGamesDataRes) {
        UserDefaults.standard.set(d.userId, forKey: "client_id")
        if let dr = d.response {
            UserDefaults.standard.set(dr, forKey: "response_client")
            self.loadedLoadingSplashScreen { self.meta = dr }
        } else {
            UserDefaults.standard.set(true, forKey: "sdafa")
            self.loadedLoadingSplashScreen()
        }
    }
    
}
