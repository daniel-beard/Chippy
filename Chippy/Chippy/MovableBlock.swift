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

    func canPlayerMoveTile(gameManager: GameManager,
                           player: PlayerInfo,
                           tilePosition: Position,
                           direction: MoveDirection) -> Bool {

        let nextTiles = gameManager.tileManager.tiles(at: tilePosition, offsetBy: direction)
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

        //TODO: Handle tile type changes here.
    }
}
