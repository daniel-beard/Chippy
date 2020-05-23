//
//  Tile2DArray.swift
//  Chippy
//
//  Created by Daniel Beard on 5/29/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class Tile2D {

    var gridSize: Int
    var matrix:[Tile?]

    init(size: Int, defaultValue:Tile?) {
        self.gridSize = size
        matrix = Array(repeating: defaultValue, count: size*size)
    }

    subscript(col:Int, row:Int) -> Tile? {
        get{
            return matrix[gridSize * row + col]
        }
        set{
            let value = newValue
            value?.position = Position(x: col, y: row)
            matrix[gridSize * row + col] = value
        }
    }

    func gridPosition(for index: Int) -> Position {
        Position(x: index / gridSize, y: index % gridSize)
    }

    func colCount() -> Int { gridSize }
    func rowCount() -> Int { gridSize }
}

