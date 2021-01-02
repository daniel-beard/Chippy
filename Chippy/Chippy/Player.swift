//
//  Player.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

class PlayerInfo {

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

    var inputHint:          (direction: GridDirection, ts: TimeInterval)?
    var lastMove:           (direction: GridDirection, ts: TimeInterval)?
    var lastTick:           TimeInterval = nowTime()
    let tickDuration:       TimeInterval = 0.2

    var scene: SKScene
    var previousPosition: GridPos?
    
    init(sprite: SKSpriteNode, scene: SKScene) {
        self.sprite = sprite
        self.scene = scene
    }

    func absolutePoint() -> CGPoint { sprite.position }

    func update(currTime: TimeInterval, delta deltaTime: CFTimeInterval) {

        guard let gm = GM() else { return }
        if currTime - tickDuration <= lastTick { return }

        let currentPos = gm.tiles.gridPosition(forPoint: self.absolutePoint())

        // Player Effects
        if let effect = gm.playerEffectAtCurrentPos() {
            switch effect {
            case .conveyor:
                // No effect if the player has boots
                guard !hasSuctionBoots else { break }
                // Need the tile, so we can get the direction from it
                if let boostTile = gm.tiles.at(pos: currentPos).filter({ $0 is BoostTile }).first as? BoostTile {
                    let direction = boostTile.forceDirection
                    gm.movePlayer(inDirection: direction)
                }
                // Does not clear inputHints, as a player can 'break-out' of a conveyor loop
            default: fatalError("Not implemented")
            }
            //TODO: Only clear this for certain things like ice
//            inputHint = nil
            lastTick = nowTime()
        }

        // Regular movement
        if let input = inputHint {
            // This call may or may not succeed, but we always want to update
            // chippy's direction state. So we always call updateSpritePosition afterwards.
            gm.movePlayer(inDirection: input.direction)
            updateSpriteForMoveDirection(moveDirection: input.direction)

            // Cleanup and timestamps
            lastMove = inputHint
            inputHint = nil
            lastTick = nowTime()
        }
    }

    // Sets input hints, these are handled in the update function above.
    func inputHint(direction moveDirection: GridDirection) {
        inputHint = (moveDirection, nowTime())
    }

    // Only called from GameManager, do not call this manually
    func updateSpritePosition(from currPos: GridPos, to nextPos: GridPos, direction: GridDirection) {
        self.previousPosition = currPos
        guard let nextTileCenter = GM()?.tiles.centerOfTile(at: nextPos) else { return }
        sprite.position = nextTileCenter
        scene.camera?.position = sprite.position
    }

    // This function makes chippy change sprites on movement.
    // After a timeout, it will reset him to the deafult state.
    func updateSpriteForMoveDirection(moveDirection: GridDirection) {
        sprite.removeAllActions()
        let waitAction = SKAction.wait(forDuration: 0.3)
        let resetChippySprite = SKAction.setTexture(SKTexture(imageNamed: "chippyfront"))
        let group = SKAction.sequence([waitAction, resetChippySprite])
        switch moveDirection {
            case .up:       sprite.texture = SKTexture(imageNamed: "chippyback")
            case .down:     sprite.texture = SKTexture(imageNamed: "chippyfront")
            case .left:     sprite.texture = SKTexture(imageNamed: "chippyleft")
            case .right:    sprite.texture = SKTexture(imageNamed: "chippyright")
        }
        sprite.run(group)
    }
}
