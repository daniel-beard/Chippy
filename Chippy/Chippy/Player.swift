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

    var redKeyCount: Int = 0
    var greenKeyCount: Int = 0
    var blueKeyCount: Int = 0
    var yellowKeyCount: Int = 0
    
    init(sprite: SKNode) {
        self.sprite = sprite
    }
}
