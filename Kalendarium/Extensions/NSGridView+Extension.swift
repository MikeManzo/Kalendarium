//
//  NSGridView+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/15/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

// [Merge Rows](https://stackoverflow.com/questions/47026703/how-to-span-columns-in-nsgridview-or-nstableview#)
extension NSGridView {
    func mergeCellsInColumn(column: Int, startingRow: Int, endingRow: Int) {
        self.mergeCells(inHorizontalRange: NSRange(location: column, length: 1),
                        verticalRange: NSRange(location: startingRow, length: endingRow - startingRow + 1))
    }

    func mergeCellsInRow(row: Int, startingColumn: Int, endingColumn: Int) {
        self.mergeCells(inHorizontalRange: NSRange(location: startingColumn, length: endingColumn - startingColumn + 1),
                        verticalRange: NSRange(location: row, length: 1))
    }
}
