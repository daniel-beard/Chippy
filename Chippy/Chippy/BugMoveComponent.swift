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

    override init() {
        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init()
        setup()
    }
    override class var supportsSecureCoding: Bool { true }

    func setup() {
        delegate = self
    }

    override func didAddToEntity() {
        // if we have a sprite node, set our position for the first update.
        if let sprite = entity?.component(ofType: GKSKNodeComponent.self) {
            position = vector_float2(sprite.node.position)
        }
    }

    func agentWillUpdate(_ agent: GKAgent) {
        // nothing
    }

  func agentDidUpdate(_ agent: GKAgent) {
    // Update default GKSKNodeComponent if we have one
    if let spriteComponent = entity?.component(ofType: GKSKNodeComponent.self) {
        spriteComponent.node.position = CGPoint(position)
    }
  }

  //TODO: Remove these, just to test out movement quickly
  var lastMoveTime: CFTimeInterval? = nil

  override func update(deltaTime seconds: TimeInterval) {
    super.update(deltaTime: seconds)
    guard let lastMoveTime = lastMoveTime else { self.lastMoveTime = Date.timeIntervalSinceReferenceDate as Double; return }
    let now = Date.timeIntervalSinceReferenceDate as Double
    let moveEvery: TimeInterval = 1.0

    guard let entity = entity else { return }
    guard let tiles = GM()?.tiles else { return }

    guard let spriteNode = entity.component(ofType: SpriteComponent.self)?.node else { return }

    // Position in tile grid
    if now > lastMoveTime + moveEvery {
        var gridPos = tiles.gridPosition(forPoint: spriteNode.position)
        gridPos = gridPos + .right()

        guard tiles.at(pos: gridPos).all({ $0 is MonsterPassable }) else { return }

        position = vector_float2(tiles.centerOfTile(at: gridPos))
        self.lastMoveTime = Date.timeIntervalSinceReferenceDate as Double
    }
  }
}
