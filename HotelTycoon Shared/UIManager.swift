import SpriteKit

class UIManager {
    
    private weak var scene: GameScene?
    private var moneyLabel: SKLabelNode!
    private var dayLabel: SKLabelNode!
    private var timeLabel: SKLabelNode!
    
    var money: Int = 10_000 {
        didSet { updateMoneyDisplay() }
    }
    
    var currentHour: Int = 0
    var currentDay: Int = 1
    
    init(scene: GameScene) {
        self.scene = scene
    }
    
    func setupUI() {
        setupMoneyAndDayDisplay()
        setupTimeDisplay()
    }
    
    func updateMoneyDisplay() {
        moneyLabel.text = "Money: $\(money)"
    }

    
    private func setupMoneyAndDayDisplay() {
        guard let scene = scene else { return }
        
        dayLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        dayLabel.text = "Day: \(currentDay)"
        dayLabel.fontSize = 20
        dayLabel.position = CGPoint(x: 20, y: scene.size.height - 30)
        scene.addChild(dayLabel)
        
        moneyLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        moneyLabel.text = "Money: $\(money)"
        moneyLabel.fontSize = 20
        moneyLabel.position = CGPoint(x: 20, y: scene.size.height - 55)
        scene.addChild(moneyLabel)
    }
    
    private func setupTimeDisplay() {
        guard let scene = scene else { return }
        
        timeLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        timeLabel.text = "12:00 AM"
        timeLabel.fontSize = 20
        timeLabel.position = CGPoint(x: scene.size.width / 2, y: scene.size.height * 7 / 8)
        scene.addChild(timeLabel)
    }
    
    func updateTime() {
        currentHour += 1
        if currentHour >= 24 {
            currentHour = 0
            currentDay += 1
            dayLabel.text = "Day: \(currentDay)"
        }
        timeLabel.text = "\(currentHour):00"
    }
}
