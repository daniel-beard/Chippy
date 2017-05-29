//
//  CommonDefinitions.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

enum MoveDirection {
    case left
    case right
    case up
    case down
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

    var description: String {
        return "(x: \(x) y: \(y))"
    }
}

