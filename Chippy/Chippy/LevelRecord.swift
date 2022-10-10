//
//  LevelRecord.swift
//  Chippy
//
//  Created by Daniel Beard on 8/7/22.
//  Copyright © 2022 DanielBeard. All rights reserved.
//

import Foundation

class LevelRecord {

    /**
     Saves, if the elapsed time is a record for the given level
     @param levelNumber - Current level number
     @param elapsedTime - Time taken to complete the level
     @returns Text to display in the final alert popup
     */
    class func saveRecord(for levelNumber: Int, elapsedTime: Int) -> String {
        let currRecord = currentRecord(for: levelNumber)
        let isRecord = storeIfRecord(for: levelNumber, elapsedTime: elapsedTime)
        //TODODB: Implement
        return ""
    }

    // MARK: Private

    private class func isLevelRecord(for levelNumber: Int, elapsedTime: Int) -> Bool {
        let val = currentRecord(for: levelNumber)
        // Unset previously
        if val == 0 { return true }
        return elapsedTime < val
    }

    private class func currentRecord(for levelNumber: Int) -> Int {
        UserDefaults.standard.integer(forKey: "level-\(levelNumber)")
    }

    // Returns bool indicating if it's a record
    private class func storeIfRecord(for levelNumber: Int, elapsedTime: Int) -> Bool {
        guard isLevelRecord(for: levelNumber, elapsedTime: elapsedTime) else { return false }
        UserDefaults.standard.setValue(elapsedTime, forKey: "level-\(levelNumber)")
        return true
    }

}
