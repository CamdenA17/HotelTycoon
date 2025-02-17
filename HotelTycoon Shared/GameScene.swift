import UIKit
import SpriteKit

class GameScene: SKScene {
    
    private var hotelButton1: SKSpriteNode!
    private var hotelButton2: SKSpriteNode!
    private var moneyLabel: SKLabelNode!
    private var dayLabel: SKLabelNode!
    private var timeLabel: SKLabelNode!
    private var rooms: [SKSpriteNode] = []
    private var customers: [SKShapeNode] = []
    
    private var money: Int = 10_000 {
        didSet { updateMoneyDisplay() }
    }
    
    private var currentHour: Int = 0
    private var currentDay: Int = 1
    private let secondsPerGameHour: TimeInterval = 10.0
    private let orangeRoomCost = 2000
    private let yellowRoomCost = 1000
    private let maxFloors = 5
    private let maxRoomsPerFloor = 3
    private let roomSize = CGSize(width: 80, height: 50)
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupGrass()
        setupHotelButtons()
        setupMoneyAndDayDisplay()
        setupTimeDisplay()
        startClock()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(color: UIColor.systemBlue, size: CGSize(width: self.size.width, height: self.size.height))
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -2
        addChild(background)
    }
    
    private func setupGrass() {
        let grass = SKSpriteNode(color: .green, size: CGSize(width: self.size.width, height: 50))
        grass.position = CGPoint(x: self.size.width / 2, y: 25)
        grass.zPosition = -1
        addChild(grass)
    }
    
    private func setupHotelButtons() {
        hotelButton1 = SKSpriteNode(color: .brown, size: CGSize(width: 100, height: 50))
        hotelButton1.position = CGPoint(x: self.size.width - 70, y: self.size.height - 50)
        hotelButton1.name = "hotelButton1"
        addChild(hotelButton1)
        
        let label1 = SKLabelNode(fontNamed: "Avenir-Bold")
        label1.text = "$2000"
        label1.fontSize = 16
        label1.fontColor = .white
        label1.position = CGPoint(x: 0, y: -5)
        label1.zPosition = 1
        hotelButton1.addChild(label1)
        
        hotelButton2 = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 50))
        hotelButton2.position = CGPoint(x: self.size.width - 70, y: self.size.height - 110)
        hotelButton2.name = "hotelButton2"
        addChild(hotelButton2)
        
        let label2 = SKLabelNode(fontNamed: "Avenir-Bold")
        label2.text = "$1000"
        label2.fontSize = 16
        label2.fontColor = .white
        label2.position = CGPoint(x: 0, y: -5)
        label2.zPosition = 1
        hotelButton2.addChild(label2)
    }
    
    private func setupMoneyAndDayDisplay() {
        dayLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        dayLabel.text = "Day: \(currentDay)"
        dayLabel.fontSize = 20
        dayLabel.fontColor = .white
        dayLabel.position = CGPoint(x: 20, y: self.size.height - 30)
        dayLabel.horizontalAlignmentMode = .left
        dayLabel.zPosition = 1
        addChild(dayLabel)
        
        moneyLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        moneyLabel.text = "Money: $\(money)"
        moneyLabel.fontSize = 20
        moneyLabel.fontColor = .white
        moneyLabel.position = CGPoint(x: 20, y: self.size.height - 55)
        moneyLabel.horizontalAlignmentMode = .left
        moneyLabel.zPosition = 1
        addChild(moneyLabel)
    }
    
    private func setupTimeDisplay() {
        timeLabel = SKLabelNode(fontNamed: "Avenir-Bold")
        timeLabel.text = formatTime()
        timeLabel.fontSize = 20
        timeLabel.fontColor = .white
        timeLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height * 7 / 8)
        timeLabel.horizontalAlignmentMode = .center
        timeLabel.zPosition = 1
        addChild(timeLabel)
    }
    
    private func updateMoneyDisplay() {
        moneyLabel.text = "Money: $\(money)"
    }
    
    private func startClock() {
        let wait = SKAction.wait(forDuration: secondsPerGameHour)
        let updateClock = SKAction.run {
            self.currentHour += 1
            if self.currentHour >= 24 {
                self.currentHour = 0
                self.currentDay += 1
                self.dayLabel.text = "Day: \(self.currentDay)"
            }
            self.timeLabel.text = self.formatTime()
            self.spawnCustomerIfNeeded()
        }
        let sequence = SKAction.sequence([wait, updateClock])
        run(SKAction.repeatForever(sequence))
    }
    
    private func formatTime() -> String {
        let hour = currentHour % 24
        let period = hour < 12 ? "AM" : "PM"
        let displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour)
        return "\(displayHour):00 \(period)"
    }
    
    private func spawnCustomerIfNeeded() {
        if currentHour >= 8 && currentHour <= 15 {
            let customer = SKShapeNode(circleOfRadius: 10)
            customer.fillColor = .red
            customer.position = CGPoint(x: -20, y: 75)
            customer.name = "customer"
            addChild(customer)
            customers.append(customer)
            
            moveCustomerToFirstOrangeRoom(customer)
        }
    }
    
    private func moveCustomerToFirstOrangeRoom(_ customer: SKShapeNode) {
        if let firstOrangeRoom = rooms.first(where: { $0.color == UIColor.orange }) {
            let moveToRoom = SKAction.move(to: firstOrangeRoom.position, duration: 2.0)
            let wait = SKAction.wait(forDuration: 2.0)
            let moveToYellow = SKAction.run { self.moveCustomerToFirstYellowRoom(customer) }
            customer.run(SKAction.sequence([moveToRoom, wait, moveToYellow]))
        }
    }
    
    private func moveCustomerToFirstYellowRoom(_ customer: SKShapeNode) {
        if let firstYellowRoom = rooms.first(where: { $0.color == UIColor.yellow }) {
            let moveToRoom = SKAction.move(to: firstYellowRoom.position, duration: 2.0)
            let changeColor = SKAction.run { firstYellowRoom.color = UIColor.blue }
            customer.run(SKAction.sequence([moveToRoom, changeColor]))
        }
    }
    
    func addRoom(roomColor: UIColor, cost: Int) {
        if money >= cost {
            let floorCount = rooms.count / maxRoomsPerFloor
            if floorCount < maxFloors {
                let room = SKSpriteNode(color: roomColor, size: roomSize)
                let xOffset = self.size.width / 2 - 80 + CGFloat(rooms.count % maxRoomsPerFloor) * 80
                let yOffset = 75 + CGFloat(floorCount) * 60

                room.position = CGPoint(x: xOffset, y: yOffset)
                rooms.append(room)
                addChild(room)
                
                money -= cost  // Deduct room cost from money
            }
        }
    }

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "hotelButton1" {
                addRoom(roomColor: UIColor.orange, cost: orangeRoomCost)
            } else if touchedNode.name == "hotelButton2" {
                addRoom(roomColor: UIColor.yellow, cost: yellowRoomCost)
            }
        }
    }
}
