//
//  MovableBlock.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import CoreGraphics

class MovableBlock : BaseTile { //, ConditionallyMoveable {

//TODO: This whole class needs a cleanup

//    func canMoveConditionallyMoveableTile(gameManager: GameManager,
//                                          player: inout PlayerInfo,
//                                          currentPosition: CGPoint,
//                                          nextPosition: CGPoint) -> Bool {
//        // Get tile after this moveable block in the direction we want
//        let directionVector = CGPoint.directionVector(origin: currentPosition, next: nextPosition)
//        let blockNextPos = nextPosition + directionVector
//        let tileToMoveTo = gameManager.tileManager.backgroundTileAtPosition(x: Int(blockNextPos.x), y: Int(blockNextPos.y))
//
//        //TODO: This seems VERY hacky...
//        if tileToMoveTo != nil && tileToMoveTo is Passable {
//            return true
//        }
//        return false
//    }
//
//    func moveConditionallyMoveableTile(gameManager: GameManager, player: inout PlayerInfo, direction: MoveDirection) {
//        // Nothing for now.
//    }

}
