//
//  WaterTile.swift
//  Chippy
//
//  Created by Daniel Beard on 11/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class DirtTile: BaseTile, ConditionallyPassable {

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return true
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo) {
        // Remove tile
        // Add tile of type 'floor'
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return false
    }
}
