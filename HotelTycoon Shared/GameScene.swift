import SpriteKit

class GameScene: SKScene {
    
    private var hotel: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        setupBackground()
        setupHotel()
    }
    
    private func setupBackground() {
        let background = SKSpriteNode(color: .blue, size: CGSize(width: self.size.width, height: self.size.height))
        background.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        background.zPosition = -1
        addChild(background)
    }
    
    private func setupHotel() {
        hotel = SKSpriteNode(color: .brown, size: CGSize(width: 200, height: 300))
        hotel.position = CGPoint(x: self.size.width / 2, y: self.size.height / 2)
        hotel.name = "hotel"
        addChild(hotel)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            let touchedNode = atPoint(location)
            
            if touchedNode.name == "hotel" {
                print("Hotel tapped!")
                upgradeHotel()
            }
        }
    }
    
    private func upgradeHotel() {
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.1)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.1)
        hotel.run(SKAction.sequence([scaleUp, scaleDown]))
    }
}
