//
//  CollectableChipTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class ChipTile: BaseTile, Collectable {
    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo) {
        player.chipCount += 1
    }
    override func layer() -> TileLayer { .two }
}
