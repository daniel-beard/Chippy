//
//  WaterTile.swift
//  Chippy
//
//  Created by Daniel Beard on 11/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class WaterTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager,
                                        player: PlayerInfo,
                                        tilePos: GridPos) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        if !player.hasFlippers {
            gameNotif(name: "DisplayDied", userInfo: [
                "message": "Oops! Chippy can't swim without flippers!"
            ])
        }
    }
}
