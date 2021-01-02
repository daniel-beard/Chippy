//
//  Tile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import CoreGraphics

/// Enum that maps from tile type to tileset name
public enum TileType: String {
    case water          = "water"
    case floor          = "Floor"
    case block          = "Block"
    case movableblock   = "MovableBlock"
    case help           = "Help"
    case home           = "Home"
    case chip           = "Chip"
    case board          = "Board"
    case bluekey        = "keyblue"
    case redkey         = "keyred"
    case greenkey       = "keygreen"
    case yellowkey      = "keyyellow"
    case redlock        = "lockred"
    case bluelock       = "lockblue"
    case greenlock      = "lockgreen"
    case yellowlock     = "lockyellow"
    case fireboot       = "bootfire"
    case iceskate       = "bootice"
    case flipper        = "bootwater"
    case suctionboot    = "bootsuction"
    case dirt           = "dirt"
    case fire           = "firefloor"
    case boostup        = "boostup"
    case boostright     = "boostright"
    case boostdown      = "boostdown"
    case boostleft      = "boostleft"

    // Monsters
    case bug            = "bug"

    // UI only tiles
    case firebootfloor      = "firebootfloor"
    case iceskatefloor      = "iceskatefloor"
    case flipperfloor       = "flipperfloor"
    case suctionbootfloor   = "suctionbootfloor"
    case redkeyfloor    = "redkeyfloor"
    case bluekeyfloor   = "bluekeyfloor"
    case yellowkeyfloor = "yellowkeyfloor"
    case greenkeyfloor  = "greenkeyfloor"
}

protocol Tile {
    var name: String { get set }
    func layer() -> TileLayer
    init(name: String)
}

// Collectable tiles are removed from the tileset after a player visits that tile
// E.g. Chips, Keys, etc.
protocol Collectable: Tile {

    // A method called on a Tile that allows the tile to update game state
    // An example would be adding to the Player's key count when colliding with a key.
    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo)
}

// Passable tiles control where the player can move.
protocol Passable: Tile {}

// Tiles that can be passed after a condition is met.
protocol ConditionallyPassable {

    // Called to check if a player satisfies the conditions to move to this tile.
    // E.g. if this is a "lock", we check that the PlayerInfo's key count for that color is correct.
    // This method should not modify state, only check the pre-conditions
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool

    // Called after a player moves to a conditionally passable tile
    // This method is encouraged to change state. E.g. updating key counts after passing through a lock.
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo, position: GridPos)

    // Indicates whether the Game Manager should remove this tile after the player moves through it
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool
}

// Tiles that can move like blocks
protocol ConditionallyMoveable: Tile {

    // Called to check if a player moving in a certain direction can move this tile.
    // Usually depends on what is in "front" of the conditionally moveable tile relative to the player.
    func canPlayerMoveTile(gameManager: GameManager,
                           player: PlayerInfo,
                           tilePosition: GridPos,
                           direction: GridDirection) -> Bool

    // Called after the player has moved the tile.
    // Handle things like changing the tile type here. E.g. block + water -> dirt
    func didMoveConditionallyMoveableTile(gameManager: GameManager,
                                          player: inout PlayerInfo,
                                          tilePosition: GridPos,
                                          direction: GridDirection)
}

// Tiles that monsters can pass
protocol MonsterPassable {}

// Tiles that can capture, or move the player in some way.
// They have the capability to capture key inputs
protocol PlayerEffectable: ConditionallyPassable {
    var playerEffectType: PlayerEffect { get }
}

// All boosts conform to this protocol
protocol Boost: Tile, PlayerEffectable {
    var forceDirection: GridDirection { get }
}

// All keys conform to this protocol
protocol Key: Tile {}

// All locks conform to this protocol
protocol Lock: Tile {}

// All boots conform to this protocol
protocol Boot: Tile {}

// All monsters conform to this protocol
protocol Monster {}

