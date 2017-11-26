//
//  TileManager.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

public enum TileLayer {
    case one
    case two
    case three
}

class TileManager {

    // Raw tileMapNodes
    private var backgroundTileSet: SKTileMapNode
    private var interactiveTileSet: SKTileMapNode
    private var moveableTileSet: SKTileMapNode

    private var tileSets: [SKTileMapNode]

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

    //MARK: Positions

    func absolutePointToPosition(_ absolutePoint: CGPoint) -> Position {
        return Position(x: backgroundTileSet.tileColumnIndex(fromPosition: absolutePoint), y: backgroundTileSet.tileRowIndex(fromPosition: absolutePoint))
    }

    func positionToAbsolutePoint(_ position: Position) -> CGPoint {
        return backgroundTileSet.centerOfTile(atColumn: position.x, row: position.y)
    }

    func centerOfTile(at position: Position) -> CGPoint {
        return backgroundTileSet.centerOfTile(atColumn: position.x, row: position.y)
    }

    //MARK: Tiles from Positions

    func tiles(at pos: Position) -> [Tile] {
        var result = [Tile?]()
        result.append( backgroundTiles[pos.x, pos.y] )
        result.append( interactiveTiles[pos.x, pos.y] )
        result.append( moveableTiles[pos.x, pos.y] )
        return result.flatMap{ $0 }
    }

    public func tiles(at pos: Position, offsetBy direction: MoveDirection) -> [Tile] {
        let newPosition = offset(position: pos, byDirection: direction)
        return tiles(at: newPosition)
    }

    public func tile(at pos: Position, layer: TileLayer) -> Tile? {
        return tile2DFromLayer(layer)[pos.x, pos.y]
    }

    // MARK: Layer calculations

    private func tileSetFromLayer(_ layer: TileLayer) -> SKTileMapNode {
        switch(layer) {
            case .one:      return backgroundTileSet
            case .two:      return interactiveTileSet
            case .three:    return moveableTileSet
        }
    }

    private func tile2DFromLayer(_ layer: TileLayer) -> Array2D<Tile> {
        switch layer {
            case .one: return backgroundTiles
            case .two: return interactiveTiles
            case .three: return moveableTiles
        }
    }

    // MARK: Moving TileSets

    // Only used when moving the player.
    // Offset is an absolute value.
    func offsetTileSets(by offset: CGPoint) {
        tileSets.forEach { tileSet in
            tileSet.position = tileSet.position + offset
        }
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

    func removeTile(at position: Position, layer: TileLayer) {
        // Tile Set
        setTileGroup(nil, at: position, layer: layer)

        // 2D Map
        tile2DFromLayer(layer)[position.x, position.y] = nil
    }

    func setTileGroup(_ tileGroup: SKTileGroup?, at position: Position, layer: TileLayer) {
        let tileSet = tileSetFromLayer(layer)
        tileSet.setTileGroup(tileGroup, forColumn: position.x, row: position.y)
    }

    func moveTile(at position: Position, layer: TileLayer, newPosition: Position) {
        let tileSet = tileSetFromLayer(layer)
        let tileGroup = (tileSet.tileGroup(atColumn: position.x, row: position.y)?.copy() as? SKTileGroup)
        let tileObj = tile2DFromLayer(layer)[position.x, position.y] // might need a copy here.

        print("Tile before remove: \(tileSet.tileGroup(atColumn: position.x, row: position.y)), \(tile2DFromLayer(layer)[position.x, position.y])")

        // remove from current position
        removeTile(at: position, layer: layer)

        // re-add to new position
        setTileGroup(tileGroup, at: newPosition, layer: layer)
        tile2DFromLayer(layer)[newPosition.x, newPosition.y] = tileObj

        print("Tile after remove: \(tileSet.tileGroup(atColumn: position.x, row: position.y)), \(tile2DFromLayer(layer)[position.x, position.y])")
    }
}

private extension TileManager {

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

        // Layer one tiles
        case "Floor":           return FloorTile(type, layer: .one)
        case "Help":            return HelpTile(type, layer: .one)
        case "Home":            return HomeTile(type, layer: .one)
        case "Block":           return BlockTile(type, layer: .one)

        // Layer two tiles
        case "Chip":            return ChipTile(type, layer: .two)
        case "Board":           return BoardTile(type, layer: .two)
        case "keyred", "keyblue", "keygreen", "keyyellow": return KeyTile(type, layer: .two)
        case "lockred", "lockblue", "lockgreen", "lockyellow": return LockTile(type, layer: .two)
        case "bootfire", "bootice": return BootTile(type, layer: .two)

        // Layer three tiles
        case "MovableBlock":    return MovableBlock(type, layer: .three)

        default: print("Could not find tile implementation for tile type: \(type)")
        }
        return nil
    }
}
