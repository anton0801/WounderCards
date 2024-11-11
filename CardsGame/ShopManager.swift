import Foundation

enum ShopItem: String {
    case skinA
    case skinB
    
    var price: Int {
        switch self {
        case .skinA: return 100
        case .skinB: return 200
        }
    }
    
    static func getItemFromName(name: String) -> ShopItem {
        if name == "skin1_shop" {
            return .skinA
        }
        return .skinB
    }
}

class ShopManager: ObservableObject {
    
    // Store purchased items in UserDefaults
    private let purchasedItemsKey = "purchasedItems"
    
    init() {
        loadPurchasedItems()
    }
    
    var allItems = [
        "skin1_shop",
        "skin2_shop"
    ]
    // Set to store purchased items
    @Published var purchasedItems: Set<ShopItem> = []
    
    // Method to purchase an item
    func purchaseItem(_ item: ShopItem, withBalance balance: inout Int) -> Bool {
        // Check if item is already purchased
        guard !purchasedItems.contains(item) else {
            return false
        }
        
        // Check if the user has enough balance
        guard balance >= item.price else {
            return false
        }
        
        // Deduct the price, mark item as purchased, and save
        balance -= item.price
        purchasedItems.insert(item)
        savePurchasedItems()
        
        return true
    }
    
    // Check if an item is already purchased
    func isPurchased(_ item: ShopItem) -> Bool {
        return purchasedItems.contains(item)
    }
    
    // Load purchased items from UserDefaults
    private func loadPurchasedItems() {
        if let savedItems = UserDefaults.standard.array(forKey: purchasedItemsKey) as? [String] {
            purchasedItems = Set(savedItems.compactMap { ShopItem(rawValue: $0) })
        }
    }
    
    // Save purchased items to UserDefaults
    private func savePurchasedItems() {
        let itemsToSave = purchasedItems.map { $0.rawValue }
        UserDefaults.standard.set(itemsToSave, forKey: purchasedItemsKey)
    }
}
