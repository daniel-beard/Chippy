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
    var tiles: TileManager
    var levelMetadata: LevelMetadata
    var scene: SKScene

    // Entity manager
    var entityManager: EntityManager!

    init(scene: SKScene, levelMetadata: LevelMetadata) {

        self.scene = scene
        self.entityManager = EntityManager(scene: scene)
        self.levelMetadata = levelMetadata
        _ = LevelLoader.verifyLevel(levelNumber: levelMetadata.levelNumber)
        player = PlayerInfo(sprite: LevelLoader.loadPlayerSprite(scene: scene))
        tiles = TileManager(
            backgroundTileSet: LevelLoader.loadBackgroundTiles(scene: scene),
            interactiveTileSet: LevelLoader.loadForegroundTiles(scene: scene),
            moveableTileSet: LevelLoader.loadMoveableTiles(scene: scene)
        )
    }

    // Checks whether a tile is passable
    func canPlayerMove(inDirection moveDirection: MoveDirection) -> Bool {

        var result = false

        let currentPos = tiles.gridPosition(forPoint: player.absolutePoint())
        let nextPos = currentPos + moveDirection
        let nextTiles = tiles.at(pos: nextPos)

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
    func movePlayer(inDirection moveDirection: MoveDirection) {

        // Positions
        let currentPos = tiles.gridPosition(forPoint: player.absolutePoint())
        let nextPos = currentPos + moveDirection

        // Center of new tile position
        let newTileCenter = tiles.centerOfTile(at: nextPos)

        // Move player sprite to offset the tilemap movement
        player.sprite.position = newTileCenter
        player.updateSpriteForMoveDirection(moveDirection: moveDirection)
        scene.camera?.position = player.sprite.position

        // Handle collisions & side effects
        handleCollisions(position: nextPos, direction: moveDirection)
    }

    // Handles side effects of collisions with tiles
    // row/column must correspond to the tilemap offsets the character is currently on
    func handleCollisions(position: GridPos, direction: MoveDirection) {

        tiles.at(pos: position).forEach { tile in
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

    func handleConditionallyMoveableCollision(position: GridPos,
                                              tile: ConditionallyMoveable,
                                              direction: MoveDirection) {
        let currentTilePos = position
        let nextTilePos = position + direction
        let tileLayer = tile.layer()

        // Move the tile
        tiles.move(at: currentTilePos, to: nextTilePos, layer: tileLayer)

        // Run post action on new positioned tile
        let newTile = (tiles.at(pos: nextTilePos, layer: tileLayer) as! ConditionallyMoveable)
        newTile.didMoveConditionallyMoveableTile(gameManager: self,
                                                 player: &self.player,
                                                 tilePosition: nextTilePos,
                                                 direction: direction)
    }

    func handleCollectibleCollision(position: GridPos, tile: Collectable) {
        // Perform tile action
        tile.performCollectableAction(gameManager: self, player: &player)

        // Remove sprite from tile map
        tiles.removeForegroundTile(at: position)

        // Notify there has been a UI change
        NotificationCenter.default.post(Notification(name: Notification.Name("UpdatePlayerUI")))
    }

    func handleConditionallyPassableCollisions(position: GridPos, tile: ConditionallyPassable) {
        // Remove tile if allowed
        if tile.shouldRemoveConditionallyPassableTileAfterCollision() {
            tiles.removeForegroundTile(at: position)
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
