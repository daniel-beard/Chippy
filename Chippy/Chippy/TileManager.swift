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

    // Raw tileMapNodes
    var backgroundTileSet: SKTileMapNode
    var interactiveTileSet: SKTileMapNode
    var moveableTileSet: SKTileMapNode

    var tileSets: [SKTileMapNode]

    // Prebuilt Tile 2dArrays
    private var backgroundTiles: Array2D<Tile>!
    private var interactiveTiles: Array2D<Tile>!
    private var moveableTiles: Array2D<Tile>!

    init(backgroundTileSet: SKTileMapNode,
         interactiveTileSet: SKTileMapNode,
         moveableTileSet: SKTileMapNode) {

        self.backgroundTileSet = backgroundTileSet
        self.interactiveTileSet = interactiveTileSet
        self.moveableTileSet = moveableTileSet
        tileSets = [backgroundTileSet, interactiveTileSet, moveableTileSet]

        loadAllTiles()
    }

    func loadAllTiles() {

        // Get default size:
        let cols = backgroundTileSet.numberOfColumns
        let rows = backgroundTileSet.numberOfRows

        // Init with default values
        backgroundTiles = Array2D<Tile>(cols: cols, rows: rows, defaultValue: nil)
        interactiveTiles = Array2D<Tile>(cols: cols, rows: rows, defaultValue: nil)
        moveableTiles = Array2D<Tile>(cols: cols, rows: rows, defaultValue: nil)

        // Load background tiles
        for x in 0..<cols {
            for y in 0..<rows {
                if let backgroundTile = backgroundTileSet.tileDefinition(atColumn: x, row: y),
                    let name = backgroundTile.name {
                    backgroundTiles[x, y] = tileFactory(type: name)
                }

                if let interactiveTile = interactiveTileSet.tileDefinition(atColumn: x, row: y),
                    let name = interactiveTile.name {
                    interactiveTiles[x, y] = tileFactory(type: name)
                }

                if let moveableTile = moveableTileSet.tileDefinition(atColumn: x, row: y),
                    let name = moveableTile.name {
                    moveableTiles[x, y] = tileFactory(type: name)
                }
            }
        }

    }

    // Factory method to create concrete tiles from their tileset names.
    func tileFactory(type: String) -> Tile? {
        switch type {
            case "Floor":           return FloorTile(type)
            case "Block":           return BlockTile(type)
            case "Help":            return HelpTile(type)
            case "Chip":            return ChipTile(type)
            case "Board":           return BoardTile(type)
            case "Home":            return HomeTile(type)
            case "MovableBlock":    return MovableBlock(type)
            case "keyred", "keyblue", "keygreen", "keyyellow": return KeyTile(type)
            case "lockred", "lockblue", "lockgreen", "lockyellow": return LockTile(type)
            default: print("Could not find tile implementation for tile type: \(type)")
        }
        return nil
    }

    func backgroundTileAtPosition(x: Int, y: Int) -> Tile? {
        return backgroundTiles[x, y]
    }

    func interactiveTileAtPosition(x: Int, y: Int) -> Tile? {
        return interactiveTiles[x, y]
    }

    func moveableTileAtPosition(x: Int, y: Int) -> Tile? {
        return moveableTiles[x, y]
    }

    func removeForegroundTileAtPosition(x: Int, y: Int) {
        interactiveTileSet.setTileGroup(nil, forColumn: x, row: y)
        interactiveTiles[x, y] = nil
    }
}
