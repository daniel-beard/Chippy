//
//  MovableBlock.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import CoreGraphics

class MovableBlock: BaseTile, Passable, ConditionallyMoveable {

    override func layer() -> TileLayer { .three }

    func canPlayerMoveTile(gameManager: GameManager,
                           player: PlayerInfo,
                           tilePosition: Position,
                           direction: MoveDirection) -> Bool {

        let nextTiles = gameManager.tiles.tiles(at: tilePosition, offsetBy: direction)
        // Here we whitelist the movable conditions
        // Not sure if there will be more required here.
        // Note: If we get many more conditions here, break them out.
        return nextTiles.all { tile in
            tile is Monster == false &&
            tile is Passable &&
            tile is MovableBlock == false &&
            tile is DirtTile == false
        }
    }

    func didMoveConditionallyMoveableTile(gameManager: GameManager,
                                          player: inout PlayerInfo,
                                          tilePosition: Position,
                                          direction: MoveDirection) {

        // Get the tiles under our block right now
        let tiles = gameManager.tiles.at(pos: tilePosition)
        if tiles.any({ $0 is WaterTile }) {
            // Add dirt
            gameManager.tiles.add(.dirt, at: tilePosition)
            // Remove self
            gameManager.tiles.remove(at: tilePosition, layer: layer())
        }
    }
}
