//
//  Tile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

protocol Tile {
    var name: String { get set }
    init(_ name: String)
}

// Collectable tiles are removed from the tileset after a player visits that tile
// E.g. Chips, Keys, etc.
protocol Collectable {

    // A method called on a Tile that allows the tile to update game state
    // An example would be adding to the Player's key count when colliding with a key.
    func performCollectableAction(gameManager: GameManager, player: inout PlayerInfo)
}

// Passable tiles control where the player can move.
protocol Passable {}

// Tiles that can be passed after a condition is met.
protocol ConditionallyPassable {

    // Called to check if a player satisfies the conditions to move to this tile.
    // E.g. if this is a "lock", we check that the PlayerInfo's key count for that color is correct.
    // This method should not modify state, only check the pre-conditions
    func canPlayerConditionallyPassTile(gameManager: GameManager, player: PlayerInfo) -> Bool

    // Called after a player moves to a conditionally passable tile
    // This method is encouraged to change state. E.g. updating key counts after passing through a lock.
    func playerDidPassConditionalTile(gameManager: GameManager, player: inout PlayerInfo)

    // Indicates whether the Game Manager should remove this tile after the player moves through it
    func shouldRemoveConditionallyPassableTileAfterCollision() -> Bool
}

protocol ConditionallyMoveable {

    // Called to check if a player moving in a certain direction can move this tile.
    // Usually depends on what is in "front" of the conditionally moveable tile relative to the player.
    func canMoveConditionallyMoveableTile(gameManager: GameManager, player: inout PlayerInfo, direction: MoveDirection) -> Bool

    // Called to actually move the conditional tile.
    // Should handle tile updates here.
    func moveConditionallyMoveableTile(gameManager: GameManager, player: inout PlayerInfo, direction: MoveDirection)
}

// All keys conform to this protocol
protocol Key {}

// All locks conform to this protocol
protocol Lock {}


