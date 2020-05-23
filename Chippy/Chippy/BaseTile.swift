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
    // Tile identifier
    var uuid: UUID
    // Don't update manually, this is set via Tile2D
    var position: Position = Position(x: 0, y: 0)

    func layer() -> TileLayer {
        fatalError("Subclasses MUST override")
    }

    required init(_ name: String) {
        self.name = name
        self.uuid = UUID()
    }
}
