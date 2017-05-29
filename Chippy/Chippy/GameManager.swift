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

    init(scene: SKScene, levelMetadata: LevelMetadata) {

        self.levelMetadata = levelMetadata
        _ = LevelLoader.verifyLevel(levelNumber: levelMetadata.levelNumber)
        player = PlayerInfo(sprite: LevelLoader.loadPlayerSprite(scene: scene))
        tileManager = TileManager(
            backgroundTileSet: LevelLoader.loadBackgroundTiles(scene: scene),
            interactiveTileSet: LevelLoader.loadForegroundTiles(scene: scene),
            moveableTileSet: LevelLoader.loadMoveableTiles(scene: scene)
        )
    }

    // Checks whether a tile is passable
    func canPlayerMoveByRelativeOffset(dx: Int, dy: Int, moveDirection: MoveDirection) -> Bool {

        var result = false

        let currentPos = tileManager.absolutePointToPosition(player.absolutePoint())
        let nextPos = currentPos + Position(x: dx, y: dy)

        guard let nextTile = tileManager.backgroundTile(at: nextPos) else {
            return false
        }

        // Debugging
        print("Next position: \(nextPos)")

        // Handle passable background tiles.
        result = result || (nextTile is Passable)

        // If the foreground tile type is conditionally passable, we can only pass if we satisfy the pre-conditions
        if let conditionalTile = tileManager.interactiveTile(at: nextPos) as? ConditionallyPassable {
            result = result && conditionalTile.canPlayerConditionallyPassTile(gameManager: self, player: player)
        }

        // Handle moveable tiles
        //TODO: Implement me.

        return result
    }

    // Runs the side effects of moving a player to a tile position
    // E.g. moving the tilemaps, updating collectibles, changing the game state etc.
    func movePlayerByRelativeOffset(dx: Int, dy: Int, moveDirection: MoveDirection) {

        let currentPos = tileManager.absolutePointToPosition(player.absolutePoint())
        let nextPos = currentPos + Position(x: dx, y: dy)

        let xOffset = CGFloat(-dx) * tileManager.tileSize().width
        let yOffset = CGFloat(-dy) * tileManager.tileSize().height

        // Center of new tile position
        let newTileCenter = tileManager.backgroundTileSet.centerOfTile(atColumn: nextPos.x, row: nextPos.y)

        // Move tilesets
        tileManager.tileSets.forEach { (tileSet) in
            tileSet.position = CGPoint(x: tileSet.position.x + xOffset, y: tileSet.position.y + yOffset)
        }

        // Move player sprite to offset the tilemap movement
        player.sprite.position = newTileCenter

        // Handle collisions & side effects
        handleCollisions(position: nextPos)
    }

    // Handles side effects of collisions with tiles
    // row/column must correspond to the tilemap offsets the character is currently on
    func handleCollisions(position: Position) {

        // TODO: Handle background tile collisions here...

        // Handle foreground tile collisions
        guard let interactiveTile = tileManager.interactiveTile(at: position) else {
            return
        }

        // Collectables
        if let collectableTile = interactiveTile as? Collectable {
            handleCollectibleCollision(position: position, tile: collectableTile)
        }

        // Conditionally passable tiles
        if let conditionalTile = interactiveTile as? ConditionallyPassable {
            handleConditionallyPassableCollisions(position: position, tile: conditionalTile)
        }
    }

    func handleCollectibleCollision(position: Position, tile: Collectable) {
        // Perform tile action
        tile.performCollectableAction(gameManager: self, player: &player)

        // Remove sprite from tile map
        tileManager.removeForegroundTile(at: position)
    }

    func handleConditionallyPassableCollisions(position: Position, tile: ConditionallyPassable) {
        // Remove tile if allowed
        if tile.shouldRemoveConditionallyPassableTileAfterCollision() {
            tileManager.removeForegroundTile(at: position)
        }

        // Perform action
        tile.playerDidPassConditionalTile(gameManager: self, player: &self.player)
    }
}

// Level Information
extension GameManager {
    func nextLevelNumber() -> Int {
        return self.levelMetadata.levelNumber + 1
    }
}
