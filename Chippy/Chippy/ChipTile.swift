//
//  CollectableChipTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class ChipTile: BaseTile, Collectable {

    override func layer() -> TileLayer {
        return .two
    }

    internal func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo) {
        player.chipCount += 1
    }    
}
