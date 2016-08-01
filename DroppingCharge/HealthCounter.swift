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
    // isDead should also check the array is empty
    // when to remove my array
    // remove it out of array, then it's good
    var life : Int = 3 {
        didSet {
            print("life \(life) ")
            if isDead() {
                print("Dead")
            }
       }
    }
    
    

    // heart is the Sprit */
    var hearts = [SKSpriteNode]()
    let startingHeartCount: Int = 3
        
    override init() {
        super.init()
        
        //caling the heartGenerator
        heartGenerator()
        
        
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - remove heart and life for player */
    func decreaseHealth(){
        life -= 1
        hearts.last!.removeFromParent()
        hearts.removeLast()
        print ("decrease Health !!!!!!")
    }
    
    // set up the array that counts the number of health and hearts */

    func heartGenerator(){
        life = startingHeartCount
        let heartTexture = SKTexture(imageNamed: "life_power_up_1")
        
        for i in 0..<startingHeartCount {
            let heart = SKSpriteNode(texture: heartTexture)
            hearts.append(heart)
            
            addChild(heart)
            heart.position.x = CGFloat(i) * heart.size.width
        }

    }
    
    func isDead()-> Bool {
        return life <= 0
    }



}
