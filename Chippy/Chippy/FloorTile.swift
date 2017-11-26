//
//  FloorTile.swift
//  Chippy
//
//  Created by Daniel Beard on 2/19/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class FloorTile: BaseTile, Passable {

    override func layer() -> TileLayer {
        return .one
    }

}
