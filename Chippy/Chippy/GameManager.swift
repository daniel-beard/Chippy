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
    var player: Player
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

        player = Player(sprite: playerSprite)
        tileManager = TileManager(backgroundTileSet: backgroundTiles, foregroundTileSet: foregroundTiles)
    }

    // Checks whether a tile is passable
    func canPlayerMoveByRelativeOffset(dx: Int, dy: Int) -> Bool {

        let nextAbsolutePositionX = player.sprite.position.x + (tileManager.backgroundTileSet.tileSize.width * CGFloat(dx))
        let nextAbsolutePositionY = player.sprite.position.y + (tileManager.backgroundTileSet.tileSize.height * CGFloat(dy))
        let nextAbsolutePoint = CGPoint(x: nextAbsolutePositionX, y: nextAbsolutePositionY)

        let nextColumn = tileManager.backgroundTileSet.tileColumnIndex(fromPosition: nextAbsolutePoint)
        let nextRow = tileManager.backgroundTileSet.tileRowIndex(fromPosition: nextAbsolutePoint)

        guard let nextTile = tileManager.backgroundTileAtPosition(x: nextColumn, y: nextRow) else {
            return false
        }

        print("Next row: \(nextRow) column: \(nextColumn)")

        return nextTile is Passable
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
    }
}
