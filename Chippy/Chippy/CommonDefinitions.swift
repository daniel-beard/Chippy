//
//  CommonDefinitions.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

let ninetyDegreesInRadians: CGFloat = .pi / 2.0

/// The different directions that an animated character can be facing.
@objc enum CompassDirection: Int, CaseIterable, CustomDebugStringConvertible {
    case north = 0
    case west
    case south
    case east

    /// The angle of rotation that the orientation represents.
    var zRotation: CGFloat {
        // Calculate the number of radians between each direction.
        let stepSize = CGFloat(.pi * 2.0) / CGFloat(Self.allCases.count)
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

    var debugDescription: String {
        switch self {
        case .north:    return "north"
        case .east:     return "east"
        case .south:    return "south"
        case .west:     return "west"
        }
    }
}

enum GridDirection: Int, CaseIterable {
    case up = 0
    case right
    case down
    case left

    func toPos() -> GridPos {
        switch self {
            case .left:      return .left()
            case .right:     return .right()
            case .up:        return .up()
            case .down:      return .down()
        }
    }

    func reverse() -> GridDirection {
        switch self {
            case .up:       return .down
            case .left:     return .right
            case .down:     return .up
            case .right:    return .left
        }
    }
}

enum GameState {
    case inProgress
    case failed
    case completed
}

// MARK: Points and vectors
extension vector_float2 {
  init(_ point: CGPoint) {
    self.init(x: Float(point.x), y: Float(point.y))
  }
}

extension CGPoint {
    init(_ point: vector_float2) {
      self.init()
      self.x = CGFloat(point.x)
      self.y = CGFloat(point.y)
    }

    static func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        return CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}

enum RelativeDirection: Int, CaseIterable {
    case forward = 0
    case right
    case back
    case left

    // Let's us use cool stuff like .forward.from(.east, gridPos).toPos()
    func from(_ compass: CompassDirection) -> GridDirection {
        switch (self, compass) {
        case (.forward, .north):    return .up
        case (.forward, .east):     return .right
        case (.forward, .south):    return .down
        case (.forward, .west):     return .left
        case (.back,    .north):    return .down
        case (.back,    .east):     return .left
        case (.back,    .south):    return .up
        case (.back,    .west):     return .right
        case (.right,   .north):    return .right
        case (.right,   .east):     return .down
        case (.right,   .south):    return .left
        case (.right,   .west):     return .up
        case (.left,    .north):    return .left
        case (.left,    .east):     return .up
        case (.left,    .south):    return .right
        case (.left,    .west):     return .down
        }
    }
}

// Used for tile indicies and directions
typealias GridPos = vector_int2
extension vector_int2 {
    static func left()  -> GridPos { GridPos(x: -1, y:  0) }
    static func right() -> GridPos { GridPos(x:  1, y:  0) }
    static func up()    -> GridPos { GridPos(x:  0, y:  1) }
    static func down()  -> GridPos { GridPos(x:  0, y: -1) }
    static func zero()  -> GridPos { GridPos(x:  0, y:  0) }

    init(x: Int, y: Int) {
        self.init()
        self.x = Int32(x)
        self.y = Int32(y)
    }

    static func +(lhs: GridPos, rhs: GridPos) -> GridPos {
        GridPos(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: GridPos, rhs: GridDirection) -> GridPos {
        lhs + rhs.toPos()
    }

    var description: String { "(x: \(x) y: \(y))" }
    var debugDescription: String { description }
}

// MARK: Notifications

extension Notification.Name {
    static let loadLevel            = Notification.Name("LoadLevel")
    static let displayHelp          = Notification.Name("DisplayHelp")
    static let displayEndGameLabel  = Notification.Name("DisplayEndGameLabel")
    static let displayDied          = Notification.Name("DisplayDied")
    static let displayTimeUp        = Notification.Name("DisplayTimeUp")
    static let updatePlayerUI       = Notification.Name("UpdatePlayerUI")
}
