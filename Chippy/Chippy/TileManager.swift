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

    // TileSet
    var spriteKitTileSet: SKTileSet

    private var tileSets: [SKTileMapNode]

    // Prebuilt Tile 2dArrays
    private var backgroundTiles: Array2D<Tile>!
    private var interactiveTiles: Array2D<Tile>!
    private var moveableTiles: Array2D<Tile>!

    init(backgroundTileSet: SKTileMapNode,
         interactiveTileSet: SKTileMapNode,
         moveableTileSet: SKTileMapNode) {

        // hacky
        guard let spriteKitTileSet = SKTileSet(named: "TileSet") else {
            fatalError("Could not load tile set from disk")
        }
        self.spriteKitTileSet = spriteKitTileSet
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
        return result.compactMap{ $0 }
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

    func addTile(at position: Position, type: TileType) {
        guard let tileClass = TileManager.mapTileEnumToClassName(tileType: type) else {
            fatalError("Could not create tile from type: \(type.rawValue)")
        }
        let newTile = tileClass.init(type.rawValue)

        // Remove any existing tiles at the same layer
        removeTile(at: position, layer: newTile.layer())

        // Get the tile group from the tileset
        guard let tileGroup = spriteKitTileSet.tileGroups.first(where: { $0.name == type.rawValue }) else {
            fatalError("Could not find tileGroup in tileSet: \(type.rawValue)")
        }

        // Update tileSet and 2D map
        let tileSet = tileSetFromLayer(newTile.layer())
        tileSet.setTileGroup(tileGroup, forColumn: position.x, row: position.y)
        tile2DFromLayer(newTile.layer())[position.x, position.y] = newTile
    }

    func removeForegroundTile(at position: Position) {
        interactiveTileSet.setTileGroup(nil, forColumn: position.x, row: position.y)
        interactiveTiles[position.x, position.y] = nil
    }

    func removeTile(at position: Position, layer: TileLayer) {
        // Tile Set
        setTileGroup((nil, nil), at: position, layer: layer)

        // 2D Map
        tile2DFromLayer(layer)[position.x, position.y] = nil
    }

    typealias SpriteTile = (group: SKTileGroup?, definition: SKTileDefinition?)
    private func setTileGroup(_ spriteTile: SpriteTile, at position: Position, layer: TileLayer) {
        let tileSet = tileSetFromLayer(layer)
        guard let group = spriteTile.group, let definition = spriteTile.definition else {
            tileSet.setTileGroup(nil, forColumn: position.x, row: position.y)
            return
        }
        tileSet.setTileGroup(group, andTileDefinition: definition, forColumn: position.x, row: position.y)
    }

    /// Moves a tile on a given layer from one position to another.
    /// This affects both the Tile & Sprite based representations
    func moveTile(at position: Position, layer: TileLayer, newPosition: Position) {
        let tileSet = tileSetFromLayer(layer)
        let tileDefinition = tileSet.tileDefinition(atColumn: position.x, row: position.y)
        let tileGroup = tileSet.tileGroup(atColumn: position.x, row: position.y)
        let tileObj = tile2DFromLayer(layer)[position.x, position.y]

        // remove from current position
        removeTile(at: position, layer: layer)

        // re-add to new position
        // Note: Need both the tileGroup and the definition here.
        setTileGroup((group: tileGroup, definition: tileDefinition), at: newPosition, layer: layer)
        tile2DFromLayer(layer)[newPosition.x, newPosition.y] = tileObj
    }
}

//MARK: Tile Loading
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
    // Used when populating our 2D maps from the existing level tilemaps.
    func tileFactory(type: String) -> Tile? {

        guard let tileType = TileType(rawValue: type) else {
            print("Could not find tile implementation for tile type: \(type)")
            return nil
        }

        guard let tileClass = TileManager.mapTileEnumToClassName(tileType: tileType) else {
            fatalError("Class mapping not found for tile type: \(type)")
        }
        return tileClass.init(type)
    }

    /// We need this because our mapping from tile type isn't 1-1 with class names
    /// Also centralizes this mapping.
    /// Some classes hold multiple types, e.g. boots, keys, locks, etc.
    static func mapTileEnumToClassName(tileType: TileType) -> Tile.Type? {
        switch tileType {
            case .block:            return BlockTile.self
            case .water:            return WaterTile.self
            case .floor:            return FloorTile.self
            case .movableblock:     return MovableBlock.self
            case .help:             return HelpTile.self
            case .home:             return HomeTile.self
            case .chip:             return ChipTile.self
            case .board:            return BoardTile.self
            case .bluekey:          return KeyTile.self
            case .redkey:           return KeyTile.self
            case .greenkey:         return KeyTile.self
            case .yellowkey:        return KeyTile.self
            case .redlock:          return LockTile.self
            case .bluelock:         return LockTile.self
            case .greenlock:        return LockTile.self
            case .yellowlock:       return LockTile.self
            case .fireboot:         return BootTile.self
            case .iceskate:         return BootTile.self
            case .flipper:          return BootTile.self
            case .dirt:             return DirtTile.self
        }
    }
}

//MARK: Sprite Loading
/// These extensions are used for loading raw sprites, for things like the UI
extension TileManager {

    static func loadUISprite(byType type: TileType, scaleFactor: CGFloat = 1.0) -> SKTileGroup {
        // Get the tile group from the tileset
        guard let spriteKitTileSet = SKTileSet(named: "TileSet") else {
            fatalError("Could not load tile set from disk")
        }
        guard let tileGroup = spriteKitTileSet.tileGroups.first(where: { $0.name == type.rawValue }) else {
            fatalError("Could not find tileGroup in tileSet: \(type.rawValue)")
        }
        return tileGroup
    }

    static func uiTileSet() -> SKTileSet {
        guard let spriteKitTileSet = SKTileSet(named: "TileSet") else {
            fatalError("Could not load tile set from disk")
        }
        return spriteKitTileSet
    }
}
