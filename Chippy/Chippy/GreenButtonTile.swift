//
//  GreenButtonTile.swift
//  Chippy
//
//  Created by Daniel Beard on 3/6/22.
//  Copyright © 2022 DanielBeard. All rights reserved.
//

import Foundation

class GreenButtonTile: BaseTile, Passable, GreenChannelTriggering {
    override func layer() -> TileLayer { .two }
    lazy var channel = userData?["channel"] as? Int ?? 1
}
