//
//  GameOver.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/13/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameOver: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is Playing {
            let gameOver = SKSpriteNode(imageNamed: "Score")
            
            gameOver.position = scene.getCameraPosition() 
            gameOver.zPosition = 200
            scene.addChild(gameOver)
        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is WaitingForTap.Type
    }
}