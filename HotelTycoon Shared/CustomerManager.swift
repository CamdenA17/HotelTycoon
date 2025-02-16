import SpriteKit

class CustomerManager {
    
    private weak var scene: GameScene?
    private var customers: [(node: SKShapeNode, nights: Int)] = []
    private let pricePerNight = 500
    private var roomManager: RoomManager
    
    init(scene: GameScene, roomManager: RoomManager) {
        self.scene = scene
        self.roomManager = roomManager
    }
    
    func startClock() {
        let wait = SKAction.wait(forDuration: 10.0)
        let updateClock = SKAction.run {
            self.scene?.uiManager.updateTime()
            self.spawnCustomerIfNeeded()
        }
        let sequence = SKAction.sequence([wait, updateClock])
        scene?.run(SKAction.repeatForever(sequence))
    }
    
    private func spawnCustomerIfNeeded() {
        if let scene = scene, scene.uiManager.currentHour >= 8, scene.uiManager.currentHour <= 15 {
            let customer = SKShapeNode(circleOfRadius: 10)
            customer.fillColor = .red
            customer.position = CGPoint(x: -20, y: 75)
            scene.addChild(customer)
            let stayDuration = Int.random(in: 1...2)
            customers.append((customer, stayDuration))
            
            moveCustomerToFirstOrangeRoom(customer)
        }
    }
    
    private func moveCustomerToFirstOrangeRoom(_ customer: SKShapeNode) {
        if let firstOrangeRoom = roomManager.getAvailableRoom(ofColor: .orange) {
            let moveToRoom = SKAction.move(to: firstOrangeRoom.position, duration: 2.0)
            let wait = SKAction.wait(forDuration: 2.0)
            let moveToYellow = SKAction.run { self.moveCustomerToFirstYellowRoom(customer) }
            customer.run(SKAction.sequence([moveToRoom, wait, moveToYellow]))
        }
    }
    
    private func moveCustomerToFirstYellowRoom(_ customer: SKShapeNode) {
        if let firstYellowRoom = roomManager.getAvailableRoom(ofColor: .yellow) {
            let moveToRoom = SKAction.move(to: firstYellowRoom.position, duration: 2.0)
            let changeColor = SKAction.run { firstYellowRoom.color = .blue }
            customer.run(SKAction.sequence([moveToRoom, changeColor]))
        }
    }
}
