//
//  GameManager.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

class GameManager {

    var player: PlayerInfo
    var tileManager: TileManager
    var levelMetadata: LevelMetadata
    var scene: SKScene

    init(scene: SKScene, levelMetadata: LevelMetadata) {
        self.scene = scene
        self.levelMetadata = levelMetadata
        _ = LevelLoader.verifyLevel(levelNumber: levelMetadata.levelNumber)
        player = PlayerInfo(sprite: LevelLoader.loadPlayerSprite(scene: scene))
        tileManager = TileManager(
            backgroundTileSet: LevelLoader.loadBackgroundTiles(scene: scene),
            interactiveTileSet: LevelLoader.loadForegroundTiles(scene: scene),
            moveableTileSet: LevelLoader.loadMoveableTiles(scene: scene)
        )
    }

    func update(delta: TimeInterval) {
        // Get all the dynamic tiles and update them
        let dynamicTiles = tileManager.allUpdateableTiles(forLayer: .three)
        dynamicTiles.forEach { $0.update(delta: delta, gameManager: self) }
    }

    // Checks whether a tile is passable
    func canPlayerMoveByRelativeOffset(dx: Int, dy: Int, moveDirection: MoveDirection) -> Bool {

        var result = false

        let currentPos = tileManager.absolutePointToPosition(player.absolutePoint())
        let nextPos = currentPos + Position(x: dx, y: dy)
        let nextTiles = tileManager.tiles(at: nextPos)

        guard !nextTiles.isEmpty else {
            return false
        }

        // Handle passable tiles
        result = result || (nextTiles.all { $0 is Passable })

        // Handle any conditionally passable tiles
        let conditionallyPassableTiles = nextTiles.filter { $0 is ConditionallyPassable }
        result = result && (conditionallyPassableTiles as! [ConditionallyPassable]).all { conditionalTile in
            conditionalTile.canPlayerConditionallyPassTile(gameManager: self, player: player)
        }

        // Handle moveable tiles
        let moveableTiles = nextTiles.filter { $0 is ConditionallyMoveable }
        result = result && (moveableTiles as! [ConditionallyMoveable]).all { moveableTile in
            moveableTile.canPlayerMoveTile(gameManager: self, player: player, tilePosition: nextPos, direction: moveDirection)
        }

        return result
    }

    // Runs the side effects of moving a player to a tile position
    // E.g. moving the tilemaps, updating collectibles, changing the game state etc.
    func movePlayerByRelativeOffset(dx: Int, dy: Int, moveDirection: MoveDirection) {

        // Positions
        let currentPos = tileManager.absolutePointToPosition(player.absolutePoint())
        let nextPos = currentPos + Position(x: dx, y: dy)

        // Center of new tile position
        let newTileCenter = tileManager.centerOfTile(at: nextPos)

        // Move player sprite + camera
        player.sprite.position = newTileCenter
        scene.camera?.position = newTileCenter
        player.updateSpriteForMoveDirection(moveDirection: moveDirection)

        // Handle collisions & side effects
        handleCollisions(position: nextPos, direction: moveDirection)
    }

    // Handles side effects of collisions with tiles
    // row/column must correspond to the tilemap offsets the character is currently on
    func handleCollisions(position: Position, direction: MoveDirection) {

        let tiles = tileManager.tiles(at: position)
        guard !tiles.isEmpty else { return }

        tiles.forEach { tile in
            switch (tile) {
                case is Collectable:
                    handleCollectibleCollision(position: position, tile: (tile as! Collectable))
                case is ConditionallyPassable:
                    handleConditionallyPassableCollisions(position: position, tile: (tile as! ConditionallyPassable))
                case is ConditionallyMoveable:
                    handleConditionallyMoveableCollision(position: position,
                                                          tile: (tile as! ConditionallyMoveable),
                                                          direction: direction)
                default: break
            }
        }
    }

    func handleConditionallyMoveableCollision(position: Position,
                                              tile: ConditionallyMoveable,
                                              direction: MoveDirection) {
        let currentTilePos = position
        let nextTilePos = offset(position: position, byDirection: direction)
        let tileLayer = tile.layer()

        // Move the tile
        tileManager.moveTile(at: currentTilePos, layer: tileLayer, newPosition: nextTilePos)

        // Run post action on new positioned tile
        let newTile = (tileManager.tile(at: nextTilePos, layer: tileLayer) as! ConditionallyMoveable)
        newTile.didMoveConditionallyMoveableTile(gameManager: self,
                                                 player: &self.player,
                                                 tilePosition: nextTilePos,
                                                 direction: direction)
    }

    func handleCollectibleCollision(position: Position, tile: Collectable) {
        // Perform tile action
        tile.performCollectableAction(gameManager: self, player: &player)

        // Remove sprite from tile map
        tileManager.removeForegroundTile(at: position)

        // Notify there has been a UI change
        NotificationCenter.default.post(Notification(name: Notification.Name("UpdatePlayerUI")))
    }

    func handleConditionallyPassableCollisions(position: Position, tile: ConditionallyPassable) {
        // Remove tile if allowed
        if tile.shouldRemoveConditionallyPassableTileAfterCollision() {
            tileManager.removeForegroundTile(at: position)
        }

        // Perform action
        tile.playerDidPassConditionalTile(gameManager: self, player: &self.player, position: position)

        // Notify there has been a UI change
        NotificationCenter.default.post(Notification(name: Notification.Name("UpdatePlayerUI")))
    }
}

// Level Information
extension GameManager {
    func nextLevelNumber() -> Int { self.levelMetadata.levelNumber + 1 }
}
