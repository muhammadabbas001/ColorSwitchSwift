//
//  MenuScene.swift
//  Color Switch
//
//  Created by Muhammad Abbas on 09/10/2021.
//

import SpriteKit

class MenuScene: SKScene {
        
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        self.scaleMode = .aspectFill
        addLogo()
        addLabels()
    }
    
    func addLogo(){
        let logo = SKSpriteNode(imageNamed: "Podium")
        logo.size = CGSize(width: frame.width/4, height: frame.width/4)
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4)
        addChild(logo)
    }
    
    func addLabels(){
        let playLabel = SKLabelNode(text: "Tap to Play!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.color = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highScoreLabel = SKLabelNode(text: "High Score: \(UserDefaults.standard.integer(forKey: "HighScore"))")
        highScoreLabel.fontName = "AvenirNext-Bold"
        highScoreLabel.fontSize = 40.0
        highScoreLabel.color = UIColor.white
        highScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY-highScoreLabel.frame.size.height*4)
        addChild(highScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent Score: \(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 40.0
        recentScoreLabel.color = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
    }
    
    func animate(label: SKLabelNode){
//        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
//        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        label.run(SKAction.repeatForever(sequence))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.frame.size)
        view!.presentScene(gameScene)
    }
}
