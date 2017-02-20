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

    //TODO: Factory method to create tile types from tilesets + position.

    //TODO: Make this non-optional after implementing all the tiles.
    func tileFactory(type: String) -> Tile? {
        switch type {
            case "Floor": return FloorTile()
            case "Block": return BlockTile()
            case "Help": return HelpTile()
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
}
