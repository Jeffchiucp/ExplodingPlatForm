//
//  GameScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/8/16.
//  Copyright (c) 2016 JeffChiu. All rights reserved.
//

import SpriteKit


struct PhysicsCategory {
    static let None: UInt32              = 0
    static let Player: UInt32            = 0b1      // 1
    static let PlatformNormal: UInt32    = 0b10     // 2
    static let PlatformBreakable: UInt32 = 0b100    // 4
    static let CoinNormal: UInt32        = 0b1000   // 8
    static let CoinSpecial: UInt32       = 0b10000  // 16
    static let Edges: UInt32             = 0b100000 // 32
}

class GameScene: SKScene {
    // MARK: - Properties
    var bgNode = SKNode()
    var fgNode = SKNode()
    var background: SKNode!
    var backHeight: CGFloat = 0.0
    var player: SKSpriteNode!
    var platform5Across: SKSpriteNode!
    var coinArrow: SKSpriteNode!
    var lastItemPosition = CGPointZero
    var lastItemHeight: CGFloat = 0.0
    var levelY: CGFloat = 0.0
    override func didMoveToView(view: SKView) {
        setupNodes()
    }
    func setupNodes() {
        let worldNode = childNodeWithName("World")!
        bgNode = worldNode.childNodeWithName("Background")!
        
    }
    


//set gameCamera

    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(x: position.x - overlapAmount()/2, y: position.y)
    }
    
    
    func updateCamera() {
        let cameraTarget = convertPoint(player.position,
                                        fromNode: fgNode)
        var targetPosition = CGPoint(x: getCameraPosition().x,
                                     y: cameraTarget.y - (scene!.view!.bounds.height * 0.40))
        
        setCameraPosition(CGPoint(x: size.width/2, y: newPosition.y))

    }


}