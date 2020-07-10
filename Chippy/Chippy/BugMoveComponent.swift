//
//  BugMoveComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 5/17/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import SpriteKit
import GameplayKit

class BugMoveComponent: BaseAgent2D, GKAgentDelegate {

    // Store last position, we'll use this for calculating the orientation.
    var lastPosition: GridPos?

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

    func nextPositionAndOrientation(fromCurrentPos currentPos: GridPos) -> GridPos? {
        guard let tiles = GM()?.tiles else { return nil }
        guard let compass = entity?.component(ofType: OrientationComponent.self)?.compassDirection else { return nil }

        // Consider all tiles around us. We want to follow the wall.
        // lookup left value
        let relativeLeftTilePos = currentPos + RelativeDirection.left.from(compass).toPos()
        let relativeForwardTilePos = currentPos + RelativeDirection.forward.from(compass).toPos()
        let relativeRightTilePos = currentPos + RelativeDirection.right.from(compass).toPos()
        let leftTileOccupied = tiles.at(pos: relativeLeftTilePos).all { !($0 is MonsterPassable) }
        let forwardTileOccupied = tiles.at(pos: relativeForwardTilePos).all { !($0 is MonsterPassable) }
        let rightTileOccupied = tiles.at(pos: relativeRightTilePos).all { !($0 is MonsterPassable) }

        //TODO: Figure out the correct rules for this.

        // now need to figure out "left" from position + orientation
        // - if left is occupied, and forward free continue in current direction
        if leftTileOccupied && !forwardTileOccupied {
            return relativeForwardTilePos
        }
        // - if left is empty, turn and move in that direction
        else if !leftTileOccupied {
            return relativeLeftTilePos
        }
        else if leftTileOccupied && forwardTileOccupied && !rightTileOccupied {
            return relativeRightTilePos
        }
        return nil
    }

    // Rotates the sprite to the right compass direction
    func orient(currentPos: GridPos, nextPos: GridPos) {
        guard let orientation = entity?.component(ofType: OrientationComponent.self) else { return }
        let compassDirection: CompassDirection
        let delta = GridPos(x: nextPos.x - currentPos.x, y: nextPos.y - currentPos.y)
        switch delta {
            case .right():  compassDirection = .east
            case .left():   compassDirection = .west
            case .up():     compassDirection = .north
            case .down():   compassDirection = .south
            default: return
        }
        orientation.compassDirection = compassDirection
    }

    override var tickDuration: TimeInterval? { 0.5 }
    override func tick() {
        guard let entity = self.entity else { return }
        guard let tiles = GM()?.tiles else { return }
        guard let spriteNode = entity.component(ofType: SpriteComponent.self)?.node else { return }

        // Position in tile grid
        let currentPosition = tiles.gridPosition(forPoint: spriteNode.position)
        let nextPos = self.nextPositionAndOrientation(fromCurrentPos: currentPosition)

        // Position change
        if let nextPos = nextPos {
            position = vector_float2(tiles.centerOfTile(at: nextPos))
            spriteNode.position = CGPoint(position)

            // Orient the sprite based on last position
            orient(currentPos: currentPosition, nextPos: nextPos)
        }
        // Update last position if we moved or change orientation
        lastPosition = currentPosition
    }
}
