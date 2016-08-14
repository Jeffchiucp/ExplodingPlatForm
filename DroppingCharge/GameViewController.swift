//
//  GameViewController.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/8/16.
//  Copyright (c) 2016 JeffChiu. All rights reserved.
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


import UIKit
import SpriteKit
import GoogleMobileAds
import Social
import MessageUI



protocol ControlSceneProtocol: class  {
    
    
    
}

class GameViewController: UIViewController, MFMessageComposeViewControllerDelegate, GameSceneSocialDelegate  {
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    func loadScene(inScene:SKScene?) -> SKScene? {
        if let scene = inScene {
            
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = false
            skView.showsNodeCount = false
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
            return scene
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-9213470812256501/3639736473"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())

        //        if let scene = CharacterScene(fileNamed:"CharacterScene") {
        // MainScene
        
        if let scene = loadScene(StartScene(fileNamed:"StartScene")) as? StartScene {
            scene.socialDelegate = self
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    
    func postToTwitter() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
        vc.setInitialText("Posting to Twitter. Check out my Highests Score at Ninja Jumping Quest")
        // vc.addImage(UIImage!) // Add an image
        // vc.addURL(NSURL!) // Add a URL
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func postToFaceBook() {
        let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        vc.setInitialText("Posting to FaceBook. Check out my Highests Score at Ninja Jumping Quest")
//        UIGraphicsBeginImageContext(view.frame.size)
//        let context = UIGraphicsGetCurrentContext()!
//        view.layer.drawInContext(context)
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//        vc.addImage(image) // Add an image
//        let NSURL = "https://itunes.apple.com/us/app/ninja-jumping-quest/id1139367120"
//        vc.addURL(NSURL!) // Add a URL
        presentViewController(vc, animated: true, completion: nil)
    }
    
    func sendMessage() {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "Your message string"
        messageVC.recipients = []
        messageVC.messageComposeDelegate = self
        presentViewController(messageVC, animated: true, completion: nil)
        
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        
        
    }

}
