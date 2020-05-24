//
//  Tile2DArray.swift
//  Chippy
//
//  Created by Daniel Beard on 5/29/17.
//  Copyright © 2017 DanielBeard. All rights reserved.
//

import Foundation

class Array2D<T> {

    var cols:Int, rows:Int
    var matrix:[T?]

    init(cols: Int, rows: Int, defaultValue:T?) {
        self.cols = cols
        self.rows = rows
        matrix = Array(repeating: defaultValue, count: cols*rows)
    }

    subscript(col:Int, row:Int) -> T? {
        get{
            return matrix[cols * row + col]
        }
        set{
            matrix[cols * row + col] = newValue
        }
    }

    subscript(col: Int32, row: Int32) -> T? {
        get{
            return matrix[cols * Int(row) + Int(col)]
        }
        set{
            matrix[cols * Int(row) + Int(col)] = newValue
        }
    }

    func colCount() -> Int { self.cols }
    func rowCount() -> Int { self.rows }
}

