//
//  ViewController.swift
//  ChippyMac
//
//  Created by Daniel Beard on 3/6/22.
//  Copyright © 2022 DanielBeard. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

//class ViewController: NSViewController {
//
//    @IBOutlet var skView: SKView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        if let view = self.skView {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                view.presentScene(scene)
//            }
//
//            view.ignoresSiblingOrder = true
//
//            view.showsFPS = true
//            view.showsNodeCount = true
//        }
//    }
//}

//
//  GameViewController.swift
//  Chippy
//
//  Created by Daniel Beard on 7/9/16.
//  Copyright © 2016 DanielBeard. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

//MARK: View Controller Lifecycle
class GameViewController: NSViewController {

    var gameScene: GKScene!
    var sceneNode: GameScene!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadLevel(levelNumber: 4)
    }
}

//MARK: Movement
internal extension GameViewController {
//    @objc func swipeUp() { sceneNode.move(direction: .up) }
//    @objc func swipeDown() { sceneNode.move(direction: .down) }
//    @objc func swipeLeft() { sceneNode.move(direction: .left) }
//    @objc func swipeRight() { sceneNode.move(direction: .right) }
//
//    override var keyCommands: [UIKeyCommand]? {
//        return [
//            // Movement
//            UIKeyCommand(input: UIKeyCommand.inputUpArrow,      modifierFlags: [], action: #selector(swipeUp)),
//            UIKeyCommand(input: UIKeyCommand.inputDownArrow,    modifierFlags: [], action: #selector(swipeDown)),
//            UIKeyCommand(input: UIKeyCommand.inputLeftArrow,    modifierFlags: [], action: #selector(swipeLeft)),
//            UIKeyCommand(input: UIKeyCommand.inputRightArrow,   modifierFlags: [], action: #selector(swipeRight)),
//            // Reload
//            UIKeyCommand(input: "r", modifierFlags: [], action: #selector(viewDidLoad))
//        ]
//    }
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
        let level = LevelLoader.levelMetadata(forLevelNumber: levelNumber)

        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "Level\(level.number)") {

            gameScene = scene

            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {

                // Create the game manager
                LevelRepository.shared.setGameManager(GameManager(scene: sceneNode, level: level))

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

