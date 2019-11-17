//
//  VibrantView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

class VibrantView: NSView {
    public var vibrant = true

    override var allowsVibrancy: Bool {
        return vibrant
    }
}
