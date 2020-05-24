//
//  BoostTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/16/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation

class BoostTile: BaseTile, ConditionallyPassable {

    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        //TODO: Implement. Consider a PlayerEffectable protocol for grabbing the player movement
        // Then we can use for Ice without skates, the boost tile, and the bear trap, etc.
        // Have to be able to grab key direction too for boost + keypress.
    }
}
