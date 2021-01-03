//
//  File.swift
//  Chippy
//
//  Created by Daniel Beard on 1/2/21.
//  Copyright © 2021 DanielBeard. All rights reserved.
//

import Foundation

enum IceType {
    case normal
    case btmLeft
    case btmRight
    case topLeft
    case topRight
}

class IceTile: BaseTile, ConditionallyPassable, PlayerEffectable {
    var playerEffectType: PlayerEffect = .ice
    override func layer() -> TileLayer { .one }
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool { true }
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        // Nothing, handled in player class.
    }

    func iceType() -> IceType {
        switch name {
            case "ice":                     return .normal
            case "icecornertopleft":        return .topLeft
            case "icecornertopright":       return .topRight
            case "icecornerbottomleft":     return .btmLeft
            case "icecornerbottomright":    return .btmRight
            default: fatalError("Unknown ice type")
        }
    }
}
