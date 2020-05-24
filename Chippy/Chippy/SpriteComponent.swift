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

    var node: SKSpriteNode

    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
        super.init()
    }

    required init?(coder: NSCoder) { fatalError("No impl") }
    override class var supportsSecureCoding: Bool { true }
}
