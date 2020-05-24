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

//MARK: View Controller Lifecycle
class GameViewController: UIViewController {

    var gameScene: GKScene!
    var sceneNode: GameScene!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel(levelNumber: 2)
    }

    override var shouldAutorotate: Bool { false }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask { .all }
    override var prefersStatusBarHidden: Bool { true }
}

//MARK: Movement
internal extension GameViewController {
    @objc func swipeUp() { sceneNode.move(direction: .up) }
    @objc func swipeDown() { sceneNode.move(direction: .down) }
    @objc func swipeLeft() { sceneNode.move(direction: .left) }
    @objc func swipeRight() { sceneNode.move(direction: .right) }

    override var keyCommands: [UIKeyCommand]? {
        return [
            // Movement
            UIKeyCommand(input: UIKeyCommand.inputUpArrow,      modifierFlags: [], action: #selector(swipeUp)),
            UIKeyCommand(input: UIKeyCommand.inputDownArrow,    modifierFlags: [], action: #selector(swipeDown)),
            UIKeyCommand(input: UIKeyCommand.inputLeftArrow,    modifierFlags: [], action: #selector(swipeLeft)),
            UIKeyCommand(input: UIKeyCommand.inputRightArrow,   modifierFlags: [], action: #selector(swipeRight)),
            // Reload
            UIKeyCommand(input: "r", modifierFlags: [], action: #selector(viewDidLoad))
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
                LevelRepository.shared.setGameManager(GameManager(scene: sceneNode, levelMetadata: levelMetadata))

                self.sceneNode = sceneNode

                // Copy gameplay related content over to the scene
                sceneNode.gameScene = scene
//                sceneNode.entities = scene.entities
//                sceneNode.graphs = scene.graphs

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
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameViewController.loadLevelFromNotification),
                                               name: notificationName,
                                               object: nil)

    }
}
