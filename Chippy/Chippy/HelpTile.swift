//
//  HelpTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class HelpTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer {
        return .one
    }

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool {
        return true
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: Position) {
        NotificationCenter.default.post(
            name: Notification.Name("DisplayHelp"),
            object: nil,
            userInfo: [
                "message": gameManager.levelMetadata.helpMessage
            ]
        )
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool {
        return false
    }
}
