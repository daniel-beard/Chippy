//
//  GreenClosedGateTile.swift
//  Chippy
//
//  Created by Daniel Beard on 3/6/22.
//  Copyright © 2022 DanielBeard. All rights reserved.
//

import Foundation

class GreenClosedGateTile: BaseTile, GreenChannelReactive {

    override func layer() -> TileLayer { .two }
    lazy var channel = userData?["userData"] as? Int ?? 1

    func channelToggleFired(channel: Int, gameManager: GameManager, tilePos: GridPos) {
        guard channel == self.channel else { return }
        switch self.channel {
            case 1: gameManager.tiles.add(.greenopengatech1, at: tilePos, userData: self.userData)
            case 2: gameManager.tiles.add(.greenopengatech2, at: tilePos, userData: self.userData)
            case 3: gameManager.tiles.add(.greenopengatech3, at: tilePos, userData: self.userData)
            default:
                fatalError("Unknown channel")
        }
    }
}
