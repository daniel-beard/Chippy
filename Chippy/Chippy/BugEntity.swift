//
//  BugEntity.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

class BugEntity: GKEntity {

  init(entityManager: EntityManager) {
    super.init()
    let texture = SKTexture(imageNamed: "bug")
    let spriteComponent = SpriteComponent(texture: texture)
    addComponent(spriteComponent)
    addComponent(BugMoveComponent(entityManager: entityManager))
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
