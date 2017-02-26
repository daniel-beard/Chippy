//
//  BoardTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/26/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class BoardTile: BaseTile, ConditionallyPassable {

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return player.chipCount >= gameManager.levelMetadata.chipsRequired
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo) {
        // nothin'
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return true
    }
}
