//
//  BootTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/29/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class BootTile: BaseTile, Passable, Collectable, Boot {

    override func layer() -> TileLayer {
        return .two
    }

    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo) {
        switch name {
            case "bootfire":    player.hasFireBoots = true
            case "bootice":     player.hasIceSkates = true
            case "bootwater":   player.hasFlippers = true
            case "bootsuction": player.hasSuctionBoots = true
            default: fatalError("Unknown key type!")
        }
    }
}
