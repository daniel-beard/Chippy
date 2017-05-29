//
//  Player.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

struct PlayerInfo {

    var sprite: SKNode
    var chipCount: Int = 0

    var redKeyCount:    Int = 0
    var greenKeyCount:  Int = 0
    var blueKeyCount:   Int = 0
    var yellowKeyCount: Int = 0

    var hasFireBoots:       Bool = false
    var hasFlippers:        Bool = false
    var hasIceSkates:       Bool = false
    var hasSuctionBoots:    Bool = false
    
    init(sprite: SKNode) {
        self.sprite = sprite
    }

    func absolutePoint() -> CGPoint {
        return sprite.position
    }
}

