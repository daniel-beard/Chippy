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

class IceTile: BaseTile, ConditionallyPassable, ConditionallyLeavable, PlayerEffectable {


    var playerEffectType: PlayerEffect = .ice
    override func layer() -> TileLayer { .one }

    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo, tilePos: GridPos) -> Bool {
        let playerPos = gameManager.tiles.gridPosition(forPoint: player.absolutePoint())
        var result = false
        switch iceType() {
            case .normal: result = true
            case .topLeft:
                result = playerPos + .left() == tilePos || playerPos + .up() == tilePos
            case .topRight:
                result = playerPos + .right() == tilePos || playerPos + .up() == tilePos
            case .btmLeft:
                result = playerPos + .down() == tilePos || playerPos + .left() == tilePos
            case .btmRight:
                result = playerPos + .down() == tilePos || playerPos + .right() == tilePos
        }
        return result
    }

    func canPlayerConditionallyLeaveTile(gameManager: GameManager,
                                         player: PlayerInfo,
                                         tilePos: GridPos,
                                         inDirection direction: GridDirection) -> Bool {
        switch iceType() {
            case .normal: return true
            case .topLeft:
                return direction == .right || direction == .down
            case .topRight:
                return direction == .left || direction == .down
            case .btmLeft:
                return direction == .up || direction == .right
            case .btmRight:
                return direction == .up || direction == .left
        }
    }

    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool { false }
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos) {
        // Nothing, handled in player class.
    }

    // This function returns the next direction for a given tile.
    // It is assumed that the players current position should be ON this tile.
    func nextDirection(fromLastDirection lastDir: GridDirection) -> GridDirection {
        let nextDir: GridDirection
        switch iceType() {
            case .topLeft:
                if lastDir == .up           { nextDir = .right }
                else                        { nextDir = .down }
            case .topRight:
                if lastDir == .right        { nextDir = .down }
                else                        { nextDir = .left }
            case .btmLeft:
                if lastDir == .down         { nextDir = .right }
                else                        { nextDir = .up }
            case .btmRight:
                if lastDir == .down         { nextDir = .left }
                else                        { nextDir = .up }
            default: nextDir = lastDir
        }
        return nextDir
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
