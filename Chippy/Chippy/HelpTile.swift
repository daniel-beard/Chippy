//
//  HelpTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class HelpTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager,
                                        player: PlayerInfo,
                                        tilePos: GridPos) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        NotificationCenter.gameNotification(name: Notification.Name("DisplayHelp"), userInfo: [
            "message": gameManager.levelMetadata.helpMessage
        ])
    }
}
