//
//  MenuScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/19/16.
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

import Foundation


import Foundation
import SpriteKit

class MenuScene: SKScene {
    
    var playButton: MSButtonNode!
    //    var instructions = SKLabelNode(fontNamed: "Helvetica")
    //var title = SKSpriteNode(imageNamed: "title")
    var decoration = SKSpriteNode(imageNamed: "decoration")
    //    let backgroundMusic = SKAction.playSoundFileNamed("backgroundMusic.mp3", waitForCompletion: false)
    var backgroundMusic = SKAudioNode()
    
    override func didMove(to view: SKView) {
        
        backgroundColor = SKColor.black
        
        if let musicURL = Bundle.main.url(forResource: "backgroundMusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        //        // Instruction Label properties
        //        instructions.position = CGPoint(x: frame.size.width / 2, y: frame.size.height * 0.17)
        //        instructions.text = "Tap the right side of the screen to shoot, slide the blue square up and down to shoot at the enemy"
        //        instructions.fontSize = 20
        //        instructions.fontColor = SKColor.whiteColor()
        //        addChild(instructions)
        
        // Title label properties
        //title.position = CGPoint(x: 200, y: frame.size.height * 0.75)
        //title.size = CGSize(width: 250, height: 50)
        //addChild(title)
        
        // Play button properties
        //        playButton = MSButtonNode(color: SKColor.redColor(), size: CGSize(width: 500, height: 100))
        playButton = MSButtonNode(imageNamed: "playButton")
        playButton.size = CGSize(width: 275, height: 275)
        playButton.zPosition = 100
        playButton.position = CGPoint(x: frame.size.width * 0.715, y: frame.size.height * 0.64)
        addChild(playButton)
        
        // Decoration properties
        decoration.position = CGPoint(x: -100, y: frame.size.height / 2)
        decoration.size = CGSize(width: 1150, height: 600)
        decoration.anchorPoint.x = 0
        addChild(decoration)
        
        // When play button is tapped, the scene changes to GameScene
        playButton.selectedHandler = {
            
            let scene = GameScene(size: self.size)
            scene.scaleMode = .aspectFill
            self.view?.presentScene(scene)
            
        }
        
        playButton.state = .active
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }    
}
