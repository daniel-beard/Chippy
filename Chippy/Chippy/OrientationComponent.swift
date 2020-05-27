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


/// The different directions that an animated character can be facing.
@objc enum CompassDirection: Int {
    case north = 0
    case west = 1
    case south = 2
    case east = 3

    /// Convenience array of all available directions.
    static let allDirections: [CompassDirection] = [ .east, .north, .west, .south ]

    /// The angle of rotation that the orientation represents.
    var zRotation: CGFloat {
        // Calculate the number of radians between each direction.
        let stepSize = CGFloat(.pi * 2.0) / CGFloat(CompassDirection.allDirections.count)
        return CGFloat(self.rawValue) * stepSize
    }

    /// Creates a new `FacingDirection` for a given `zRotation` in radians.
    init(zRotation: CGFloat) {
        let twoPi = .pi * 2.0

        // Normalize the node's rotation.
        let rotation = (Double(zRotation) + twoPi).truncatingRemainder(dividingBy: twoPi)

        // Convert the rotation of the node to a percentage of a circle.
        let orientation = rotation / twoPi

        // Scale the percentage to a value between 0 and 3.
        let rawFacingValue = round(orientation * 3.0).truncatingRemainder(dividingBy: 3.0)

        // Select the appropriate `CompassDirection` based on its members' raw values
        self = CompassDirection(rawValue: Int(rawFacingValue))!
    }

    init(string: String) {
        switch string.lowercased() {
            case "north": self = .north
            case "east":  self = .east
            case "south": self = .south
            case "west":  self = .west
            default:
                fatalError("Unknown or unsupported string - \(string)")
        }
    }
}
