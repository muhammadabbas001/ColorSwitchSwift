//
//  GameViewController.swift
//  Color Switch
//
//  Created by Dayal, Utkarsh on 23/04/21.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene = MenuScene(size: view.bounds.size)
            scene.scaleMode = .aspectFill
            view.presentScene(scene)
            view.ignoresSiblingOrder = false
        }
    }
}
