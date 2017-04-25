//
//  GameProtocol.swift
//  DroppingCharge
//
//  Created by JeffChiu on 7/29/16.
//  Copyright © 2016 JeffChiu. All rights reserved.
//

import Foundation
import SpriteKit

protocol GameProtocol: class  {
    
    func addTrail(_ name: String) -> SKEmitterNode 
    func reactToLava()


}

