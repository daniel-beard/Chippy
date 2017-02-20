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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load 'GameScene.sks' as a GKScene. This provides gameplay related content
        // including entities and graphs.
        if let scene = GKScene(fileNamed: "GameScene") {

            gameScene = scene

            // Get the SKScene from the loaded GKScene
            if let sceneNode = scene.rootNode as! GameScene? {

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
