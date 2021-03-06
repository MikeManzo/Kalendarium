//
//  EventDetailsView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/14/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

class EventDetailsView: NSView {
    override var acceptsFirstResponder: Bool { return true }
    override var canBecomeKeyView: Bool { return true }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        print("willOpenMenu")

    }
    
    override func viewDidMoveToWindow() {
        guard let theWindow = window else {
            return
        }
        theWindow.becomeKey()
    }    
}
