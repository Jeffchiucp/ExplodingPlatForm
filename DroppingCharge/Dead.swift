//
//  Dead.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/13/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
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


class Dead: GKState {
    unowned let scene: GameScene
    
    init(scene: SKScene) {
        self.scene = scene as! GameScene
        super.init()
    }
    
    //fixme when enter dead
    
    override func didEnterWithPreviousState(previousState: GKState?) {
        if previousState is Lava {
            scene.physicsWorld.contactDelegate = nil
            scene.player.physicsBody?.dynamic = false
            
            let moveUpAction = SKAction.moveByX(0, y: scene.size.height/2, duration: 0.5)
            moveUpAction.timingMode = .EaseOut
            let moveDownAction = SKAction.moveByX(0, y: -(scene.size.height * 1.0), duration: 1.5)
            moveDownAction.timingMode = .EaseIn
            let hiddenAction = SKAction.hide()
            
            //FixMe up and down
            let sequence = SKAction.sequence([ moveUpAction,moveDownAction])
            scene.player.runAction(sequence)
            scene.runAnim(scene.animDead)


        }
    }
    
    override func isValidNextState(stateClass: AnyClass) -> Bool {
        return stateClass is Idle.Type
    }
}
