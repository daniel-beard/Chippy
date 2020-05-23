//
//  BugEntity.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

class BugEntity: GKEntity, Tile, Monster {

    required init(name: String, entityManager: EntityManager) {
        super.init()
        let texture = SKTexture(imageNamed: "bug")
        let spriteComponent = SpriteComponent(texture: texture)
        addComponent(spriteComponent)
        addComponent(BugMoveComponent(entityManager: entityManager))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    //MARK: Tile conformance
    func layer() -> TileLayer { .three }
    var name: String = "bug"
}
