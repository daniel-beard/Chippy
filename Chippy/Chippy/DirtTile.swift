//
//  WaterTile.swift
//  Chippy
//
//  Created by Daniel Beard on 11/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class DirtTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        // Change to floor as a player walks over
        gameManager.tiles.add(.floor, at: position)
    }
}
