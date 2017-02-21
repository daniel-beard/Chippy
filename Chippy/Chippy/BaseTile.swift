//
//  BaseTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/20/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

// base class for all tiles, implements the Tile protocol only
class BaseTile: Tile {
    // This value is set to the name of the TileSet tile. E.g. redkey, Floor, etc.
    var name: String = ""

    required init(_ name: String) {
        self.name = name
    }
}
