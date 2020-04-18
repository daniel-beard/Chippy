//
//  LevelRepository.swift
//  Chippy
//
//  Created by Daniel Beard on 2/25/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit



// A repository pattern is a container for singletons / configuration
// All level related / game related data is stored on this object after a level is loaded.
class LevelRepository {

    static let shared = LevelRepository()
    public private(set) var gameManager: GameManager?

    func setGameManager(_ gameManager: GameManager) {
        self.gameManager = gameManager
    }
}
