//
//  HomeTile.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class HomeTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer {
        return .one
    }

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return true
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: Position) {
        // Display end game message
        NotificationCenter.default.post(name: Notification.Name("DisplayEndGameLabel"), object: nil)
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return false
    }
}
