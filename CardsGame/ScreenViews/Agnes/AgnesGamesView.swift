import SwiftUI
import WebKit

struct AgnesGamesView: View {
    
    @State var navVisible = false
    
    var body: some View {
        VStack {
            AgnesGameSceneView(deddiesGameRefStarter: URL(string: UserDefaults.standard.string(forKey: "response_client") ?? "")!)
            
            if navVisible {
                ZStack {
                    Color.black
                    HStack {
                        Button {
                            NotificationCenter.default.post(name: .backDeddy, object: nil)
                        } label: {
                            Image(systemName: "arrow.left")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                        
                        
                        Spacer()
                        
                        
                        Button {
                            NotificationCenter.default.post(name: .reloadDeddys, object: nil)
                        } label: {
                            Image(systemName: "arrow.clockwise")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(6)
                }
                .frame(height: 60)
            }
        }
        .edgesIgnoringSafeArea([.trailing,.leading])
        .onReceive(NotificationCenter.default.publisher(for: .hideNavigation), perform: { _ in
            withAnimation(.linear(duration: 0.4)) {
                navVisible = false
            }
        })
        .preferredColorScheme(.dark)
        .onReceive(NotificationCenter.default.publisher(for: .showNavigation), perform: { _ in
            withAnimation(.linear(duration: 0.4)) {
                navVisible = true
            }
        })
    }
}

#Preview {
    AgnesGamesView()
}

struct GameDatalevel {
    var data: [String: [String: [HTTPCookiePropertyKey: AnyObject]]]?
}

extension AgnesGameSceneView {
    
    func dbsajhbdahdafad() {
        if !agnesGameCardsInfoViews.isEmpty {
            ndjaskndsadfasd()
        } else if agnesGameSceneView.canGoBack {
            agnesGameSceneView.goBack()
        }
    }
    
    func ndsjandskajda() -> WKWebpagePreferences {
        let ndasjkdnkasds = WKWebpagePreferences()
        ndasjkdnkasds.allowsContentJavaScript = true
        return ndasjkdnkasds
    }
    
    func bdhjsabdaksjda() -> WKWebViewConfiguration {
        let dnsajkdnaskd = WKPreferences()
        dnsajkdnaskd.javaScriptCanOpenWindowsAutomatically = true
        dnsajkdnaskd.javaScriptEnabled = true
        
        let ndajskndskad = WKWebViewConfiguration()
        ndajskndskad.allowsInlineMediaPlayback = true
        ndajskndskad.defaultWebpagePreferences = ndsjandskajda()
        
        ndajskndskad.preferences = dnsajkdnaskd
        ndajskndskad.requiresUserActionForMediaPlayback = false
        return ndajskndskad
    }
    
}

