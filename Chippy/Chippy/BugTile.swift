//
//  BugTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/16/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation


class BugTile: BaseTile, Monster {
    override func layer() -> TileLayer { .three }

    private var timeSincelastUpdate = TimeInterval()
    private let pathfindStep: TimeInterval = 4.3

    func update(delta: TimeInterval, gameManager: GameManager) {
        guard timeSincelastUpdate + delta > pathfindStep else {
            timeSincelastUpdate += delta
            return
        }

        //TODO: Implement proper pathfinding here.
        //TODO: Need to be able to rotate the sprite based on conditions + direction
        gameManager.tileManager.removeTile(at: self.position, layer: self.layer())
    }
}
