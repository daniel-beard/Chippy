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
