//
//  ViewController.swift
//  DroppingCharge
//
//  Created by JeffChiu on 8/7/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import GoogleMobileAds
import UIKit

class ViewController: UIViewController {
    
    /// The banner view.
    @IBOutlet weak var bannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Google Mobile Ads SDK version: \(GADRequest.sdkVersion())")
        bannerView.adUnitID = "ca-app-pub-9213470812256501/3639736473"
        bannerView.rootViewController = self
        bannerView.loadRequest(GADRequest())
}

}
