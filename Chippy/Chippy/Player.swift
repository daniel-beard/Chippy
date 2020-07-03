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

    var sprite: SKSpriteNode
    var chipCount: Int = 0

    var redKeyCount:    Int = 0
    var greenKeyCount:  Int = 0
    var blueKeyCount:   Int = 0
    var yellowKeyCount: Int = 0

    var hasFireBoots:       Bool = false
    var hasFlippers:        Bool = false
    var hasIceSkates:       Bool = false
    var hasSuctionBoots:    Bool = false

    var previousMoveDirection: GridDirection
    
    init(sprite: SKSpriteNode) {
        self.sprite = sprite
        self.previousMoveDirection = .down
    }

    func absolutePoint() -> CGPoint { sprite.position }

    func updateSpriteForMoveDirection(moveDirection: GridDirection) {
        self.sprite.removeAllActions()
        let waitAction = SKAction.wait(forDuration: 1.0)
        let resetChippySprite = SKAction.setTexture(SKTexture(imageNamed: "chippyfront"))
        let group = SKAction.sequence([waitAction, resetChippySprite])
        switch moveDirection {
            case .up:       self.sprite.texture = SKTexture(imageNamed: "chippyback")
            case .down:     self.sprite.texture = SKTexture(imageNamed: "chippyfront")
            case .left:     self.sprite.texture = SKTexture(imageNamed: "chippyleft")
            case .right:    self.sprite.texture = SKTexture(imageNamed: "chippyright")
        }
        self.sprite.run(group)
    }
}

