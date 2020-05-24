//
//  BoardTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/26/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class BoardTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .two }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { true }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) { }

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        player.chipCount >= gameManager.levelMetadata.chipsRequired
    }
}
