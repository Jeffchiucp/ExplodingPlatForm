//
//  GameWon.swift
//  DroppingCharge
//
//  Created by JeffChiu on 8/10/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameWon: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        print( "Entering Game Won State   Entering Game Won State")
        print( previousState)
        if previousState is Playing {
        
            scene.highScoreLabel.hidden = false
//            scene.gameOverLabel.hidden = false
            scene.playAgainButton.hidden = false

            print( scene.playAgainButton.position.x)
            print( scene.playAgainButton.position.y)
            print( scene.playAgainButton.parent)
            print( scene.playAgainButton.zPosition)
            

//                        scene.playerScoreUpdate()
//                        scene.setUpHighScoreLabel()
            
            
        }
    }
    
    
    
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return true // stateClass is WaitingForTap.Type
    }
}





