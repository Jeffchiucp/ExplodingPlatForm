//
//  StartScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 8/7/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import SpriteKit
import GameplayKit

class StartScene: SKScene {
    var musicOn: MSButtonNode!
    var musicOff: MSButtonNode!
    var soundsOn: MSButtonNode!
    var soundsOff: MSButtonNode!
    var bgNode = SKNode()
    var Sprite1 = SKNode()
    var background = SKNode()
    
    var backgroundMusic: SKAudioNode!
    
    let fixedDelta: CFTimeInterval = 1.0/60.0
    let scrollSpeed: CGFloat = 160
    
    override func didMoveToView(view: SKView) {

        
//        bgNode = self.childNodeWithName("new_bg1") as! SKSpriteNode

        musicOn = self.childNodeWithName("musicOn") as! MSButtonNode
        musicOff = self.childNodeWithName("musicOff") as! MSButtonNode
        

        print("__________MusicOff\(musicOff)" )

        
        soundsOn = self.childNodeWithName("soundsOn") as! MSButtonNode

        soundsOff = self.childNodeWithName("soundsOff") as! MSButtonNode
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let musicIsOn = userDefaults.boolForKey("musicSettings")
        let soundsAreOn = userDefaults.boolForKey("soundsSettings")
   
        if musicIsOn {
            musicOff.hidden = true
            playBackgroundMusic()
        }
        else {
            musicOn.hidden = true
        }
        
        if soundsAreOn {
            soundsOff.hidden = true
        }
        else {
            soundsOn.hidden = true
        }
        
        musicOn.selectedHandler = {
            //Turn music off
            self.musicOn.hidden = true
            self.musicOff.hidden = false
            
            if let music = self.backgroundMusic {
                music.removeFromParent()
            }
            
            userDefaults.setBool(false, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.hidden = false
            self.musicOff.hidden = true
            
            self.playBackgroundMusic()
            
            userDefaults.setBool(true, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.hidden = true
            self.soundsOff.hidden = false
            
            userDefaults.setBool(false, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.hidden = false
            self.soundsOff.hidden = true
            
            userDefaults.setBool(true, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        /*

        */
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            let skView = self.view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func update(currentTime: NSTimeInterval) {

    }
    
    func scrollSprite(sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func playBackgroundMusic() {
        if let musicURL = NSBundle.mainBundle().URLForResource("SpaceGame", withExtension: "caf") {
            backgroundMusic = SKAudioNode(URL: musicURL)
            addChild(backgroundMusic)
        }
    }
}