//
//  CharacterScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/21/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import SpriteKit
import CoreMotion
import GameplayKit


//struct PhysicsCategory {
//    static let None: UInt32              = 0
//    static let Player: UInt32            = 0b1      // 1
//    static let PlatformNormal: UInt32    = 0b10     // 2
//    static let PlatformBreakable: UInt32 = 0b100    // 4
//    static let CoinNormal: UInt32        = 0b1000   // 8
//    static let CoinSpecial: UInt32       = 0b10000  // 16
//    static let Edges: UInt32             = 0b100000 // 32
//}

class CharacterScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    let cameraNode = SKCameraNode()
    var bgNode = SKNode()
    var fgNode = SKNode()
    var player: SKSpriteNode!
    var lava: SKSpriteNode!
    var health: SKSpriteNode!
    var background: SKNode!
    var backHeight: CGFloat = 0.0

}