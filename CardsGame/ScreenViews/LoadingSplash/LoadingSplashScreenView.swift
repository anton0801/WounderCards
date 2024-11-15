import SwiftUI

struct LoadingSplashScreenView: View {
    
    @StateObject var loadingSplashViewModel = LoadingSplashViewModel()
    
    @State var loadingProgress = 0.0
    @State var loadedGame = false
    
    var timerLoading = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    Spacer()
                    
                    ZStack(alignment: .leading) {
                        Image("loading_field")
                            .resizable()
                            .frame(width: 350, height: 20)
                        
                        Image("loading_line")
                            .resizable()
                            .frame(width: (loadingProgress * 350.0) / 100.0, height: 20)
                    }
                    
                    if loadingSplashViewModel.loaded {
                        if loadingSplashViewModel.meta != nil {
                            Text("")
                                .onAppear {
                                    loadedGame = true
                                }
                            
                            NavigationLink(destination: AgnesGamesView()
                                .navigationBarBackButtonHidden(), isActive: $loadedGame) {
                                    
                                }
                        } else {
                            Text("")
                                .onAppear {
                                    CardsGameDelegate.orientation = .landscape
                                    loadedGame = true
                                }
                            
                            NavigationLink(destination: ContentView()
                                .navigationBarBackButtonHidden(), isActive: $loadedGame) {
                                    
                                }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    Image("loading_title")
                        .resizable()
                        .frame(width: 350, height: 150)
                        .rotationEffect(.degrees(-25))
                    Spacer()
                }
            }
            .background(
                Image("loading_image")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height)
                    .ignoresSafeArea()
                
            )
            .onReceive(timerLoading) { _ in
                if loadingProgress < 100.0 {
                    loadingProgress += 0.5
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name("fcm_received")), perform: { _ in
                loadingSplashViewModel.pushTokenObtained = true
                loadingSplashViewModel.loadGames()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    LoadingSplashScreenView()
}
