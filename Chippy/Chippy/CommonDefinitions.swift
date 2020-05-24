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

    func toPos() -> GridPos {
        switch self {
        case .left:      return .left()
        case .right:     return .right()
        case .up:        return .up()
        case .down:      return .down()
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
        return GridPos(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    static func +(lhs: GridPos, rhs: MoveDirection) -> GridPos {
        lhs + rhs.toPos()
    }

    var description: String {
        return "(x: \(x) y: \(y))"
    }
}
