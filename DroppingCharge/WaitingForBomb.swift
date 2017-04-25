//
//  WaitingForBomb.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/13/16.
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
import GameplayKit

class WaitingForBomb: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    override func didEnter(
        from previousState: GKState?) {
        if previousState is WaitingForTap {
            
            print("_________________________waiting for bomb________")
            // Scale out title & ready label
            let scale = SKAction.scale(to: 0, duration: 0.4)
            //scene.fgNode.childNodeWithName("Title")!.runAction(scale)
            scene.fgNode.childNode(withName: "Ready")!.run(
                SKAction.sequence(
                    [SKAction.wait(forDuration: 0.2), scale]))
            
            // Bounce bomb
            let scaleUp = SKAction.scale(to: 1.6, duration: 0.25)
            let scaleDown = SKAction.scale(to: 1.7 , duration: 0.25)
            let sequence = SKAction.sequence([scaleUp, scaleDown])
            let repeatSeq = SKAction.repeatForever(sequence)
            scene.fgNode.childNode(withName: "Bomb")!.run(
                SKAction.unhide())
            scene.fgNode.childNode(withName: "Bomb")!.run(
                repeatSeq)
            
            
        }
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is Playing.Type
    }
    
    override func willExit(to nextState: GKState) {
        if nextState is Playing {
            let bomb = scene.fgNode.childNode(withName: "Bomb")!
            let explosion = scene.explosion(4.0)
            explosion.position = bomb.position
            scene.fgNode.addChild(explosion)
            bomb.removeFromParent()
        }
    }
}
