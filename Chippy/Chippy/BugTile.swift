//
//  BugTile.swift
//  Chippy
//
//  Created by Daniel Beard on 5/16/20.
//  Copyright © 2020 DanielBeard. All rights reserved.
//

import Foundation

//TODO: Add behavior
class BugTile: BaseTile, Monster {
    override func layer() -> TileLayer { .three }
}
