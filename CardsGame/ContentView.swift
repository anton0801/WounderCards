import SwiftUI

struct ContentView: View {
    
    @State var musicState = false
    @State var soundState = false
    
    @State var agnesGameUnlocked = false
    @State var carpetGameUnlocked = false
    
    @State var alertVisible = false
    @State var alertTitle = ""
    @State var alertMessage = ""
    
    @State var dailyBonusVisible = false
    @State var takedBonus = false
    
    @State var shopContentVisible = false
    @StateObject var shopManager = ShopManager()
    @State var selectedSkinCards = ""
    
    @State var balance = 0
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack(spacing: 12) {
                        Spacer()
                        NavigationLink(destination: PasiansGameVIew()
                            .navigationBarBackButtonHidden()) {
                            Image("spider_game")
                                    .resizable()
                                    .frame(width: 200, height: 280)
                        }
                        
                        if !agnesGameUnlocked {
                            ZStack {
                                Image("agnes_game")
                                    .resizable()
                                    .frame(width: 200, height: 280)
                                    .opacity(0.7)
                                
                                Button {
                                    if balance >= 1000 {
                                        balance -= 1000
                                    } else {
                                        alertTitle = "Error"
                                        alertMessage = "You don't have enought credits for open this game. play other game and win!"
                                        alertVisible = true
                                    }
                                } label: {
                                    Image("open_game")
                                        .resizable()
                                        .frame(width: 170, height: 75)
                                }
                            }
                        }
                        
                        if !agnesGameUnlocked {
                            ZStack {
                                Image("carpet_game")
                                    .resizable()
                                    .frame(width: 200, height: 280)
                                    .opacity(0.7)
                                
                                Button {
                                    if balance >= 2000 {
                                        balance -= 2000
                                    } else {
                                        alertTitle = "Error"
                                        alertMessage = "You don't have enought credits for open this game. play other game and win!"
                                        alertVisible = true
                                    }
                                } label: {
                                    Image("open_game_2")
                                        .resizable()
                                        .frame(width: 170, height: 75)
                                }
                            }
                        }
                    }
                    .padding(.top, 52)
                }
                
                VStack {
                    HStack {
                        Button {
                            withAnimation(.easeInOut) {
                                musicState = !musicState
                            }
                        } label: {
                            Image("music_btn")
                                .resizable()
                                .frame(width: 62, height: 62)
                                .opacity(musicState ? 1 : 0.6)
                        }
                        
                        Button {
                            withAnimation(.easeInOut) {
                                soundState = !soundState
                            }
                        } label: {
                            Image("sound_btn")
                                .resizable()
                                .frame(width: 62, height: 62)
                                .opacity(soundState ? 1 : 0.6)
                        }
                        
                        Button {
                            withAnimation(.easeInOut) {
                                shopContentVisible = true
                            }
                        } label: {
                            Image("shop_btn")
                                .resizable()
                                .frame(width: 62, height: 62)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            Image("balance_background")
                                .resizable()
                                .frame(width: 140, height: 62)
                            
                            Text("\(balance)")
                                .font(.custom("Gidugu-Regular", size: 24))
                                .foregroundColor(.yellow)
                                .offset(x: -20)
                            
                            Button {
                                if balance <= 0 {
                                    balance = 500
                                }
                            } label: {
                                Image("plus")
                                    .resizable()
                                    .frame(width: 42, height: 42)
                            }
                            .offset(x: -60, y: 30)
                        }
                    }
                    .padding(.top)
                    
                    Spacer()
                }
                
                VStack {
                    Image("choose_game")
                        .resizable()
                        .frame(width: 250, height: 150)
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            if !UserDefaults.standard.bool(forKey: "taked_bonus") {
                                withAnimation(.easeInOut) {
                                    dailyBonusVisible = true
                                }
                            } else {
                                alertTitle = "Bonus claimed!"
                                alertMessage = "Next bonus will be available in 24 hours!"
                                alertVisible = true
                            }
                        } label: {
                            Image("daily_gift")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }
                    }
                }
                
                if dailyBonusVisible {
                    dailyBonusContent
                }
                
                if shopContentVisible {
                    shopContent
                }
            }
            .background(
                Image("main_background")
                    .resizable()
                    .frame(minWidth: UIScreen.main.bounds.width,
                           minHeight: UIScreen.main.bounds.height + 30)
                    .ignoresSafeArea()
            )
            .onAppear {
                musicState = UserDefaults.standard.bool(forKey: "music_state")
                soundState = UserDefaults.standard.bool(forKey: "sound_state")
                balance = UserDefaults.standard.integer(forKey: "balance")
                
                if (UserDefaults.standard.string(forKey: "cards_skin") ?? "").isEmpty {
                    UserDefaults.standard.set("white", forKey: "cards_skin")
                }
                selectedSkinCards = UserDefaults.standard.string(forKey: "cards_skin") ?? "white"
            }
            .onChange(of: musicState) {
                UserDefaults.standard.set($0, forKey: "music_state")
            }
            .onChange(of: soundState) {
                UserDefaults.standard.set($0, forKey: "sound_state")
            }
            .onChange(of: balance) {
                UserDefaults.standard.set($0, forKey: "balance")
            }
            .onChange(of: takedBonus) {
                UserDefaults.standard.set($0, forKey: "taked_bonus")
            }
            .alert(isPresented: $alertVisible) {
                Alert(title: Text(alertTitle), message: Text(alertMessage))
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    private var dailyBonusContent: some View {
        HStack {
            VStack {
                Image("daily_gift_dialog")
                    .resizable()
                    .frame(width: 500, height: 300)
                Button {
                    takedBonus = true
                    balance += 30
                    withAnimation(.linear) {
                        dailyBonusVisible = false
                    }
                } label: {
                    Image("take")
                        .resizable()
                        .frame(width: 120, height: 50)
                }
            }
            Spacer()
            VStack {
                Button {
                    withAnimation(.easeInOut) {
                        dailyBonusVisible = false
                    }
                } label: {
                    Image("close")
                        .resizable()
                        .frame(width: 82, height: 82)
                }
                .padding(.top)
                Spacer()
            }
        }
        .background(
            Image("daily_bonus_gift_bg")
                .resizable()
                .frame(minWidth: UIScreen.main.bounds.width, minHeight: UIScreen.main.bounds.height)
                .ignoresSafeArea()
        )
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.7)
                .ignoresSafeArea()
        )
    }
    
    private var shopContent: some View {
        ZStack {
            VStack {
                Image("shop_title")
                    .resizable()
                    .frame(width: 350, height: 170)
                Spacer()
            }
            HStack {
                ForEach(shopManager.allItems, id: \.self) { item in
                    ZStack {
                        Image(item)
                            .resizable()
                            .frame(width: 250, height: 150)
                        if selectedSkinCards == getSkinFromName(n: item) {
                            ZStack {
                                Image("shop_btn_bg")
                                    .resizable()
                                    .frame(width: 150, height: 60)
                                Text("SELECTED")
                                    .font(.custom("Gidugu-Regular", size: 24))
                                    .foregroundColor(.yellow)
                            }
                            .offset(y: 90)
                        } else {
                            if shopManager.purchasedItems.contains(ShopItem.getItemFromName(name: item)) {
                                Button {
                                    let cardName = getSkinFromName(n: item)
                                    selectedSkinCards = cardName
                                    UserDefaults.standard.set(cardName, forKey: "cards_skin")
                                } label: {
                                    ZStack {
                                        Image("shop_btn_bg")
                                            .resizable()
                                            .frame(width: 150, height: 60)
                                        Text("SELECT")
                                            .font(.custom("Gidugu-Regular", size: 24))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .offset(y: 90)
                            } else {
                                Button {
                                    let result = shopManager.purchaseItem(ShopItem.getItemFromName(name: item), withBalance: &balance)
                                    if !result {
                                        alertTitle = "Error purchase!"
                                        alertMessage = "You don't have enought coins to buy this skin! If you have 0 coins you can claim 500 coins for free by clicking on the plus button near of your balance and buy this skin."
                                        alertVisible = true
                                    } else {
                                        alertTitle = "Success!"
                                        alertMessage = "You've bought skin successfully!"
                                        alertVisible = true
                                    }
                                } label: {
                                    ZStack {
                                        Image("shop_btn_bg")
                                            .resizable()
                                            .frame(width: 150, height: 60)
                                        Text("BUY")
                                            .font(.custom("Gidugu-Regular", size: 24))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                .offset(y: 90)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            Rectangle()
                .fill(.black)
                .opacity(0.7)
                .ignoresSafeArea()
        )
    }
    
    private func getSkinFromName(n: String) -> String {
        let comp = n.components(separatedBy: "_")
        return comp[0]
    }
    
}

#Preview {
    ContentView()
}
