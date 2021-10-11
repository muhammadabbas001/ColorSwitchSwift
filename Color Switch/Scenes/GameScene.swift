//
//  GameScene.swift
//  Color Switch
//
//  Created by Dayal, Utkarsh on 23/04/21.
//

import SpriteKit

enum PlayColors{
    static let colors = [
        UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1.0),
        UIColor(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int{
    case red, yellow, green, blue
}

class GameScene: SKScene {
    
    var isGameOver = false
    var colorSwitch: SKSpriteNode!
    var switchState = SwitchState.red
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        self.scaleMode = .aspectFill
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -3.0)
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false
        addChild(colorSwitch)
        
        //Score Label
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        //Spawn Ball
        spawnBall()
    }
    
    func updateScoreLabel(){
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall(){
        
        currentColorIndex = Int(arc4random_uniform(UInt32(4)))
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: PlayColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        addChild(ball)
    }
    
    func turnWheel(){
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        }else{
            switchState = .red
        }
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.15))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameOver{
            turnWheel()
        }else{
            for touch in touches {
                     let location = touch.location(in: self)
                     let touchedNode = atPoint(location)
                     if touchedNode.name == "Try Again" {
                        let gameScene = MenuScene(size: view!.frame.size)
                        view!.presentScene(gameScene)
                     }
                }
        }
    }
    
    func gameOver(){
        isGameOver = true
        gameOverLabel()
        UserDefaults.standard.set(score, forKey: "RecentScore")
        if score > UserDefaults.standard.integer(forKey: "HighScore"){
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
    }
    
    func gameOverLabel(){
        let gameOverCard = SKSpriteNode(imageNamed: "card")
        gameOverCard.size = CGSize(width: 320, height: 167)
        gameOverCard.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverCard.zPosition = 3
        addChild(gameOverCard)
        
        //Game Over Label
        let gameOverLabel = SKLabelNode(text: "GameOver!")
        gameOverLabel.fontName = "AvenirNext-Bold"
        gameOverLabel.fontSize = 40.0
        gameOverLabel.color = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        gameOverLabel.colorBlendFactor = 1.0
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 4
        addChild(gameOverLabel)
        
        //Try Again Button
        let tryAgainBtn = SKSpriteNode(imageNamed: "arrow")
        tryAgainBtn.size = CGSize(width: 50, height: 50)
        tryAgainBtn.name = "Try Again"
        tryAgainBtn.position = CGPoint(x: gameOverLabel.frame.midX, y: gameOverLabel.position.y - gameOverLabel.frame.height-10)
        tryAgainBtn.zPosition = 4
        addChild(tryAgainBtn)
        animate(sprite: tryAgainBtn)
    }
    
    func animate(sprite: SKSpriteNode){
        let scaleUp = SKAction.scale(to: 1.2, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        sprite.run(SKAction.repeatForever(sequence))
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory{
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    run(SKAction.playSoundFileNamed("bling", waitForCompletion: false))
                    score += 1
                    updateScoreLabel()
                    ball.run(SKAction.fadeOut(withDuration: 0.25)) {
                        ball.removeFromParent()
                        self.spawnBall()
                    }
                }else{
                    gameOver()
                }
            }
        }
    }
}
