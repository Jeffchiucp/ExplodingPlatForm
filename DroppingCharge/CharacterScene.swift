//
//  CharacterScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/21/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//
//
/*
 * Copyright (c) 2015 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

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