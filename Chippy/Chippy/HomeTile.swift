//
//  HomeTile.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class HomeTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }
    func canPlayerConditionallyPassTile(gameManager: GameManager,
                                        player: PlayerInfo,
                                        tilePos: GridPos) -> Bool { true }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        // Display end game message
        gameNotif(name: "DisplayEndGameLabel")
    }
}
