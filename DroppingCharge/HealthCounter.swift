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

    // synch up the life and Heart
    // isDead should also check the array is empty
    // when to remove my array
    // remove it out of array, then it's good
    
    static let maxHeartCount: Int = 4
    
//    var life : Int = maxHeartCount {
//        didSet {
//            print("life \(life) ")
//            if isDead() {
//                print("Dead")
//            }
//       }
//    }
    private var _life: Int = 0
    /// return read only
    var life: Int {
            return _life
    }
    /// Max Helath is 5  heart is the Sprit */
    var hearts = [SKSpriteNode]()
    
    override init() {
        super.init()
        //caling the heartGenerator
        heartGenerator()
    }
        
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// - remove 1 heart  */
    func removeHeart(){
        _life -= 1
        hearts.last!.removeFromParent()
        hearts.removeLast()
    }
    
    func addHeart(){
        _life += 1
        let heartTexture = SKTexture(imageNamed: "life_power_up_1")

        let heart = SKSpriteNode(texture: heartTexture)
        let i = hearts.count
        hearts.append(heart)
        
        addChild(heart)
        heart.position.x = CGFloat(i) * heart.size.width
    }
    // set up the array that counts the number of health and hearts */

    func heartGenerator(){
//        life = HealthCounter.maxHeartCount
        
        if life > HealthCounter.maxHeartCount {
            print("hello")
        }
        else {

        for _ in 0..<HealthCounter.maxHeartCount {
           self.addHeart()
        }

    }
    }
    
    func isDead()-> Bool {
        return life <= 0
    }



}
