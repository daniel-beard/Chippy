//
//  BaseTickableComponent.swift
//  Chippy
//
//  Created by Daniel Beard on 7/9/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation
import GameplayKit

/// Base class for GKAgent2D agents. Override tickDuration to a value in seconds.
/// tick() is called every tickDuration
class BaseAgent2D: GKAgent2D {
    var tickDuration: TimeInterval? { 0.5 }
    var lastMoveTime: TimeInterval?

    func tick() {} // nothing, override in subclass

    override func update(deltaTime seconds: TimeInterval) {
        guard let tickDuration = tickDuration else { super.update(deltaTime: seconds); return }
        guard let lastMoveTime = lastMoveTime else { self.lastMoveTime = nowTime(); return }
        let now = nowTime()
        if now > lastMoveTime + tickDuration {
            tick()
            self.lastMoveTime = now
        }
    }
}

/// Base class for GKComponent components. Override tickDuration to a value in seconds.
/// tick() is called every tickDuration
class BaseComponent: GKComponent {
    var tickDuration: TimeInterval?
    var lastMoveTime: TimeInterval?

    required init?(coder: NSCoder) { super.init(coder: coder) }

    func tick() {} // nothing, override in subclass

    override func update(deltaTime seconds: TimeInterval) {
        guard let tickDuration = tickDuration else { super.update(deltaTime: seconds); return }
        guard let lastMoveTime = lastMoveTime else { self.lastMoveTime = nowTime(); return }
        let now = nowTime()
        if now > lastMoveTime + tickDuration {
            tick()
            self.lastMoveTime = now
        }
    }
}
