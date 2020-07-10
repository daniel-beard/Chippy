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

    var scene: SKScene
    var previousPosition: GridPos?
    
    init(sprite: SKSpriteNode, scene: SKScene) {
        self.sprite = sprite
        self.scene = scene
    }

    func absolutePoint() -> CGPoint { sprite.position }


    //TODO: I guess here I want an input/update loop.
    // I think it might have to be chippy calling the shots, based on if we are on ice etc.
    // Within this method, I can make the decision to take a hint of input, or ice movement, etc.
    // should also take into account boot effects in this method
    mutating func updatePosition(from currPos: GridPos, to nextPos: GridPos, direction: GridDirection) {
        self.previousPosition = currPos

        // Center of new tile position
        guard let newTileCenter = GM()?.tiles.centerOfTile(at: nextPos) else { return }
        sprite.position = newTileCenter
        scene.camera?.position = sprite.position
        updateSpriteForMoveDirection(moveDirection: direction)
    }

    func updateSpriteForMoveDirection(moveDirection: GridDirection) {
        sprite.removeAllActions()
        let waitAction = SKAction.wait(forDuration: 1.0)
        let resetChippySprite = SKAction.setTexture(SKTexture(imageNamed: "chippyfront"))
        let group = SKAction.sequence([waitAction, resetChippySprite])
        switch moveDirection {
            case .up:       sprite.texture = SKTexture(imageNamed: "chippyback")
            case .down:     sprite.texture = SKTexture(imageNamed: "chippyfront")
            case .left:     sprite.texture = SKTexture(imageNamed: "chippyleft")
            case .right:    sprite.texture = SKTexture(imageNamed: "chippyright")
        }
        self.sprite.run(group)
    }
}
