//
//  CommonDefinitions.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

enum MoveDirection {
    case left
    case right
    case up
    case down
}

func offset(position: Position, byDirection direction: MoveDirection) -> Position {
    let offset: (dx: Int, dy: Int)
    switch direction {
        case .left: offset = (-1, 0)
        case .right: offset = (1, 0)
        case .up: offset = (0, 1)
        case .down: offset = (0, -1)
    }
    return position + Position(x: offset.dx, y: offset.dy)
}

enum GameState {
    case inProgress
    case failed
    case completed
}

// Represents a tile index position. E.g. 16,16 
// Do not use for absolute sprite positions
struct Position: CustomStringConvertible {
    var x: Int
    var y: Int

    static func +(lhs: Position, rhs: Position) -> Position {
        return Position(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: Position, rhs: MoveDirection) -> Position {
        return offset(position:lhs, byDirection:rhs)
    }

    var description: String {
        return "(x: \(x) y: \(y))"
    }
}

