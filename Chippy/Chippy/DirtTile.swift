//
//  WaterTile.swift
//  Chippy
//
//  Created by Daniel Beard on 11/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class DirtTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer {
        return .one
    }
    
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return true
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: Position) {
        // Change to floor as a player walks over
        gameManager.tileManager.addTile(at: position, type: .floor)
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return false
    }
}