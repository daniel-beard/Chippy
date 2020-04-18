//
//  WaterTile.swift
//  Chippy
//
//  Created by Daniel Beard on 11/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class WaterTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer {
        return .one
    }

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return true
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: Position) {
        if !player.hasFlippers {
            NotificationCenter.default.post(name: Notification.Name("DisplayDied"), object: nil, userInfo: [
                "message": "Oops! Chippy can't swim without flippers!"
            ])
        }
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return false
    }
}
