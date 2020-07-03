//
//  OrientationComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 5/25/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit
import CoreGraphics

class OrientationComponent: GKComponent {

    // MARK: Properties
    override class var supportsSecureCoding: Bool { true }

    var zRotation: CGFloat = 0.0 {
        didSet {
            let twoPi = CGFloat(.pi * 2.0)
            zRotation = (zRotation + twoPi).truncatingRemainder(dividingBy: twoPi)
        }
    }

    var compassDirection: CompassDirection? {
        didSet { zRotation = compassDirection?.zRotation ?? 0 }
    }

    // Used for enabling direction to be set from scene editor
    @GKInspectable var direction: NSString = "north" {
        didSet { switch direction.lowercased {
            case "north":   compassDirection = .north
            case "east":    compassDirection = .east
            case "south":   compassDirection = .south
            case "west":    compassDirection = .west
            default: fatalError("Unsupported case")
        }}
    }

    override func didAddToEntity() {
        guard let _ = entity?.component(ofType: SpriteComponent.self) else {
            fatalError("OrientationComponent needs a sprite component to work")
        }
    }

    override func update(deltaTime seconds: TimeInterval) {
        super.update(deltaTime: seconds)
        guard let spriteComponent = entity?.component(ofType: SpriteComponent.self) else { return }
        spriteComponent.node?.zRotation = zRotation
    }
}
