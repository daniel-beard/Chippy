//
//  ContactComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 7/3/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

// Each scene can have up to 32 category bitmasks
// Configure which categories it belongs to (category bitmasks)
// and which categories of bodies it should interact with (collision bitmasks)
// We don't really want "collisions"
// we want "constacts"
// https://developer.apple.com/documentation/spritekit/skphysicsbody/1519781-contacttestbitmask
// Tests category mask against contact mask

struct PhysicsCategory {
  static let None      : UInt32 = 0
  static let Monster   : UInt32 = 0b1       // 1
  static let Chippy    : UInt32 = 0b10      // 2
}

class ContactComponent: GKComponent {
    override class var supportsSecureCoding: Bool { true }
    var categoryBitmask: UInt32 = 0x00000001
    var contactBitmask: UInt32 = 0x00000001
    var physicsBody: SKPhysicsBody?

    func setupIfNeeded() {
        guard physicsBody == nil else { return }
        guard let sprite = entity?.component(ofType: SpriteComponent.self), let node = sprite.node else {
            fatalError("Contact component needs a sprite component to work")
        }
        let circleBody = SKPhysicsBody(circleOfRadius: max(node.size.width / 3, node.size.height / 3))
        circleBody.isDynamic = true

        switch node.name {
        case "Chippy":
            circleBody.categoryBitMask      = PhysicsCategory.Chippy
            circleBody.contactTestBitMask   = PhysicsCategory.Monster
        case "Bug":
            circleBody.categoryBitMask      = PhysicsCategory.Monster
            circleBody.contactTestBitMask   = PhysicsCategory.Chippy
        default:
            circleBody.categoryBitMask      = PhysicsCategory.None
            circleBody.contactTestBitMask   = PhysicsCategory.None
        }
        // This is so the nodes don't actually interact with each other
        // we just want contact notifications
        circleBody.collisionBitMask = 0
        circleBody.restitution = 0
        circleBody.mass = 0
        node.physicsBody = circleBody
        self.physicsBody = circleBody
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        setupIfNeeded()

        guard let contacts = physicsBody?.allContactedBodies() else { return }
        guard contacts.count > 0 else { return }

        // Monster and player collision
        // Single checks right now, if we want mixed: categoryBitMask & PhysicsCategory > 0 && ...
        if physicsBody?.categoryBitMask == PhysicsCategory.Monster &&
            contacts.any({ $0.categoryBitMask == PhysicsCategory.Chippy }) {
            NotificationCenter.gameNotification(name: Notification.Name("DisplayDied"), userInfo: [
                "message": "Oops! Bugs kill Chippy!"
            ])
        }
    }
}
