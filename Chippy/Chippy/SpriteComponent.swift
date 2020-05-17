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

  let node: SKSpriteNode

  init(texture: SKTexture) {
    node = SKSpriteNode(texture: texture, color: .white, size: texture.size())
    super.init()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
