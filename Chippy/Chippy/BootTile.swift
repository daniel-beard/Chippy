//
//  BootTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/29/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class BootTile: BaseTile, Collectable, Boot {

    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo) {
        switch name {
        case "bootfire": player.hasFireBoots = true
        case "bootice":  player.hasIceSkates = true
        default: fatalError("Unknown key type!")
        }
    }
}
