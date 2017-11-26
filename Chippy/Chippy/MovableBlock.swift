//
//  MovableBlock.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import CoreGraphics

class MovableBlock :BaseTile, Passable, ConditionallyMoveable {

    func canPlayerMoveTile(gameManager: GameManager,
                           player: PlayerInfo,
                           tilePosition: Position,
                           direction: MoveDirection) -> Bool {

        var result = false

        let nextTiles = gameManager.tileManager.tiles(at: tilePosition, offsetBy: direction)
        var tilesRemaining = nextTiles

        // Here we whitelist the conditions when we can move this block
        // Not sure if there will be more required here.
        let haveMonster = tilesRemaining.any { $0 is Monster }
        tilesRemaining = tilesRemaining.filter { !($0 is Monster) }
        let canPassRestOfTiles = tilesRemaining.all { $0 is Passable && !($0 is MovableBlock) }

        result = !haveMonster && canPassRestOfTiles
        print("Trying to pass block with result: \(result)")
        return result
    }

    func moveConditionallyMoveableTile(gameManager: GameManager,
                                       player: inout PlayerInfo,
                                       tilePosition: Position,
                                       direction: MoveDirection) {

    }
}
