//
//  BugMoveComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

class BugMoveComponent: GKAgent2D, GKAgentDelegate {

  let entityManager: EntityManager

  init(entityManager: EntityManager) {
    self.entityManager = entityManager
    super.init()
    delegate = self
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func agentWillUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }

    position = vector_float2(spriteComponent.node.position)
  }

  func agentDidUpdate(_ agent: GKAgent) {
    guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else {
      return
    }

    spriteComponent.node.position = CGPoint(position)
    spriteComponent.node.zRotation = CGFloat(self.rotation)

  }

//  func closestMoveComponent(for team: Team) -> GKAgent2D? {
//
//    var closestMoveComponent: MoveComponent? = nil
//    var closestDistance = CGFloat(0)
//
//    let enemyMoveComponents = entityManager.moveComponents(for: team)
//    for enemyMoveComponent in enemyMoveComponents {
//      let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
//      if closestMoveComponent == nil || distance < closestDistance {
//        closestMoveComponent = enemyMoveComponent
//        closestDistance = distance
//      }
//    }
//    return closestMoveComponent
//
//  }

  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)

    guard let entity = entity else { return }
    self.rotation += 0.01

//    guard let entity = entity,
//      let teamComponent = entity.component(ofType: TeamComponent.self) else {
//        return
//    }
//
//    guard let enemyMoveComponent = closestMoveComponent(for: teamComponent.team.oppositeTeam()) else {
//      return
//    }
//
//    let alliedMoveComponents = entityManager.moveComponents(for: teamComponent.team)
//
//    behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
  }
}
