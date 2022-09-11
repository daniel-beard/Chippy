//
//  LevelTimer.swift
//  Chippy
//
//  Created by Daniel Beard on 8/6/22.
//  Copyright © 2022 DanielBeard. All rights reserved.
//

import Foundation

/// This is the countdown timer for each level
/// We don't handle the pausing here directly, it's handled via GameScene
class LevelTimer {

    let totalDuration: CFTimeInterval
    var durationRemaining: CFTimeInterval

    init(duration: Int) {
        totalDuration = CFTimeInterval(duration)
        durationRemaining = CFTimeInterval(duration)
    }

    func update(currTime: TimeInterval, delta deltaTime: CFTimeInterval) {
        durationRemaining -= deltaTime
        if durationRemaining <= 0 {
            gameNotif(name: .displayTimeUp, userInfo: ["message": "Oops! Ran out of time!"])
        }
    }

    func timeRemainingForDisplay() -> Int {
        Int(durationRemaining)
    }
}
