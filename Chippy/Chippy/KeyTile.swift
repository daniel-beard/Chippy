//
//  RedKeyTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/20/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class KeyTile: BaseTile, Collectable, Key {

    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo) {
        switch name {
            case "keyred": player.redKeyCount += 1
            case "keygreen": player.greenKeyCount += 1
            case "keyblue": player.blueKeyCount += 1
            case "keyyellow": player.yellowKeyCount += 1
            default: fatalError("Unknown key type!")
        }
    }
}
