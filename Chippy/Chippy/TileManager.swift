//
//  TileManager.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

class TileManager {

    var backgroundTileSet: SKTileMapNode
    var foregroundTileSet: SKTileMapNode
    var tileSets: [SKTileMapNode]

    init(backgroundTileSet: SKTileMapNode, foregroundTileSet: SKTileMapNode) {
        self.backgroundTileSet = backgroundTileSet
        self.foregroundTileSet = foregroundTileSet
        tileSets = [backgroundTileSet, foregroundTileSet]
    }

    // Factory method to create concrete tiles from their tileset names.
    func tileFactory(type: String) -> Tile? {
        switch type {
            case "Floor": return FloorTile(type)
            case "Block": return BlockTile(type)
            case "Help": return HelpTile(type)
            case "keyred", "keyblue", "keygreen", "keyyellow": return KeyTile(type)
            case "lockred", "lockblue", "lockgreen", "lockyellow": return LockTile(type)
            case "Chip": return ChipTile(type)
            case "Board": return BoardTile(type)
            default: print("Could not find tile implementation for tile type: \(type)")
        }
        return nil
    }

    func backgroundTileAtPosition(x: Int, y: Int) -> Tile? {
        guard let tileName = backgroundTileSet.tileDefinition(atColumn: x, row: y)?.name else {
            return nil
        }
        print("Tile at next position: \(tileName)")

        return tileFactory(type: tileName)
    }

    func foregroundTileAtPosition(x: Int, y: Int) -> Tile? {
        guard let tileName = foregroundTileSet.tileDefinition(atColumn: x, row: y)?.name else {
            return nil
        }
        return tileFactory(type: tileName)
    }

    func removeForegroundTileAtPosition(x: Int, y: Int) {
        foregroundTileSet.setTileGroup(nil, forColumn: x, row: y)
    }
}
