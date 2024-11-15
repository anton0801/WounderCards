import SwiftUI
import WebKit

struct GameItemsResponse: Codable {
    var games: [GameItem]
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case games
        case status = "response"
    }
}

struct InfoPasiansGameView: View {
    
    var body: some View {
        HStack {
            VStack {
                Spacer()
                Image("girl")
                    .resizable()
                    .frame(width: 200, height: 240)
            }
            Spacer()
            Image("info_content")
                .resizable()
                .frame(width: 550, height: 350)
            Spacer()
            VStack {
                Button {
                    NotificationCenter.default.post(name: Notification.Name("CLOSE_INFO"), object: nil)
                } label: {
                    Image("close")
                        .resizable()
                        .frame(width: 60, height: 60)
                }
                Spacer()
            }
            .padding(.top)
        }
        .ignoresSafeArea()
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.4)
                .ignoresSafeArea()
        )
    }
    
}

#Preview {
    InfoPasiansGameView()
}


class AgnesGameViewCoordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
    
    var parent: AgnesGameSceneView
    
    private func dmsajkndasd(window: WKWebView) {
        window.allowsBackForwardNavigationGestures = true
        window.scrollView.isScrollEnabled = true
        window.uiDelegate = self
        NSLayoutConstraint.activate([
            window.topAnchor.constraint(equalTo: parent.agnesGameSceneView.topAnchor),
            window.bottomAnchor.constraint(equalTo: parent.agnesGameSceneView.bottomAnchor),
            window.leadingAnchor.constraint(equalTo: parent.agnesGameSceneView.leadingAnchor),
            window.trailingAnchor.constraint(equalTo: parent.agnesGameSceneView.trailingAnchor)
        ])

    }
    
    init(parent: AgnesGameSceneView) {
        self.parent = parent
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { ndjksandkjasdasd in
            var dmsjaknfkjasdasd = [String: [String: HTTPCookie]]()
     
            func dasnmdjksa() {
                for cfgdasvhbjkm in ndjksandkjasdasd {
                    var fgdcvashbjfg = dmsjaknfkjasdasd[cfgdasvhbjkm.domain] ?? [:]
                    fgdcvashbjfg[cfgdasvhbjkm.name] = cfgdasvhbjkm
                    dmsjaknfkjasdasd[cfgdasvhbjkm.domain] = fgdcvashbjfg
                }
            }
            
            dasnmdjksa()
            
            func dasnjkdnaskdasdjas() -> Int {
                let dnsajkdnsajkdnas = Int.random(in: 1...2414)
                let dnsajhbdasd = (dnsajkdnsajkdnas * 42) / 2 + (dnsajkdnsajkdnas % 12)
                return dnsajhbdasd
            }
            
            var ndksjandkasd = [String: [String: AnyObject]]()
            for (dmnajksndjkasdad, ndsajkdnajknfad) in dmsjaknfkjasdasd {
                var dbdsjahbdjahsd = [String: AnyObject]()
                for (gvhadsbfjgnkhmlj, fcagdsvhfbjgnkhj) in ndsajkdnajknfad {
                    dbdsjahbdjahsd[gvhadsbfjgnkhmlj] = fcagdsvhfbjgnkhj.properties as AnyObject
                }
                ndksjandkasd[dmnajksndjkasdad] = dbdsjahbdjahsd
            }
            
            UserDefaults.standard.set(ndksjandkasd, forKey: "game_saved_data")
        }
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        NotificationCenter.default.addObserver(self, selector: #selector(reloadCalledAction), name: .reloadDeddys, object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(backActionCalled), name: .backDeddy, object: nil)
    }
    
    
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {

        if navigationAction.targetFrame == nil {
            let infocardGameAgnesView = WKWebView(frame: .zero, configuration: configuration)
            
            parent.agnesGameSceneView.addSubview(infocardGameAgnesView)
            
            func dsandjsandk() {
                infocardGameAgnesView.navigationDelegate = self
                infocardGameAgnesView.translatesAutoresizingMaskIntoConstraints = false
            }
            dsandjsandk()
            
            dmsajkndasd(window: infocardGameAgnesView)
            
            NotificationCenter.default.post(name: .showNavigation, object: nil)
            
            if navigationAction.request.url?.absoluteString == "about:blank" || navigationAction.request.url?.absoluteString.isEmpty == true {
            } else {
                infocardGameAgnesView.load(navigationAction.request)
            }
            parent.agnesGameCardsInfoViews.append(infocardGameAgnesView)
            return infocardGameAgnesView
        }
        NotificationCenter.default.post(name: .hideNavigation, object: nil, userInfo: nil)
        return nil
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if let dnsajkdnasd = navigationAction.request.url, ["newapp://", "tg://", "viber://", "whatsapp://"].contains(where: dnsajkdnasd.absoluteString.hasPrefix) {
            UIApplication.shared.open(dnsajkdnasd, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
    
    
    @objc private func reloadCalledAction() {
        parent.restarterws()
    }
    
    @objc private func backActionCalled() {
        parent.dbsajhbdahdafad()
    }
    
    
}
