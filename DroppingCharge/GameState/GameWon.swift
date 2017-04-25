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
    
    
    override func didEnter(from previousState: GKState?) {
        print( "Entering Game Won State   Entering Game Won State")
        if previousState is Playing {
        
            scene.highScoreLabel.isHidden = false
            scene.playAgainButton.isHidden = false
            scene.tapAnyWhereLabel.isHidden = true

            scene.socialFeatureButton.isHidden = false
            scene.twitterFeatureButton.isHidden = false
            print( scene.playAgainButton.position.x)
            print( scene.playAgainButton.position.y)
            print( scene.playAgainButton.zPosition)
            

//                        scene.setUpHighScoreLabel()
            
            
        }
    }
    
    
    
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return true // stateClass is WaitingForTap.Type
    }
}





