//
//  HealthCounter.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/29/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import Foundation
import SpriteKit

class HealthCounter: SKNode{

    // synch up the life and heartCount

    var life : Int = 3 {
        didSet {
            print("life \(life) ")
            if isDead() {
                print("Dead")
            }
        }
    }
    var hearts = [SKSpriteNode]()
    let startingHeartCount: Int = 3
        
    override init() {
        super.init()
        
        life = startingHeartCount
        let heartTexture = SKTexture(imageNamed: "life_power_up_1")
        for i in 0..<startingHeartCount {
            let heart = SKSpriteNode(texture: heartTexture)
            hearts.append(heart)
            
            addChild(heart)
            heart.position.x = CGFloat(i) * heart.size.width
            
        }
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func decreaseHealth(){
        life -= 1
        print ("decrease Health !!!!!!")
    }
    
    func isDead()-> Bool {
        return life <= 0
    }

}
