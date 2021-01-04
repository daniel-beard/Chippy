//
//  LockTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/20/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class LockTile: BaseTile, ConditionallyPassable, Lock {

    override func layer() -> TileLayer { .two }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { true }

    func canPlayerConditionallyPassTile(gameManager: GameManager,
                                        player: PlayerInfo,
                                        tilePos: GridPos) -> Bool {
        switch name {
            case "lockgreen":   return player.greenKeyCount > 0
            case "lockblue":    return player.blueKeyCount > 0
            case "lockred":     return player.redKeyCount > 0
            case "lockyellow":  return player.yellowKeyCount > 0
            default:            fatalError("Unrecognized lock type")
        }
    }

    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        switch name {
            case "lockgreen":   player.greenKeyCount -= 1
            case "lockblue":    player.blueKeyCount -= 1
            case "lockred":     player.redKeyCount -= 1
            case "lockyellow":  player.yellowKeyCount -= 1
            default:            fatalError("Unrecognized lock type")
        }
    }
}
