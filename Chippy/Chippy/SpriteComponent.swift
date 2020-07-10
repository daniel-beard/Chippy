//
//  SpriteComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

class SpriteComponent: GKComponent {

    var node: SKSpriteNode?
    private var initializedFromGKSKNodeComponent = false

    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }

    required init?(coder: NSCoder) {
        super.init()
    }

    override func didAddToEntity() {
        if node == nil, let spriteNodeFromEditor = entity?.component(ofType: GKSKNodeComponent.self)?.node as? SKSpriteNode {
            node = spriteNodeFromEditor
            initializedFromGKSKNodeComponent = true
        }
        if node == nil {
            fatalError("Could not find sprite node for component")
        }
    }

    // Only need to add to a scene if we set up this component in code.
    // Otherwise, spritekit handles this for us.
    func addToSceneIfRequired(scene: SKScene) {
        guard let node = node, initializedFromGKSKNodeComponent == true else { return }
        scene.addChild(node)
    }

    override class var supportsSecureCoding: Bool { true }

    func update(delta deltaTime: CFTimeInterval) {
        guard let zRotation = entity?.component(ofType: OrientationComponent.self)?.zRotation else { return }
        node?.zRotation = zRotation
    }
}
