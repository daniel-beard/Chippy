//
//  LevelLoader.swift
//  Chippy
//
//  Created by Daniel Beard on 2/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

// Level metadata, this is passed to GameManager
struct LevelMetadata {
    /// Level number
    let number: Int
    /// Help message
    let help: String
    /// Required number of chips
    let chipsRequired: Int
    /// Timer length in seconds
    let timer: Int
}

class LevelLoader {

    private static let levels = [
        LevelMetadata(number: 1, help: "Test", chipsRequired: 11, timer: 100),
        LevelMetadata(number: 2, help: "Test", chipsRequired: 4, timer: 100),
        LevelMetadata(number: 3, help: "Test", chipsRequired: 4, timer: 100),
        LevelMetadata(number: 4, help: "Test", chipsRequired: 9, timer: 150),
        LevelMetadata(number: 5, help: "Test", chipsRequired: 0, timer: 100),
        LevelMetadata(number: 6, help: "Test", chipsRequired: 4, timer: 100),
        LevelMetadata(number: 7, help: "Test", chipsRequired: 3, timer: 150)
    ]

    static func levelMetadata(forLevelNumber levelNumber: Int) -> LevelMetadata {
        levels[levelNumber-1]
    }

    static func scene(level: LevelMetadata) -> SKScene {
        SKScene(fileNamed: "Level\(level.number)")!
    }

    static func loadBackgroundTiles(scene: SKScene) -> SKTileMapNode {
        scene.childNode(withName: "Background") as! SKTileMapNode
    }

    static func loadForegroundTiles(scene: SKScene) -> SKTileMapNode {
        scene.childNode(withName: "Interactive") as! SKTileMapNode
    }

    static func loadMoveableTiles(scene: SKScene) -> SKTileMapNode {
        scene.childNode(withName: "Top") as! SKTileMapNode
    }

    static func loadPlayerSprite(scene: SKScene) -> SKSpriteNode {
        loadBackgroundTiles(scene: scene).childNode(withName: "Chippy") as! SKSpriteNode
    }

    static func verifyLevel(levelNumber: Int) -> Bool {
        // Get the level metadata
        let level = LevelLoader.levelMetadata(forLevelNumber: levelNumber)
        let fileName = "Level\(level.number)"

        guard let _ = GKScene(fileNamed: fileName) else {
            fatalError("Could not load game scene from file")
        }

        // Load scene from the bundle
        guard let scene = SKScene(fileNamed: fileName) else {
            fatalError("Could not load scene from file")
        }

        // Check that the tileMaps exist, and that chippy exists.
        guard let backgroundTiles = scene.childNode(withName: "Background") as? SKTileMapNode else {
            fatalError("Could not find a background tile set.")
        }

        guard let interactiveTiles = scene.childNode(withName: "Interactive") as? SKTileMapNode else {
            fatalError("Could not find interactive tile set.")
        }

        guard let moveableTiles = scene.childNode(withName: "Top") as? SKTileMapNode else {
            fatalError("Could not find moveable tile set.")
        }

        guard let playerSprite = backgroundTiles.childNode(withName: "Chippy") as? SKSpriteNode else {
            fatalError("Could not find Chippy sprite!")
        }

        if backgroundTiles.tileSize != interactiveTiles.tileSize || backgroundTiles.tileSize != moveableTiles.tileSize {
            fatalError("Tile sizes MUST be equal.")
        }

        if playerSprite.parent != backgroundTiles {
            fatalError("Player sprite must be a child node of the background tiles")
        }

        // Verify that the tileMaps are all the same size
        if backgroundTiles.mapSize != interactiveTiles.mapSize || backgroundTiles.mapSize != moveableTiles.mapSize {
            fatalError("Maps must all be the same size!")
        }
        return true
    }
}
