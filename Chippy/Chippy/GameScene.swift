//
//  GameScene.swift
//  Chippy
//
//  Created by Daniel Beard on 7/9/16.
//  Copyright © 2016 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

enum MoveDirection {
    case left
    case right
    case up
    case down
}

enum GameState {
    case inProgress
    case failed
    case completed
}

class GameScene: SKScene {

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()

    // Indicates that we are running an animation just before pausing.
    // Means that we should discard keypresses.
    var isPausing = false

    // Game State: Used to determine actions after pausing or showing messages
    var gameState: GameState = .inProgress
    
    private var lastUpdateTime : TimeInterval = 0

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func sceneDidLoad() {
        super.sceneDidLoad()

        tearDownNotifications()
        setupNotifications()

        let chippy = LevelLoader.loadPlayerSprite(scene: scene!)

        if let scene = scene {
            let cameraNode = SKCameraNode()
            cameraNode.position = chippy.position
            scene.addChild(cameraNode)
            scene.camera = cameraNode

            let zoomInAction = SKAction.scale(to: 2.0, duration: 5)
            cameraNode.run(zoomInAction)

            // debugging
            view?.showsNodeCount = true
        }

        self.lastUpdateTime = 0
        self.gameState = .inProgress
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
}

//MARK: Movement extension
extension GameScene {

    func move(direction: MoveDirection) {

        guard let gameManager = LevelRepository.sharedInstance.gameManager else {
            return
        }

        // Drop all events if we are in the process of pausing the game with an animation
        if self.isPausing {
            return
        }

        // unpause the scene (for stuff like the help message)
        if let paused = scene?.view?.isPaused, paused == true {
            removeOverlays()
            scene?.view?.isPaused = false

            // Check game state
            // Load new level.
            if case .completed = gameState {
                NotificationCenter.default.post(
                    name: Notification.Name("LoadLevel"),
                    object: nil,
                    userInfo: ["level": gameManager.nextLevelNumber()]
                )
            }
        }

        let offset: (dx: Int, dy: Int)
        switch direction {
            case .left: offset = (-1, 0)
            case .right: offset = (1, 0)
            case .up: offset = (0, 1)
            case .down: offset = (0, -1)
        }

        if gameManager.canPlayerMoveByRelativeOffset(dx: offset.dx, dy: offset.dy) {
            gameManager.movePlayerByRelativeOffset(dx: offset.dx, dy: offset.dy)
        }
    }
}

//MARK: Notifications
extension GameScene {

    func tearDownNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameScene.displayHelp),
            name: Notification.Name("DisplayHelp"),
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(GameScene.displayEndGameLabel),
            name: Notification.Name("DisplayEndGameLabel"),
            object: nil
        )
    }

    func removeOverlays() {
        guard let scene = scene else { return }

        if let helpOverlay = scene.childNode(withName: "help_overlay") {
            helpOverlay.removeFromParent()
        }
    }

    @objc func displayEndGameLabel(notification: Notification) {
        guard let scene = scene else {
            return
        }

        self.gameState = .completed
        self.isPausing = true
        let chippy = LevelLoader.loadPlayerSprite(scene: scene)
        let background = LevelLoader.loadBackgroundTiles(scene: scene)
        let message = "Congradulations, a new record!\nPress any key to continue."
        let endGameOverlay = informativeTextLabel(origin: chippy.position,
                                                  message: message)

        // Convert to world coords.
        let worldPosition = scene.convert(endGameOverlay.position, from: background)
        endGameOverlay.position = worldPosition
        endGameOverlay.name = "help_overlay"
        scene.addChild(endGameOverlay)

        afterDelay(0.2) {
            self.view?.isPaused = true
            self.isPausing = false
        }
    }

    @objc func displayHelp(notification: Notification) {

        guard let scene = scene, let message = notification.userInfo?["message"] as? String else {
            return
        }

        self.isPausing = true
        let chippy = LevelLoader.loadPlayerSprite(scene: scene)
        let background = LevelLoader.loadBackgroundTiles(scene: scene)
        let helpOverlay = informativeTextLabel(origin: chippy.position, message: message)

        // Convert to world coords.
        let worldPosition = scene.convert(helpOverlay.position, from: background)
        helpOverlay.position = worldPosition
        helpOverlay.name = "help_overlay"
        scene.addChild(helpOverlay)

        afterDelay(0.2) {
            self.view?.isPaused = true
            self.isPausing = false
        }

    }
}


