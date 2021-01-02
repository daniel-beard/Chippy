//
//  BoostTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/16/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation

// Boost Tiles
class BoostTile: BaseTile, ConditionallyPassable, PlayerEffectable, Boost {
    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        // Nothing, handled in player class.
    }

    var playerEffectType: PlayerEffect = .conveyor
    var forceDirection: GridDirection {
        switch name {
            case "boostup": return .up
            case "boostright": return .right
            case "boostdown": return .down
            case "boostleft": return .left
            default: fatalError("Unknown boost type!")
        }
    }
}
