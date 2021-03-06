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
        let currPos = gm.tiles.gridPosition(forPoint: self.absolutePoint())
        let currTiles = gm.tiles.at(pos: currPos)

        // Player Effects
        if let effect = gm.playerEffectAtCurrentPos() {
            switch effect {
            case .conveyor:
                // No effect if the player has boots
                guard !hasSuctionBoots else { break }
                // Need the tile, so we can get the direction from it
                guard let boostTile = currTiles.grab(of: BoostTile.self) else { break }
                _updatePlayerStoreMove(forDirection: boostTile.forceDirection, time: currTime)
                // Does not clear inputHints, as a player can 'break-out' of a conveyor loop
                // will still be handled in the regular movement section below
            case .ice:
                // No effect if the player has boots, or if we start on an ice block
                guard !hasIceSkates else { break }
                guard let lastMove = lastMove else { break }
                // If next tile is passable or conditionally passable,
                // continue the way we have been going.
                // If we are currently on an ice corner, apply the new direction, based on lastMove.
                // If the next tile is NOT passable, we need to flip the direction we are traveling.
                let nextTileFree = gm.canPlayerMove(inDirection: lastMove.direction)
                if let iceTile = currTiles.grab(of: IceTile.self), iceTile.iceType() != .normal {
                    let nextDir = iceTile.nextDirection(fromLastDirection: lastMove.direction)
                    _updatePlayerStoreMove(forDirection: nextDir, time: currTime)
                } else if nextTileFree {
                    _updatePlayerStoreMove(forDirection: lastMove.direction, time: currTime)
                } else {
                    _updatePlayerStoreMove(forDirection: lastMove.direction.reverse(), time: currTime)
                }
                // Clears inputHints, as players can't move off ice without skates
                inputHint = nil
            }
        }

        // Regular movement
        if let input = inputHint {
            _updatePlayerStoreMove(forDirection: input.direction, time: currTime)
            // Clear inputHint, we are done with it
            inputHint = nil
        }
        lastTick = nowTime()
    }

    fileprivate func _updatePlayerStoreMove(forDirection direction: GridDirection, time currTime: TimeInterval) {
        GM()?.movePlayer(inDirection: direction)
        updateSpriteForMoveDirection(moveDirection: direction)
        self.lastMove = (direction: direction, ts: currTime)
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
