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
    let levelNumber: Int
    let helpMessage: String
    let chipsRequired: Int
    let timerSeconds: Int
    let sceneName: String
}

class LevelLoader {

    //TODO: Remove levelnumber and scenenames from these decls.
    private static let levels = [
        LevelMetadata(
            levelNumber: 1,
            helpMessage: "This is a test help message",
            chipsRequired: 11,
            timerSeconds: 100,
            sceneName: "Level1"
        ),
        LevelMetadata(
            levelNumber: 2,
            helpMessage: "Another test help message",
            chipsRequired: 4,
            timerSeconds: 100,
            sceneName: "Level2"
        ),
        LevelMetadata(
            levelNumber: 3,
            helpMessage: "Test",
            chipsRequired: 4,
            timerSeconds: 100,
            sceneName: "Level3"
        ),
        LevelMetadata(
            levelNumber: 4,
            helpMessage: "Test",
            chipsRequired: 9,
            timerSeconds: 150,
            sceneName: "Level4"
        )
    ]

    static func levelMetadata(forLevelNumber levelNumber: Int) -> LevelMetadata {
        return levels[levelNumber-1]
    }

    static func scene(metadata: LevelMetadata) -> SKScene {
        return SKScene(fileNamed: metadata.sceneName)!
    }

    static func loadBackgroundTiles(scene: SKScene) -> SKTileMapNode {
        return scene.childNode(withName: "Background") as! SKTileMapNode
    }

    static func loadForegroundTiles(scene: SKScene) -> SKTileMapNode {
        return scene.childNode(withName: "Interactive") as! SKTileMapNode
    }

    static func loadMoveableTiles(scene: SKScene) -> SKTileMapNode {
        return scene.childNode(withName: "Top") as! SKTileMapNode
    }

    static func loadPlayerSprite(scene: SKScene) -> SKSpriteNode {
        return loadBackgroundTiles(scene: scene).childNode(withName: "Chippy") as! SKSpriteNode
    }

    static func verifyLevel(levelNumber: Int) -> Bool {

        // Get the level metadata
        let levelMetadata = LevelLoader.levelMetadata(forLevelNumber: levelNumber)

        guard let _ = GKScene(fileNamed: levelMetadata.sceneName) else {
            fatalError("Could not load game scene from file")
        }

        // Load scene from the bundle
        guard let scene = SKScene(fileNamed: levelMetadata.sceneName) else {
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
