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

    init(backgroundTiles: SKTileMapNode,
         foregroundTiles: SKTileMapNode,
         playerSprite: SKNode) {

        if backgroundTiles.tileSize != foregroundTiles.tileSize {
            fatalError("Tile sizes MUST be equal.")
        }

        if playerSprite.parent != backgroundTiles {
            fatalError("Player sprite must be a child node of the background tiles")
        }

        player = PlayerInfo(sprite: playerSprite)
        tileManager = TileManager(backgroundTileSet: backgroundTiles, foregroundTileSet: foregroundTiles)
    }

    // Checks whether a tile is passable
    func canPlayerMoveByRelativeOffset(dx: Int, dy: Int) -> Bool {

        var result = false

        let nextAbsolutePositionX = player.sprite.position.x + (tileManager.backgroundTileSet.tileSize.width * CGFloat(dx))
        let nextAbsolutePositionY = player.sprite.position.y + (tileManager.backgroundTileSet.tileSize.height * CGFloat(dy))
        let nextAbsolutePoint = CGPoint(x: nextAbsolutePositionX, y: nextAbsolutePositionY)

        let nextColumn = tileManager.backgroundTileSet.tileColumnIndex(fromPosition: nextAbsolutePoint)
        let nextRow = tileManager.backgroundTileSet.tileRowIndex(fromPosition: nextAbsolutePoint)

        guard let nextTile = tileManager.backgroundTileAtPosition(x: nextColumn, y: nextRow) else {
            return false
        }

        // Debugging
        print("Next row: \(nextRow) column: \(nextColumn)")

        // Handle passable background tiles.
        result = result || (nextTile is Passable)

        // If the foreground tile type is conditionally passable, we can only pass if we satisfy the pre-conditions
        if let conditionalTile = tileManager.foregroundTileAtPosition(x: nextColumn, y: nextRow) as? ConditionallyPassable {
            result = result && conditionalTile.canPlayerConditionallyPassTile(gameManager: self, player: player)
        }

        return result
    }

    // Runs the side effects of moving a player to a tile position
    // E.g. moving the tilemaps, updating collectibles, changing the game state etc.
    func movePlayerByRelativeOffset(dx: Int, dy: Int) {

        let xOffset = CGFloat(-dx) * tileManager.backgroundTileSet.tileSize.width
        let yOffset = CGFloat(-dy) * tileManager.backgroundTileSet.tileSize.height

        let nextAbsolutePositionX = player.sprite.position.x + (tileManager.backgroundTileSet.tileSize.width * CGFloat(dx))
        let nextAbsolutePositionY = player.sprite.position.y + (tileManager.backgroundTileSet.tileSize.height * CGFloat(dy))
        let nextAbsolutePoint = CGPoint(x: nextAbsolutePositionX, y: nextAbsolutePositionY)

        let nextColumn = tileManager.backgroundTileSet.tileColumnIndex(fromPosition: nextAbsolutePoint)
        let nextRow = tileManager.backgroundTileSet.tileRowIndex(fromPosition: nextAbsolutePoint)

        // Center of new tile position
        let newTileCenter = tileManager.backgroundTileSet.centerOfTile(atColumn: nextColumn, row: nextRow)

        // Move tilesets
        tileManager.tileSets.forEach { (tileSet) in
            tileSet.position = CGPoint(x: tileSet.position.x + xOffset, y: tileSet.position.y + yOffset)
        }

        // Move player sprite to offset the tilemap movement
        player.sprite.position = newTileCenter

        // Handle collisions & side effects
        handleCollisions(column: nextColumn, row: nextRow)
    }

    // Handles side effects of collisions with tiles
    // row/column must correspond to the tilemap offsets the character is currently on
    func handleCollisions(column: Int, row: Int) {

        // TODO: Handle background tile collisions here...

        // Handle foreground tile collisions
        guard let foregroundTile = tileManager.foregroundTileAtPosition(x: column, y: row) else {
            return
        }

        // Collectables
        if let collectableTile = foregroundTile as? Collectable {
            handleCollectibleCollision(column: column, row: row, tile: collectableTile)
        }

        // Conditionally passable tiles
        if let conditionalTile = foregroundTile as? ConditionallyPassable {
            handleConditionallyPassableCollisions(column: column, row: row, tile: conditionalTile)
        }
    }

    func handleCollectibleCollision(column: Int, row: Int, tile: Collectable) {
        // Perform tile action
        tile.performCollectableAction(gameManager: self, player: &player)

        // Remove sprite from tile map
        tileManager.removeForegroundTileAtPosition(x: column, y: row)
    }

    func handleConditionallyPassableCollisions(column: Int, row: Int, tile: ConditionallyPassable) {
        // Perform action
        tile.playerDidPassConditionalTile(gameManager: self, player: &player)

        // Remove tile if allowed
        if tile.shouldRemoveConditionallyPassableTileAfterCollision() {
            tileManager.removeForegroundTileAtPosition(x: column, y: row)
        }
    }
}
