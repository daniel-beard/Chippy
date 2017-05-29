//
//  MovableBlock.swift
//  Chippy
//
//  Created by Daniel Beard on 3/5/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class MovableBlock: BaseTile, ConditionallyMoveable {

    func canMoveConditionallyMoveableTile(gameManager: GameManager, player: inout PlayerInfo, direction: MoveDirection) -> Bool {
        return false
    }

    func moveConditionallyMoveableTile(gameManager: GameManager, player: inout PlayerInfo, direction: MoveDirection) {
        // Nothing for now.
    }

}
