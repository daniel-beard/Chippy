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

class GameScene: SKScene {

    var entities = [GKEntity]()
    var graphs = [String: GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0

    convenience init?(fileNamed filename: String) {
        self.init(fileNamed: filename)
    }

    override func sceneDidLoad() {
        super.sceneDidLoad()

        let chippy = LevelLoader.loadPlayerSprite(scene: scene!)

        if let scene = scene {
            let cameraNode = SKCameraNode()
            cameraNode.position = chippy.position
            scene.addChild(cameraNode)
            scene.camera = cameraNode

            let zoomInAction = SKAction.scale(to: 2.0, duration: 5)
            cameraNode.run(zoomInAction)
        }

        self.lastUpdateTime = 0
    }
    
    
//    func touchDown(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.green()
//            self.addChild(n)
//        }
//    }
//    
//    func touchMoved(toPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.blue()
//            self.addChild(n)
//        }
//    }
//    
//    func touchUp(atPoint pos : CGPoint) {
//        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
//            n.position = pos
//            n.strokeColor = SKColor.red()
//            self.addChild(n)
//        }
//    }
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
//        
//        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
//    }

    
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


