import SwiftUI
import SpriteKit

let suitDataDesc = [
    "♠️": "Pikes",
    "♥️": "Hearts",
]

let rankDataDesc = [
    Rank.ace: "A",
    Rank.jack: "Jack",
    Rank.queen: "Queen",
    Rank.king: "King"
]

enum Suit: String {
    case spades = "♠️"
    case hearts = "♥️"
}

enum Rank: Int {
    case ace = 1, two, three, four, five, six, seven, eight, nine, ten, jack, queen, king
}

struct Card: Equatable {
    var id: String = UUID().uuidString
    var suit: Suit
    var rank: Rank
    var faceImageName: String = ""
    var isFaceUp: Bool = false
    var spriteNode: SKSpriteNode
    
    var description: String {
        return "\(suit.rawValue)\(rank)"
    }
    
    static func ==(l: Card, r: Card) -> Bool {
        return l.id == r.id
    }
}

class PasiansSpiderGameScene: SKScene {
    
    let maxCards = 104
    var currentCardCount = 52 {
        didSet {
            if currentCardCount >= 100 {
                dealsCards.removeFromParent()
            }
        }
    }
    var columns: [[Card]] = Array(repeating: [], count: 10)
    var deck: [Card] = []
    var drawPile: [Card] = []
    var completedSequences = 0
    var victoryLabel: SKLabelNode!
    
    private var infoButton: SKSpriteNode!
    private var restartButton: SKSpriteNode!
    private var dealsCards: SKSpriteNode!
    private var homeButton: SKSpriteNode!
    
    private var balance = UserDefaults.standard.integer(forKey: "balance") {
        didSet {
            balanceLabel.text = "\(balance)"
        }
    }
    private var balanceLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        size = CGSize(width: 1350, height: 750)
        setupDeck()
        setupDeck()
        dealCards()
        setupDrawPile()
        setupUI()
    }
    
    func setupDeck() {
        for suit in [Suit.spades, Suit.hearts] {
            for rankValue in 1...13 {
                if let rank = Rank(rawValue: rankValue) {
                    let allCardName = generateNameOfCard(suit: suit, rank: rank)
                    let card = Card(suit: suit, rank: rank, faceImageName: allCardName, isFaceUp: false, spriteNode: createCardNode(suit: suit, rank: rank))
                    deck.append(card)
                }
            }
        }
        deck.shuffle()
    }
    
    func createCardNode(suit: Suit, rank: Rank) -> SKSpriteNode {
        let allCardName = generateNameOfCard(suit: suit, rank: rank)
        let node = SKSpriteNode(imageNamed: allCardName)
        node.size = CGSize(width: 50, height: 70)
        return node
    }
    
    private func generateNameOfCard(suit: Suit, rank: Rank) -> String {
        var rankName = "\(rank.rawValue)"
        if rank == .ace || rank == .jack || rank == .queen || rank == .king {
            rankName = rankDataDesc[rank] ?? ""
        }
        let suitName = suitDataDesc[suit.rawValue] ?? ""
        let allCardName = "\(suitName)_\(rankName)_\(UserDefaults.standard.string(forKey: "cards_skin") ?? "white")"
        return allCardName
    }
    
    func dealCards() {
        // Reset columns array to ensure 9 columns
        columns = Array(repeating: [Card](), count: 9)
        
        for i in 0..<columns.count {
            let numberOfCards = i < 4 ? 5 : 4

            for j in 0..<numberOfCards {
                // Check if deck has enough cards
                guard !deck.isEmpty else {
                    return
                }

                var card = deck.removeLast()
                // Last card in each column should be face-up
                if j == numberOfCards - 1 {
                    card.isFaceUp = true
                }
                columns[i].append(card)

                // Create and position the card's sprite node
                let cardNode = card.isFaceUp ? card.spriteNode : SKSpriteNode(imageNamed: "face_up")
                cardNode.size = CGSize(width: 60, height: 100)
                cardNode.position = CGPoint(
                    x: CGFloat(size.width / 2 - 315) + 50 + CGFloat(i) * 70,
                    y: 600 - CGFloat(j) * 20
                )
                cardNode.zPosition = CGFloat(j)
                self.addChild(cardNode)
                card.spriteNode = cardNode
            }
        }
    }

    
    func setupDrawPile() {
        drawPile = deck
    }
    
    func setupUI() {
        let pasiansBackground = SKSpriteNode(imageNamed: "pasians_back_game")
        pasiansBackground.size = size
        pasiansBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        pasiansBackground.zPosition = -1
        addChild(pasiansBackground)
        
        let drawButton = SKLabelNode(text: "Draw")
        drawButton.position = CGPoint(x: -200, y: 300)
        drawButton.name = "drawButton"
        drawButton.fontSize = 24
        addChild(drawButton)
        
        victoryLabel = SKLabelNode(text: "You Win!")
        victoryLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        victoryLabel.fontSize = 40
        victoryLabel.alpha = 0
        addChild(victoryLabel)
        
        infoButton = SKSpriteNode(imageNamed: "info_btn")
        infoButton.position = CGPoint(x: size.width - 110, y: size.height - 110)
        infoButton.size = CGSize(width: 120, height: 210)
        addChild(infoButton)
        
        restartButton = SKSpriteNode(imageNamed: "restart_button")
        restartButton.position = CGPoint(x: 100, y: size.height - 110)
        restartButton.size = CGSize(width: 120, height: 210)
        addChild(restartButton)
        
        dealsCards = SKSpriteNode(imageNamed: "more_cards")
        dealsCards.position = CGPoint(x: 110, y: 80)
        dealsCards.size = CGSize(width: 120, height: 140)
        addChild(dealsCards)
        
        let balanceBackground = SKSpriteNode(imageNamed: "balance_background")
        balanceBackground.position = CGPoint(x: size.width - 150, y: size.height / 2)
        balanceBackground.size = CGSize(width: 200, height: 100)
        addChild(balanceBackground)
        
        balanceLabel = SKLabelNode(text: "\(balance)")
        balanceLabel.position = CGPoint(x: size.width - 190, y: size.height / 2 - 12)
        balanceLabel.fontColor = .yellow
        balanceLabel.fontSize = 32
        balanceLabel.fontName = "Gidugu-Regular"
        addChild(balanceLabel)
        
        homeButton = SKSpriteNode(imageNamed: "home")
        homeButton.position = CGPoint(x: size.width - 100, y: 80)
        homeButton.size = CGSize(width: 120, height: 80)
        addChild(homeButton)
    }
    
    func generateAdditionalCards() {
        // If current card count is less than max cards, generate new cards
        if currentCardCount < maxCards {
            let remainingCards = maxCards - currentCardCount
            let cardsToGenerate = min(remainingCards, 10)
            
            for _ in 0..<cardsToGenerate {
                if let newCard = drawCard() {
                    drawPile.append(newCard)
                }
            }
        }
    }
    
    func drawCard() -> Card? {
        let suits = [Suit.hearts, Suit.spades]
        let ranks = [Rank.ace, Rank.two, Rank.three, Rank.four, Rank.five, Rank.six, Rank.seven, Rank.eight, Rank.nine, Rank.ten, Rank.jack, Rank.queen, Rank.king]
        
        let suit = suits.randomElement()!
        let rank = ranks.randomElement()!
        
        return Card(suit: suit, rank: rank, spriteNode: createCardNode(suit: suit, rank: rank))
    }
    
    private func dealNewCards() {
        // Check if we can deal more cards without exceeding the max allowed
        let remainingCardsToDeal = 10
        guard currentCardCount + columns.count <= maxCards else {
            return
        }
        
        generateAdditionalCards()
        
        // Distribute one card to each column from the drawPile
        var dealtCards = 0
        for columnIndex in 0..<columns.count {
            if dealtCards < remainingCardsToDeal {
                guard !drawPile.isEmpty else {
                    return
                }
                
                var card = drawPile.removeLast()
                card.isFaceUp = true  // Additional cards are dealt face-up
                
                // Add the card to the column
                columns[columnIndex].append(card)
                
                // Create and position the sprite node for the card
                let initialPosition = dealsCards.position
                let targetPosition = CGPoint(
                    x: CGFloat(size.width / 2 - 315) + 50 + CGFloat(columnIndex) * 70,
                    y: 600 - CGFloat(columns[columnIndex].count - 1) * 20
                )
                
                let cardNode = card.spriteNode
                cardNode.position = initialPosition
                cardNode.size = CGSize(width: 60, height: 100)
                cardNode.zPosition = CGFloat(columns[columnIndex].count - 1)
                self.addChild(cardNode)
                card.spriteNode = cardNode
                
                let action = SKAction.move(to: targetPosition, duration: 0.3)
                let wait = SKAction.wait(forDuration: Double(columnIndex) * 0.1)
                let seq = SKAction.sequence([wait, action])
                cardNode.run(seq)
                
                dealtCards += 1
                currentCardCount += 1
                
                if dealtCards >= remainingCardsToDeal {
                    break
                }
            }
        }
    }
    
    func restartGame() -> PasiansSpiderGameScene {
        let newGame = PasiansSpiderGameScene()
        view?.presentScene(newGame)
        return newGame
    }
    
    // MARK: - Card Interaction Logic
    var selectedNode: SKSpriteNode?
    var underCard: Card?
    var originalPosition: CGPoint?
    var originalColumnIndex: Int?  // Храним индекс исходного столбца

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let touchedNode = atPoint(location)
        
        if touchedNode == dealsCards {
            dealNewCards()
            return
        }
        
        if touchedNode == homeButton {
            NotificationCenter.default.post(name: Notification.Name("HOME_GO"), object: nil)
            return
        }
        
        if touchedNode == infoButton {
            NotificationCenter.default.post(name: Notification.Name("INFO_GAME"), object: nil)
            return
        }
        
        if touchedNode == restartButton {
            NotificationCenter.default.post(name: Notification.Name("RESTART_GAME"), object: nil)
            return
        }
        
        if let cardNode = touchedNode as? SKSpriteNode, let card = findCard(at: cardNode) {
            selectedNode = cardNode
            originalPosition = cardNode.position
            originalColumnIndex = columns.firstIndex { $0.contains(where: { $0.spriteNode == cardNode }) }
            underCard = checkCardUnder(selectedNode!, originalColumnIndex!)
            cardNode.zPosition = 100  // Устанавливаем на верхний уровень
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, let selectedNode = selectedNode else { return }
        let location = touch.location(in: self)
        selectedNode.position = location
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let selectedNode = selectedNode, let originalColumnIndex = originalColumnIndex else { return }
        
        let targetColumnIndex = identifyTargetColumn(for: selectedNode.position)
        
        if let targetColumnIndex = targetColumnIndex {
            // Проверяем, если перемещение в столбец разрешено
            if checkIfValidMove(selectedNode) {
                // Перемещаем карту в новый столбец
                moveCardToColumn(selectedNode, targetColumnIndex: targetColumnIndex)
                
                if let cardUnder = underCard {
                    rotateCard(cardUnder)  // Поворот карты, если она рубашкой вверх
                }
            } else {
                // Если перемещение невалидное, возвращаем карту на исходное место
                animateCardReturn(selectedNode)
            }
        } else {
            // Если не перетащили в новый столбец, возвращаем карту на исходное место
            animateCardReturn(selectedNode)
        }
        
        //selectedNode.zPosition = 0  // Сбрасываем zPosition
        self.selectedNode = nil
    }

    
    func checkCardUnder(_ cardNode: SKSpriteNode, _ targetColumnIndex: Int) -> Card? {
        // Находим индекс карты в столбце
        guard let card = findCard(at: cardNode) else { return nil }
        
        // Проверяем, есть ли карта под этой картой в столбце
        let column = columns[targetColumnIndex]
        if let cardIndex = column.firstIndex(where: { $0.spriteNode == cardNode }), cardIndex > 0 {
            let cardUnder = column[cardIndex - 1]  // Карта под текущей картой
            return cardUnder
        }
        
        return nil
    }

    func rotateCard(_ card: Card) {
        // Поворот карты, если она лежит рубашкой вверх
        if !card.isFaceUp {
            let cardTexture = SKTexture(imageNamed: card.faceImageName)
            card.spriteNode.texture = cardTexture  // Изменяем текстуру на лицевую сторону
            // card.isFaceUp = false  // Меняем состояние карты
        }
    }
    
    func moveCardToColumn(_ cardNode: SKSpriteNode, targetColumnIndex: Int) {
        guard let card = findCard(at: cardNode) else { return }
        
        columns[originalColumnIndex!].removeAll { $0.spriteNode == cardNode }
        
        columns[targetColumnIndex].append(card)
        
        let targetColumnPosition = getColumnPosition(for: targetColumnIndex)
        cardNode.position = targetColumnPosition
        
        cardNode.zPosition = CGFloat(columns[targetColumnIndex].count + 1)
    }

    func identifyTargetColumn(for position: CGPoint) -> Int? {
        // Здесь вы должны реализовать логику, чтобы определить столбец,
        // в который перетаскивается карта, на основе позиции touch
        // Например, если карта находится в пределах какой-то зоны столбца:
        
        for (index, column) in columns.enumerated() {
            if columnArea(for: column).contains(position) {
                return index
            }
        }
        return nil
    }

    func columnArea(for column: [Card]) -> CGRect {
        let width: CGFloat = 100  // Ширина столбца
        let height: CGFloat = 600 // Высота столбца
        let index = columns.firstIndex(of: column)!
        
        return CGRect(x: CGFloat(size.width / 2 - 315) + 50 + CGFloat(index - 1) * 70, y: 0, width: width, height: height)
    }

    func getColumnPosition(for columnIndex: Int) -> CGPoint {
        // Возвращает позицию столбца, в который будет перемещена карта
        return CGPoint(x: CGFloat(size.width / 2 - 315) + 50 + CGFloat(columnIndex) * 70, y: 500)
    }

    func animateCardReturn(_ cardNode: SKSpriteNode) {
        guard let originalPosition = originalPosition else { return }
        let moveBackAction = SKAction.move(to: originalPosition, duration: 0.3)
        cardNode.run(moveBackAction)
    }
    
    func checkForCompleteSequence() {
        for i in 0..<columns.count {
            let lastCards = columns[i].suffix(13)
            if isCompleteSequence(lastCards) {
                columns[i].removeLast(13)
                completedSequences += 1
            }
        }
    }
    
    func checkVictoryCondition() {
        if completedSequences == 8 {
            victoryLabel.run(SKAction.fadeIn(withDuration: 1.0))
        }
    }
    
    func isCompleteSequence(_ cards: ArraySlice<Card>) -> Bool {
        guard cards.count == 13 else { return false }
        for (index, card) in cards.enumerated() {
            if card.rank.rawValue != 13 - index || card.suit != cards.first?.suit {
                return false
            }
        }
        return true
    }
    
    func findCard(at node: SKNode) -> Card? {
        for column in columns {
            if let card = column.first(where: { $0.spriteNode == node }) {
                return card
            }
        }
        return nil
    }
    
    func checkIfValidMove(_ cardNode: SKSpriteNode) -> Bool {
//        // Find the card in the columns array
//        guard let movingCard = findCard(at: cardNode) else { return false }
//        
//        // Find the column this card currently belongs to
//        guard let (fromColumnIndex, fromCardIndex) = findCardLocation(card: movingCard) else { return false }
//        
//        // Get the sequence of cards being moved (from the moving card to the end of the column)
//        let movingStack = Array(columns[fromColumnIndex][fromCardIndex...])
//        
//        // Identify the target column based on where the card is dragged
//        let targetColumn = identifyTargetColumn(for: cardNode.position)
//        
//        // If no target column is found, return false
//        guard let targetColumnIndex = targetColumn else { return false }
//        
//        // Check if the target column is empty
//        if columns[targetColumnIndex].isEmpty {
//            return true  // Moving any stack to an empty column is allowed
//        }
//        
//        // Get the bottom card of the target column
//        guard let targetBottomCard = columns[targetColumnIndex].last else { return false }
//        
//        // Validate that the move follows the game's rules
//        for (index, card) in movingStack.enumerated() {
//            // Cards in the moving stack must follow descending ranks and matching suits
//            if card.suit != targetBottomCard.suit || card.rank.rawValue != targetBottomCard.rank.rawValue - (index + 1) {
//                return false
//            }
//        }
        
        // If all checks pass, return true
        return true
    }

    // Helper function to find the column and index of a card
    func findCardLocation(card: Card) -> (columnIndex: Int, cardIndex: Int)? {
        for (columnIndex, column) in columns.enumerated() {
            if let cardIndex = column.firstIndex(where: { $0.id == card.id }) {
                return (columnIndex, cardIndex)
            }
        }
        return nil
    }

    // Helper function to identify the target column based on card's current position
//    func identifyTargetColumn(for position: CGPoint) -> Int? {
//        // Calculate the target column based on card's x-position
//        let columnWidth: CGFloat = 70.0  // Assume each column has a fixed width
//        let columnIndex = Int((position.x + (size.width / 2)) / columnWidth)
//        
//        if columnIndex >= 0 && columnIndex < columns.count {
//            return columnIndex
//        }
//        return nil
//    }
    
}

#Preview {
    VStack {
        SpriteView(scene: PasiansSpiderGameScene())
            .ignoresSafeArea()
    }
}


extension Array {
    subscript(safe index: Int) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
