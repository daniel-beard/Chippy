//
//  FloorTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class FloorTile: BaseTile, Passable, MonsterPassable {
    override func layer() -> TileLayer { .one }
}
