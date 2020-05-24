//
//  EntityManager.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {

  var entities = Set<GKEntity>()
  let scene: SKScene

  lazy var componentSystems: [GKComponentSystem] = {
    let bugMoveComponent = GKComponentSystem(componentClass: BugMoveComponent.self)
    return [bugMoveComponent]
  }()

  var toRemove = Set<GKEntity>()

  init(scene: SKScene) {
    self.scene = scene
  }

  func add(_ entity: GKEntity) {
    entities.insert(entity)

    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      scene.addChild(spriteNode)
    }

    for componentSystem in componentSystems {
      componentSystem.addComponent(foundIn: entity)
    }
  }

  func remove(_ entity: GKEntity) {
    if let spriteNode = entity.component(ofType: SpriteComponent.self)?.node {
      spriteNode.removeFromParent()
    }

    entities.remove(entity)
    toRemove.insert(entity)
  }

  func update(_ deltaTime: CFTimeInterval) {
    for componentSystem in componentSystems {
      componentSystem.update(deltaTime: deltaTime)
    }

    for currentRemove in toRemove {
      for componentSystem in componentSystems {
        componentSystem.removeComponent(foundIn: currentRemove)
      }
    }
    toRemove.removeAll()
  }
}

