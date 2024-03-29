//
//  FireTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/16/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation

class FireTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }
    func canPlayerConditionallyPassTile(gameManager: GameManager,
                                        player: PlayerInfo,
                                        tilePos: GridPos) -> Bool { true }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        if !player.hasFireBoots {
            gameNotif(name: .displayDied, userInfo: [
                "message": "Oops! Chippy can't walk on fire without fire boots!"
            ])
        }
    }
}
