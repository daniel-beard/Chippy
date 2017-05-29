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
    fileprivate var backgroundTiles: Array2D<Tile>!
    fileprivate var interactiveTiles: Array2D<Tile>!
    fileprivate var moveableTiles: Array2D<Tile>!

    init(backgroundTileSet: SKTileMapNode,
         interactiveTileSet: SKTileMapNode,
         moveableTileSet: SKTileMapNode) {

        self.backgroundTileSet = backgroundTileSet
        self.interactiveTileSet = interactiveTileSet
        self.moveableTileSet = moveableTileSet
        tileSets = [backgroundTileSet, interactiveTileSet, moveableTileSet]

        loadAllTiles()
    }

    //MARK: Positions

    func absolutePointToPosition(_ absolutePoint: CGPoint) -> Position {
        return Position(x: backgroundTileSet.tileColumnIndex(fromPosition: absolutePoint), y: backgroundTileSet.tileRowIndex(fromPosition: absolutePoint))
    }

    func positionToAbsolutePoint(_ position: Position) -> CGPoint {
        return backgroundTileSet.centerOfTile(atColumn: position.x, row: position.y)
    }

    //MARK: Tiles from Positions

    func backgroundTile(at pos: Position) -> Tile? {
        return backgroundTiles[pos.x, pos.y]
    }

    func interactiveTile(at pos: Position) -> Tile? {
        return interactiveTiles[pos.x, pos.y]
    }

    func moveableTile(at pos: Position) -> Tile? {
        return moveableTiles[pos.x, pos.y]
    }

    //MARK: Tile Sizing

    func tileSize() -> CGSize {
        return backgroundTileSet.tileSize
    }

    //MARK: Tile Operations

    func removeForegroundTile(at position: Position) {
        interactiveTileSet.setTileGroup(nil, forColumn: position.x, row: position.y)
        interactiveTiles[position.x, position.y] = nil
    }
}

fileprivate extension TileManager {

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
}
