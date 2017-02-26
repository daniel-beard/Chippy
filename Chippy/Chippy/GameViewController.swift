//
//  GameViewController.swift
//  Chippy
//
//  Created by Daniel Beard on 7/9/16.
//  Copyright © 2016 DanielBeard. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    var gameScene: GKScene!
    var sceneNode: GameScene!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupNotifications()

//        self.perform(#selector(test), with: nil, afterDelay: 5.0)
    }

//    func test() {
//        let notificationName = Notification.Name("LoadLevel")
//        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["level": 1])
//    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel(levelNumber: 1)
    }

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//MARK: Movement
internal extension GameViewController {
    func swipeUp() { sceneNode.move(direction: .up) }
    func swipeDown() { sceneNode.move(direction: .down) }
    func swipeLeft() { sceneNode.move(direction: .left) }
    func swipeRight() { sceneNode.move(direction: .right) }

    override var keyCommands: [UIKeyCommand]? {
        return [
            UIKeyCommand(input: UIKeyInputUpArrow,      modifierFlags: [], action: #selector(swipeUp)),
            UIKeyCommand(input: UIKeyInputDownArrow,    modifierFlags: [], action: #selector(swipeDown)),
            UIKeyCommand(input: UIKeyInputLeftArrow,    modifierFlags: [], action: #selector(swipeLeft)),
            UIKeyCommand(input: UIKeyInputRightArrow,   modifierFlags: [], action: #selector(swipeRight)),
        ]
    }
}

//MARK: Level Loading and Notifications
fileprivate extension GameViewController {

    @objc func loadLevelFromNotification(notification: Notification) {
        guard let levelNumber = notification.userInfo?["level"] as? Int else {
            return
        }
        loadLevel(levelNumber: levelNumber)
    }

    func loadLevel(levelNumber: Int) {
        _ = LevelLoader.verifyLevel(levelNumber: levelNumber)
        let levelMetadata = LevelLoader.levelMetadata(forLevelNumber: levelNumber)

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: levelMetadata.sceneName) {

            gameScene = scene

            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {

                // Create the game manager
                LevelRepository.sharedInstance.setGameManager(GameManager(scene: sceneNode, levelMetadata: levelMetadata))

                self.sceneNode = sceneNode

                // Copy gameplay related content over to the scene
                sceneNode.entities = scene.entities
                sceneNode.graphs = scene.graphs

                // Set the scale mode to scale to fit the window
                sceneNode.scaleMode = .aspectFill

                // Present the scene
                if let view = self.view as! SKView? {
                    view.presentScene(sceneNode)

                    view.ignoresSiblingOrder = true

                    view.showsFPS = true
                    view.showsNodeCount = true
                }
            }
        }
    }

    func setupNotifications() {
        let notificationName = Notification.Name("LoadLevel")
        NotificationCenter.default.addObserver(self, selector: #selector(GameViewController.loadLevelFromNotification), name: notificationName, object: nil)

    }
}
