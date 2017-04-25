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
    
    
    var socialDelegate: GameSceneSocialDelegate?
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
    
    override func didMove(to view: SKView) {

        
//        bgNode = self.childNodeWithName("new_bg1") as! SKSpriteNode

        musicOn = self.childNode(withName: "musicOn") as! MSButtonNode
        musicOff = self.childNode(withName: "musicOff") as! MSButtonNode
        

        print("__________MusicOff\(musicOff)" )

        
        soundsOn = self.childNode(withName: "soundsOn") as! MSButtonNode

        soundsOff = self.childNode(withName: "soundsOff") as! MSButtonNode
        
        let userDefaults = UserDefaults.standard
        let musicIsOn = userDefaults.bool(forKey: "musicSettings")
        let soundsAreOn = userDefaults.bool(forKey: "soundsSettings")
   
        if musicIsOn {
            musicOff.isHidden = true
            playBackgroundMusic()
        }
        else {
            musicOn.isHidden = true
        }
        
        if soundsAreOn {
            soundsOff.isHidden = true
        }
        else {
            soundsOn.isHidden = true
        }
        
        musicOn.selectedHandler = {
            //Turn music off
            self.musicOn.isHidden = true
            self.musicOff.isHidden = false
            
            if let music = self.backgroundMusic {
                music.removeFromParent()
            }
            
            userDefaults.set(false, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        musicOff.selectedHandler = {
            //Turn music on
            self.musicOn.isHidden = false
            self.musicOff.isHidden = true
            
            self.playBackgroundMusic()
            
            userDefaults.set(true, forKey: "musicSettings")
            userDefaults.synchronize()
        }
        
        soundsOn.selectedHandler = {
            //Turn sounds off
            self.soundsOn.isHidden = true
            self.soundsOff.isHidden = false
            
            userDefaults.set(false, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        
        soundsOff.selectedHandler = {
            //Turn sounds on
            self.soundsOn.isHidden = false
            self.soundsOff.isHidden = true
            
            userDefaults.set(true, forKey: "soundsSettings")
            userDefaults.synchronize()
        }
        /*

        */
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let scene = GameScene(fileNamed:"GameScene") {
            //passing the delegate to the user
            scene.socialDelegate = self.socialDelegate
            let skView = self.view!
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            
            skView.presentScene(scene)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {

    }
    
    func scrollSprite(_ sprite: SKSpriteNode, speed: CGFloat) {
        sprite.position.x -= speed
        
        if sprite.position.x <= sprite.size.width {
            sprite.position.x += sprite.size.width * 2
        }
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "SpaceGame", withExtension: "caf") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
    }
}
