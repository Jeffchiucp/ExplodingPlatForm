//
//  GameScene.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/7/16.
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
import CoreMotion
import GameplayKit


let debugFlag = false


struct PhysicsCategory {
    static let None: UInt32              = 0
    static let Player: UInt32            = 0b1      // 1
    static let PlatformNormal: UInt32    = 0b10     // 2
    static let PlatformBreakable: UInt32 = 0b100    // 4
    static let CoinNormal: UInt32        = 0b1000   // 8
    static let CoinSpecial: UInt32       = 0b10000  // 16
    static let Edges: UInt32             = 0b100000 // 32
    static let Heart: UInt32             = 0b1000000 // 64
    
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: - Properties
    let cameraNode = SKCameraNode()
    var bgNode = SKNode()
    var fgNode = SKNode()
    var player: SKSpriteNode!
    var lava: SKSpriteNode!
    var health: SKSpriteNode!
    var background: SKNode!
    var backHeight: CGFloat = 0.0
    
    //testing
    var scoreLabel: SKLabelNode!
    var highScoreLabel : SKLabelNode!
    
    var platform5Across: SKSpriteNode! = nil
    var coinArrow: SKSpriteNode!
    var platformArrow: SKSpriteNode!
    var platformDiagonal: SKSpriteNode!
    var breakArrow: SKSpriteNode!
    var break5Across: SKSpriteNode!
    var breakDiagonal: SKSpriteNode!
    //adding Coin
    var coin5Across: SKSpriteNode!
    var coinDiagonal: SKSpriteNode!
    var coinCross: SKSpriteNode!
    var coinS5Across: SKSpriteNode!
    var coinSDiagonal: SKSpriteNode!
    var coinSCross: SKSpriteNode!
    var coinSArrow: SKSpriteNode!
    var coinRef: SKSpriteNode!
    var coinCrossScene: SKSpriteNode!
    
    var lastItemPosition = CGPointZero
    var lastItemHeight: CGFloat = 0.0
    var levelY: CGFloat = 0.0
    let motionManager = CMMotionManager()
    var xAcceleration = CGFloat(0)
    var lastUpdateTimeInterval: NSTimeInterval = 0
    var deltaTime: NSTimeInterval = 0
    var isPlaying: Bool = false
    
    var timeSinceLastExplosion: NSTimeInterval = 0
    var timeForNextExplosion: NSTimeInterval = 1.0
    
    var animJump: SKAction! = nil
    var animFall: SKAction! = nil
    var animSteerLeft: SKAction! = nil
    var animSteerRight: SKAction! = nil
    var curAnim: SKAction? = nil
    var healthBar = SKSpriteNode(color: SKColor.redColor(), size: CGSize(width: 1000, height: 40))

    //var coin = SKSpriteNode
    var playerTrail: SKEmitterNode!

    // Don't need the MaxHealth anymore
    let maxHealth: CGFloat = 100
    var currentHealth: CGFloat = 100
    
    var coinSpecialRef: SKSpriteNode!
    //Set the ScoreLabel
    
    var heartRef: SKSpriteNode!

    // gameGain value
    
    let gameGain: CGFloat = 2.5
    var coinTextures = [SKTexture]()

    
    let coinNode = SKNode()
    let coin = SKSpriteNode()

    
    func makeCoin() -> SKNode {
        
        
        let animate = SKAction.animateWithTextures(coinTextures, timePerFrame: 0.2, resize: true, restore: false)
        let forever = SKAction.repeatActionForever(animate)
        coin.runAction(forever)
        
        return coin
    }
    
    lazy var gameState: GKStateMachine = GKStateMachine(states: [
        WaitingForTap(scene: self),
        WaitingForBomb(scene: self),
        Playing(scene: self),
        GameOver(scene: self)
        ])
    
    lazy var playerState: GKStateMachine = GKStateMachine(states: [
        Idle(scene: self),
        Jump(scene: self),
        Fall(scene: self),
        Lava(scene: self),
        Dead(scene: self)
        ])
    
    var lives = 4
    // added instruction
    var shouldShowInstructions = true
    let instructions = SKSpriteNode(imageNamed: "instruction_ToRight")
    
    var squishAndStretch: SKAction! = nil

    var scorePoint: Int = 0 {
        didSet {
            scoreLabel.text = "\(scorePoint)"
            if scorePoint % 10 == 0 {
                if scorePoint == 9 {
                    print("__________1________________")
                }
                
                // CHANGE THIS AFTER TESTING
                if scorePoint == 10 {
                    print("__________10________________")
                }
            }
        }
        
    }
    
    
    
    //added BackgroundMusicNode
    var backgroundMusic: SKAudioNode!
    var bgMusicAlarm: SKAudioNode!
    
    func updateLevel() {
        let cameraPos = getCameraPosition()
        if cameraPos.y > levelY - (size.height * 0.55) {
            createBackgroundNode()
            while lastItemPosition.y < levelY {
                addRandomOverlayNode()
            }
        }
    }
    
    let soundExplosions = [
        SKAction.playSoundFileNamed("explosion1.wav", waitForCompletion: false),
        SKAction.playSoundFileNamed("explosion2.wav", waitForCompletion: false),
        SKAction.playSoundFileNamed("explosion3.wav", waitForCompletion: false),
        SKAction.playSoundFileNamed("explosion4.wav", waitForCompletion: false)
    ]
    
    
    
//    func makeCoinBlock() -> SKNode {
//        let coinNode = SKNode()
//        for row in 0 ..< coinBlock.count {
//            for col in 0 ..< coinBlock[row].count {
//                if coinBlock[row][col] == 1 {
//                    let coin = makeCoin()
//                    coinNode.addChild(coin)
//                    coin.position.x = CGFloat(col) * coinSize.width
//                    coin.position.y = CGFloat(-row) * coinSize.height
//                    
//                }
//            }
//        }
//    
//        return coinNode
//    }
//    
    override func didMoveToView(view: SKView) {
        
//        for i in 1...4 {
//            coinTextures.append(SKTexture(imageNamed: "Coin_\(i)"))
//        }
//        
//        let block = makeCoinBlock()
//        addChild(block)
//        block.position.x = 100
//        block.position.y = 300
        
        
        setupNodes()
        setupLevel()
        // This code will center the camera. To make sure that the camera is tracking y
        setCameraPosition(CGPoint(x: size.width/2, y: size.height/2))
        updateCamera()
        setupCoreMotion()
        physicsWorld.contactDelegate = self
        
        playBackgroundMusic("SpaceGame.caf")
        
        playerState.enterState(Idle)
        gameState.enterState(WaitingForTap)
        //setupPlayer()
        animJump = setupAnimWithPrefix("Jump_00", start: 1, end: 7, timePerFrame: 0.1)
        animFall = setupAnimWithPrefix("Glide_00_", start: 1, end: 7, timePerFrame: 0.1)
        animSteerLeft = setupAnimWithPrefix("Jump_00", start: 1, end: 9, timePerFrame: 0.2)
        animSteerRight = setupAnimWithPrefix("Jump_00", start: 1, end: 9, timePerFrame: 0.2)
        /////////////////////
        
        instructions.hidden = true
        
        instructions.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
        instructions.size = CGSize(width: frame.size.width, height: 650)
        instructions.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        instructions.zPosition = 100
        addChild(instructions)
        
        if shouldShowInstructions {
            shouldShowInstructions = false
            let instructionSpawn = SKAction.runBlock({
                self.instructions.hidden = false
            })
//            let instructionDisapper = SKAction.runBlock({
//                self.instructions.hidden = true
//            })
        }
        
    }
    
    

    func setupAnimWithPrefix(prefix: String,
                             start: Int,
                             end: Int,
                             timePerFrame: NSTimeInterval) -> SKAction {
        var textures = [SKTexture]()
        for i in start...end {
            textures.append(SKTexture(imageNamed: "\(prefix)\(i)"))
        }
        return SKAction.animateWithTextures(textures, timePerFrame: timePerFrame, resize: false, restore: true)
    }
    

    
    //initiate the player with physics and Collision
    func setupPlayer() {
        player.physicsBody = SKPhysicsBody(circleOfRadius:
            player.size.width * 0.1)
        player.anchorPoint.y = -0.1
        player.physicsBody!.dynamic = false
        player.physicsBody!.allowsRotation = false
        player.physicsBody!.categoryBitMask = PhysicsCategory.Player
        player.physicsBody!.categoryBitMask = 0
        player.physicsBody!.collisionBitMask = 0
    }
    
    // Set up the Core Motion for the Game Player
    
    func setupCoreMotion() {
        motionManager.accelerometerUpdateInterval = 0.2
        let queue = NSOperationQueue()
        motionManager.startAccelerometerUpdatesToQueue(queue, withHandler:
            {
                accelerometerData, error in
                guard let accelerometerData = accelerometerData else {
                    return
                }
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = (CGFloat(acceleration.x) * 0.75) +
                    (self.xAcceleration * 0.25)
        })
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event:
        UIEvent?) {
        switch gameState.currentState {
        case is WaitingForTap:
            gameState.enterState(WaitingForBomb)
            // Switch to playing state
            self.runAction(SKAction.waitForDuration(2.0),
                           completion:{
                            self.gameState.enterState(Playing)
            })
            
        case is GameOver:
            let newScene = GameScene(fileNamed:"GameScene")
            newScene!.scaleMode = .AspectFill
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            self.view?.presentScene(newScene!, transition: reveal)
            
            
        default:
            break
        } }
    
    
    func bombDrop() {
        let scaleUp = SKAction.scaleTo(1.8, duration: 0.25)
        let scaleDown = SKAction.scaleTo(1.8, duration: 0.25)
        let sequence = SKAction.sequence([scaleUp, scaleDown])
        let repeatSeq = SKAction.repeatActionForever(sequence)
        fgNode.childNodeWithName("Bomb")!.runAction(SKAction.unhide())
        fgNode.childNodeWithName("Bomb")!.runAction(repeatSeq)
        runAction(SKAction.sequence([
            SKAction.waitForDuration(2.0),
            SKAction.runBlock(startGame)
            ]))
    }
    func startGame() {
        //fgNode.childNodeWithName("Title")!.removeFromParent()
        fgNode.childNodeWithName("Bomb")!.removeFromParent()
        isPlaying = true
        player.physicsBody!.dynamic = true
        superBoostPlayer()
    }
    
    func updatePlayer() {
        // Set velocity based on core motion
        player.physicsBody?.velocity.dx = xAcceleration * 1000.0
        // Wrap player around edges of screen
        var playerPosition = convertPoint(player.position,
                                          fromNode: fgNode)
        if playerPosition.x < -player.size.width/2 {
            playerPosition = convertPoint(CGPoint(x: size.width +
                player.size.width/2, y: 0.0), toNode: fgNode)
            player.position.x = playerPosition.x
        }
        else if playerPosition.x > size.width + player.size.width/2 {
            playerPosition = convertPoint(CGPoint(x:
                -player.size.width/2, y: 0.0), toNode: fgNode)
            player.position.x = playerPosition.x
        }
        
        // Set Player State
        if player.physicsBody?.velocity.dy < 0 {
            playerState.enterState(Fall)
            
        } else {
            playerState.enterState(Jump)
        }
    }
    
    func overlapAmount() -> CGFloat {
        guard let view = self.view else {
            return 0 }
        let scale = view.bounds.size.height / self.size.height
        let scaledWidth = self.size.width * scale
        let scaledOverlap = scaledWidth - view.bounds.size.width
        return scaledOverlap / scale
    }
    func getCameraPosition() -> CGPoint {
        return CGPoint(
            x: cameraNode.position.x + overlapAmount()/2,
            y: cameraNode.position.y)
    }
    override func update(currentTime: NSTimeInterval) {
        if lastUpdateTimeInterval > 0 {
            deltaTime = currentTime - lastUpdateTimeInterval
        } else {
            deltaTime = 0
        }
        lastUpdateTimeInterval = currentTime
        if paused { return }
        gameState.updateWithDeltaTime(deltaTime)
    }
    
    func setCameraPosition(position: CGPoint) {
        cameraNode.position = CGPoint(
            x: position.x - overlapAmount()/2,
            y: position.y)
    }
    func updateCamera() {
        // 1
        let cameraTarget = convertPoint(player.position,
                                        fromNode: fgNode)
        // 2
        var targetPosition = CGPoint(x: getCameraPosition().x,
                                     y: cameraTarget.y - (scene!.view!.bounds.height * 0.40))
        let lavaPos = convertPoint(lava.position, fromNode: fgNode)
        targetPosition.y = max(targetPosition.y, lavaPos.y)
        
        //Lerp Camera
        // 3
        let diff = targetPosition - getCameraPosition()
        // 4
        let lerpValue = CGFloat(0.2)
        let lerpDiff = diff * lerpValue
        let newPosition = getCameraPosition() + lerpDiff
        let cameraPosition = getCameraPosition() + lerpDiff
        // 5
        setCameraPosition(CGPoint(x: size.width/2, y: newPosition.y))
    }
    
    //    adOverlayNode() takes the name of a scene file (such as Platform5Across) and looks for a node called "Overlay" inside, and then returns that node. Remember that you created an "Overlay" node in both of your scenes so far, and all the platforms/coins were children of this.
    
    func loadOverlayNode(fileName: String) -> SKSpriteNode {
        let overlayScene = SKScene(fileNamed: fileName)!
        let contentTemplateNode =
            overlayScene.childNodeWithName("Overlay")
        return contentTemplateNode as! SKSpriteNode
    }
    func createOverlayNode(nodeType: SKSpriteNode, flipX: Bool) {
        let platform = nodeType.copy() as! SKSpriteNode
        lastItemPosition.y = lastItemPosition.y +
            (lastItemHeight + (platform.size.height / 2.0))
        lastItemHeight = platform.size.height / 2.0
        platform.position = lastItemPosition
        if flipX == true {
            platform.xScale = -1.0
        }
        fgNode.addChild(platform)
    }
    
    //    func addRandomOverlayNode() {
    //        let overlaySprite: SKSpriteNode!
    //        let platformPercentage = 60
    //        if Int.random(min: 1, max: 100) <= platformPercentage {
    //            overlaySprite = platformArrow
    //        } else {
    //            overlaySprite = coinArrow
    //        }
    //        createOverlayNode(overlaySprite, flipX: false)
    //    }
    //
    
    
    
    
    func addRandomOverlayNode() {
        let overlaySprite: SKSpriteNode!
        var flipH = false
        let platformPercentage = 60
        
        if Int.random(min: 1, max: 100) <= platformPercentage {
            if Int.random(min: 1, max: 100) <= 75 {
                // Create standard platforms 75%
                switch Int.random(min: 0, max: 3) {
                case 0:
                    overlaySprite = platform5Across
                case 1:
                    overlaySprite = platform5Across
                case 2:
                    overlaySprite = platform5Across
                case 3:
                    overlaySprite = platformDiagonal
                    flipH = false
                default:
                    overlaySprite = platformDiagonal
                }
            } else {
                // Create breakable platforms 25%
                switch Int.random(min: 1, max: 3) {
                case 0:
                    overlaySprite = breakArrow
                case 1:
                    overlaySprite = break5Across
                case 2:
                    overlaySprite = breakDiagonal
                case 3:
                    overlaySprite = breakDiagonal
                    flipH = true
                default:
                    overlaySprite = breakArrow
                }
            }
        } else {
            if Int.random(min: 1, max: 100) <= 1 {
                // Create standard coins 75%
                switch Int.random(min: 0, max: 4) {
                case 0:
                    overlaySprite = coinCrossScene
                case 1:
                    overlaySprite = coin5Across
                case 2:
                    overlaySprite = coinDiagonal
                case 3:
                    overlaySprite = coinDiagonal
                    flipH = true
                case 4:
                    overlaySprite = coinCross
                default:
                    overlaySprite = coinArrow
                }
            } else {
                // testing it like 99% special coin
                // Create special coins 25%
                switch Int.random(min: 0, max: 4) {
                case 0:
                    overlaySprite = coinSArrow
                case 1:
                    overlaySprite = coinS5Across
                case 2:
                    overlaySprite = coinSDiagonal
                case 3:
                    overlaySprite = coinSDiagonal
                    flipH = true
                case 4:
                    overlaySprite = coinSCross
                default:
                    overlaySprite = coinSArrow
                }
            }
        }
        
        createOverlayNode(overlaySprite, flipX: flipH)
    }
    
    
    func createBackgroundNode() {
        let backNode = background.copy() as! SKNode
        backNode.position = CGPoint(x: 0.0, y: levelY)
        bgNode.addChild(backNode)
        levelY += backHeight
    }
    
    
    func setupNodes() {
        let worldNode = childNodeWithName("World")!
        bgNode = worldNode.childNodeWithName("Background")!
        background = bgNode.childNodeWithName("Overlay")!.copy() as! SKNode
        backHeight = background.calculateAccumulatedFrame().height
        fgNode = worldNode.childNodeWithName("Foreground")!
        player = fgNode.childNodeWithName("Player") as! SKSpriteNode
        lava = fgNode.childNodeWithName("Lava") as! SKSpriteNode
        setupLava()
        fgNode.childNodeWithName("Bomb")?.runAction(SKAction.hide())
        addChild(cameraNode)
        camera = cameraNode

        // Squash and Stretch
        let squishAction = SKAction.scaleXTo(1.15, y: 0.85, duration: 0.25)
        squishAction.timingMode = SKActionTimingMode.EaseInEaseOut
        let stretchAction = SKAction.scaleXTo(0.85, y: 1.15, duration: 0.25)
        stretchAction.timingMode = SKActionTimingMode.EaseInEaseOut
        
        squishAndStretch = SKAction.sequence([squishAction, stretchAction])
        
        //adding HealthBar // removing it // replacing it with Heart Shape
        // request for Level and different stages
        healthBar.removeFromParent()
        //camera!.addChild(healthBar)
        healthBar.anchorPoint.x = 0
        healthBar.position.x = -300
        healthBar.position.y = 800
        healthBar.zPosition = 200
        
        scoreLabel = childNodeWithName("score1") as! SKLabelNode
        scoreLabel.fontSize = 150
        scoreLabel.position.x = -100
        scoreLabel.position.y = 900
        
        scoreLabel.fontName = "Minercraftory"
        scoreLabel.fontColor = SKColor.yellowColor()
        scoreLabel.zPosition = 200
        scoreLabel.removeFromParent()
        camera!.addChild(scoreLabel)
        
        //added highScoreLabel
        highScoreLabel = childNodeWithName("highScore") as! SKLabelNode
        highScoreLabel.fontSize = 0

        highScoreLabel.position.x = -100
        highScoreLabel.position.y = 700
        highScoreLabel.fontColor = SKColor.redColor()
        highScoreLabel.fontName = "Pixel Coleco"

        highScoreLabel.zPosition = 200
        highScoreLabel.removeFromParent()
        camera!.addChild(highScoreLabel)


//        heartRef = loadOverlayNode("heart")
        coinArrow = loadOverlayNode("CoinArrow")
        platformArrow = loadOverlayNode("PlatformArrow")
        platform5Across = loadOverlayNode("Platform5Across")
        platformDiagonal = loadOverlayNode("PlatformDiagonal")
        breakArrow = loadOverlayNode("BreakArrow")
        break5Across = loadOverlayNode("Break5Across")
        breakDiagonal = loadOverlayNode("BreakDiagonal")
        coinRef = loadOverlayNode("Coin")
        coinSpecialRef = loadOverlayNode("CoinSpecial")
        coin5Across = loadCoinOverlayNode("Coin5Across")
        coinDiagonal = loadCoinOverlayNode("CoinDiagonal")
        coinCross = loadCoinOverlayNode("CoinCross")
        coinArrow = loadCoinOverlayNode("CoinArrow")
        coinS5Across = loadCoinOverlayNode("CoinS5Across")
        coinSDiagonal = loadCoinOverlayNode("CoinSDiagonal")
        coinSCross = loadCoinOverlayNode("CoinSCross")
        coinSArrow = loadCoinOverlayNode("CoinSArrow")
        //
    }
    
    // load up the coin
    func loadCoinOverlayNode(fileName: String) -> SKSpriteNode {
        let overlayScene = SKScene(fileNamed: fileName)!
        let contentTemplateNode = overlayScene.childNodeWithName("Overlay")
        
        contentTemplateNode!.enumerateChildNodesWithName("*", usingBlock: {
            (node, stop) in
            let coinPos = node.position
            let ref: SKSpriteNode
            if node.name == "special" {
                ref = self.coinSpecialRef.copy() as! SKSpriteNode
            } else {
                ref = self.coinRef.copy() as! SKSpriteNode
            }
            ref.position = coinPos
            contentTemplateNode?.addChild(ref)
            node.removeFromParent()
        })
        
        return contentTemplateNode as! SKSpriteNode
    }
    
    
    func setupLava() {
        lava = fgNode.childNodeWithName("Lava") as! SKSpriteNode
        let emitter = SKEmitterNode(fileNamed: "Lava.sks")!
        emitter.particlePositionRange = CGVector(dx: size.width * 1.125, dy:
            0.0)
        emitter.advanceSimulationTime(3.0)
        emitter.zPosition = 4
        lava.addChild(emitter)
    }
    
    
    func reduceHealthBar(){
        if currentHealth > 0 {
            currentHealth -= 25
            //let healthBarReduce = SKAction.scaleXTo(currentHealth / maxHealth, duration: 0.5)
            //healthBar.runAction(healthBarReduce)
            
        }
    }
    
    
    
    func improveHealthBar(){
        if currentHealth < 100 {
            currentHealth += 25
            
        }
    }
    
    //falling off the platform like that.
    func setPlayerVelocity(amount:CGFloat) {
        let gain: CGFloat = 1.5
        player.physicsBody!.velocity.dy =
            max(player.physicsBody!.velocity.dy, amount * gain)
    }
    func jumpPlayer() {
        setPlayerVelocity(850)
    }
    func boostPlayer() {
        setPlayerVelocity(1200)
    }
    func superBoostPlayer() {
        setPlayerVelocity(1700)
        print ("superBoostPlayer")
    }
    
    //function for explosion
    // First,yougetthecamerapositionandgeneratearandompositionwithinthe viewable part of the game world.
    //2. Next,you get a randomnumbertoplayarandomsoundeffectfromthe soundExplosions array.
    //3. Finally,you create an explosionwitharandomintensity.Then create a position, removing it after two seconds, and add it to the background node of the game world.

    func createRandomExplosion() {
        // 1
        let cameraPos = getCameraPosition()
        let screenSize = self.view!.bounds.size
        let screenPos = CGPoint(x: CGFloat.random(min: 0.0, max: cameraPos.x * 2.0),
                                y: CGFloat.random(min: cameraPos.y - screenSize.height * 0.75,
                                    max: cameraPos.y + screenSize.height))
        // 2
        let randomNum = Int.random(soundExplosions.count)
        //runAction(soundExplosions[randomNum])
        // 3
        let explode = explosion(0.25 * CGFloat(randomNum + 1))
        explode.position = convertPoint(screenPos, toNode: bgNode)
        explode.runAction(SKAction.removeFromParentAfterDelay(2.0))
        //bgNode.addChild(explode)
        
        if randomNum == 3 {
            screenShakeByAmt(10)
        }
    }
    
    //This method places the platform right below the player, and updates lastItemPosition and lastItemHeight appropriately
    func setupLevel() {
        // Place initial platform
        let initialPlatform = platform5Across.copy() as! SKSpriteNode
        var itemPosition = player.position
        itemPosition.y = player.position.y -
            ((player.size.height * 0.5) +
                (initialPlatform.size.height * 0.20))
        initialPlatform.position = itemPosition
        fgNode.addChild(initialPlatform)
        lastItemPosition = itemPosition
        lastItemHeight = initialPlatform.size.height / 2.0
        // Create random level
        levelY = bgNode.childNodeWithName("Overlay")!.position.y + backHeight
        while lastItemPosition.y < levelY {
            addRandomOverlayNode()
        }
        
        
    }
    func updateLava(dt: NSTimeInterval) {
        // 1
        let lowerLeft = CGPoint(x: 0, y: cameraNode.position.y -
            (size.height / 2))
        // 2
        let visibleMinYFg = scene!.convertPoint(lowerLeft, toNode:
            fgNode).y
        // 3
        let lavaVelocity = CGPoint(x: 0, y: 120)
        let lavaStep = lavaVelocity * CGFloat(dt)
        var newPosition = lava.position + lavaStep
        // 4
        newPosition.y = max(newPosition.y, (visibleMinYFg - 125.0))
        // 5
        lava.position = newPosition
    }
    
    
    //        let lowerLeft = CGPoint(x: 0, y: cameraNode.position.y - (size.height / 2))
    //        let visibleMinYFg = scene!.convertPoint(lowerLeft, toNode: fgNode).y
    //        let healthVelocity = CGPoint(x: 0, y: 220)
    //        let healthStep = healthVelocity * CGFloat(dt)
    //        var cameraPosition = health.position + healthStep
    //        cameraPosition.y = max(cameraPosition.y, (visibleMinYFg - 125.0))
    //        health.position = cameraPosition
    
    
    // collision with the lava
    func updateCollisionLava() {
        if player.position.y < lava.position.y + 200 {
            playerState.enterState(Lava)
            reduceHealthBar()
            print ("!!!!!!!!!Contact lava")

            //changing the player color
            //player.runAction()
            print ("!!!!!!!!!Red")

            player.runAction(SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50))
            print ("!!!!!!!!!Red ")

            let wait = SKAction.waitForDuration(0.5)
            //let fadeAway = SKAction.fadeOutWithDuration(1)
            //let remove = SKAction.removeFromParent()
            let redColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50)
            let whitecolor = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.50)

            let lavaDamageColor = SKAction.sequence([redColor, whitecolor])
            player.runAction(lavaDamageColor)
            
            
            print(lives)
            
            if lives <= 2 {
//                                let yellowColor = SKAction.colorizeWithColor(UIColor.yellowColor(), colorBlendFactor: 1.0, duration: 1.50)
//                                let HealthYellow = SKAction.sequence([yellowColor, wait])
//                                player.runAction(HealthYellow)
                let redColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 1.50)
                let HealthDanger = SKAction.sequence([redColor, wait])
                player.runAction(HealthDanger)
                print ("!!!!!!!!!You are so Close ")


            } else if lives == 1 {
                let redColor = SKAction.colorizeWithColor(UIColor.redColor(), colorBlendFactor: 1.0, duration: 0.50)
                let DagerHealth = SKAction.sequence([redColor])
                player.runAction(DagerHealth)
                print ("!!!!!!!!!DangerDanger!!!You are so Close to death ")

                
            }
            if lives <= 0 {
                playerState.enterState(Dead)
                gameState.enterState(GameOver)
            }
        }
    }
    
    func setUpExplosion(point: CGPoint) {
        if let explosion = SKEmitterNode(fileNamed: "explosion") {
            explosion.position = point
            addChild(explosion)
            let fadeAway = SKAction.fadeOutWithDuration(0.5)
            let wait = SKAction.waitForDuration(0.8)
            let remove = SKAction.removeFromParent()
            let seq = SKAction.sequence([wait, fadeAway, wait, remove])
            explosion.runAction(seq)
            
        }
    }
    //random Explosion
    // adding this right after updateCollisionLava
    //method checks periodically to see when to set off an explosion by comparing the last explosion time with a randomly chosen time in the future.
    
    func updateExplosions(dt: NSTimeInterval) {
        timeSinceLastExplosion += dt
        if timeSinceLastExplosion > timeForNextExplosion {
            timeForNextExplosion = NSTimeInterval(CGFloat.random(min: 0.1, max: 0.5))
            timeSinceLastExplosion = 0
            
            createRandomExplosion()
        }
    }
    // Contact Collision
    // Marks: Contacts
    func didBeginContact(contact: SKPhysicsContact) {
        let other = contact.bodyA.categoryBitMask ==
            PhysicsCategory.Player ? contact.bodyB : contact.bodyA
        //scoreLabel.text = String(scorePoint)
        
        switch other.categoryBitMask {
        case PhysicsCategory.CoinNormal:
            print("******CoinNormal__________________")
            if let coin = other.node as? SKSpriteNode {
                emitParticles("CollectNormal", sprite: coin)
                jumpPlayer()
                //runAction(soundCoin)
                scorePoint += 50
                scoreLabel.text = String(scorePoint)
                print("&&&&&&&&&")

//                if ((firstBody.categoryBitMask == PhysicsCategory.Enemy) && (secondBody.categoryBitMask == PhysicsCategory.Bullet) || (firstBody.categoryBitMask == PhysicsCategory.Bullet) && (secondBody.categoryBitMask == PhysicsCategory.Enemy)) {
//                    
//                    collisionWithBullet(firstBody.node as! SKSpriteNode, Bullet: secondBody.node as! SKSpriteNode)
//                    
                
                    // Used to test if the scorePoint works
                
            }
        case PhysicsCategory.Heart:
            if let heart = other.node as? SKSpriteNode {
                emitParticles("CollectSpecial", sprite: heart)
                
            }
        case PhysicsCategory.CoinSpecial:
            if let coin = other.node as? SKSpriteNode {
            emitParticles("CollectSpecial", sprite: coin)
            boostPlayer()
            scorePoint += 500
            scoreLabel.text = String(scorePoint)
            let yellowColor = SKAction.colorizeWithColor(UIColor.yellowColor(), colorBlendFactor: 1.0, duration: 1.50)
            let wait = SKAction.waitForDuration(0.5)
            let whitecolor = SKAction.colorizeWithColor(UIColor.whiteColor(), colorBlendFactor: 1.0, duration: 0.50)

            let HealthYellow = SKAction.sequence([yellowColor, wait, whitecolor
                ])
            player.runAction(HealthYellow)

            //runAction(soundBoost)
        }
        
        case PhysicsCategory.PlatformNormal:
            if let _ = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    jumpPlayer()
                    scoreLabel.text = String(scorePoint)
                    
                }
            }
        case PhysicsCategory.PlatformBreakable:
            if let platform = other.node as? SKSpriteNode {
                if player.physicsBody!.velocity.dy < 0 {
                    //platformAction(platform, breakable: true)
                    jumpPlayer()
                    //runAction(soundBrick)
                    scoreLabel.text = String(scorePoint)
                    
                }
            }
        default:
            break; }
    }
    
    func addTrail(name: String) -> SKEmitterNode {
        let trail = SKEmitterNode(fileNamed: name)!
        trail.targetNode = fgNode
        player.addChild(trail)
        return trail
    }
    
    func removeTrail(trail: SKEmitterNode) {
        trail.numParticlesToEmit = 1
        trail.runAction(SKAction.removeFromParentAfterDelay(1.0))
    }
    
    //screenShake by amount
    func screenShakeByAmt(amt: CGFloat) {
        let worldNode = childNodeWithName("World")!
        worldNode.position = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        worldNode.removeActionForKey("shake")
        
        // introduce amount
        let amount = CGPoint(x: 0, y: -(amt * gameGain))
        let action = SKAction.screenShakeWithNode(worldNode, amount: amount, oscillations: 10, duration: 2.0)
        worldNode.runAction(action, withKey: "shake")
    }
    
    // Normal Coin Animation
    func emitParticles(name: String, sprite: SKSpriteNode) {
        let pos = fgNode.convertPoint(sprite.position, fromNode: sprite.parent!)
        let particles = SKEmitterNode(fileNamed: name)!
        particles.position = pos
        particles.zPosition = 3
        fgNode.addChild(particles)
        particles.runAction(SKAction.removeFromParentAfterDelay(1.0))
        sprite.runAction(SKAction.sequence([SKAction.scaleTo(0.0, duration: 0.5), SKAction.removeFromParent()]))
    }
    
    func runAnim(anim: SKAction) {
        if curAnim == nil || curAnim! != anim {
            player.removeActionForKey("anim")
            player.runAction(anim, withKey: "anim")
            curAnim = anim
        }
    }
    func playBackgroundMusic(name: String) {
        var delay = 0.0
        if backgroundMusic != nil {
            backgroundMusic.removeFromParent()
            if bgMusicAlarm != nil {
                bgMusicAlarm.removeFromParent()
            } else {
                bgMusicAlarm = SKAudioNode(fileNamed: "alarm.wav") as? SKAudioNode
                bgMusicAlarm.autoplayLooped = true
                addChild(bgMusicAlarm)
            }
        } else {
            delay = 0.1
        }
        
        runAction(SKAction.waitForDuration(delay)) {
            self.backgroundMusic = SKAudioNode(fileNamed: name) as? SKAudioNode
            self.backgroundMusic.autoplayLooped = true
            self.addChild(self.backgroundMusic)
        }
    }
    
    func explosion(intensity: CGFloat) -> SKEmitterNode {
        let emitter = SKEmitterNode()
        let particleTexture = SKTexture(imageNamed: "spark")
        
        emitter.zPosition = 2
        emitter.particleTexture = particleTexture
        emitter.particleBirthRate = 4000 * intensity
        emitter.numParticlesToEmit = Int(400 * intensity)
        emitter.particleLifetime = 2.0
        emitter.emissionAngle = CGFloat(90.0).degreesToRadians()
        emitter.emissionAngleRange = CGFloat(360.0).degreesToRadians()
        emitter.particleSpeed = 600 * intensity
        emitter.particleSpeedRange = 1000 * intensity
        emitter.particleAlpha = 1.0
        emitter.particleAlphaRange = 0.25
        emitter.particleScale = 1.2
        emitter.particleScaleRange = 2.0
        emitter.particleScaleSpeed = -1.5
        emitter.particleColorBlendFactor = 1
        emitter.particleBlendMode = SKBlendMode.Add
        emitter.runAction(SKAction.removeFromParentAfterDelay(2.0))
        
        let sequence = SKKeyframeSequence(capacity: 5)
        sequence.addKeyframeValue(SKColor.whiteColor(), time: 0)
        sequence.addKeyframeValue(SKColor.yellowColor(), time: 0.10)
        sequence.addKeyframeValue(SKColor.orangeColor(), time: 0.15)
        sequence.addKeyframeValue(SKColor.redColor(), time: 0.75)
        sequence.addKeyframeValue(SKColor.blackColor(), time: 0.95)
        
        emitter.particleColorSequence = sequence
        
        return emitter
    }
}
