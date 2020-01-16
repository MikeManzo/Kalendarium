//
//  CalendarPopUp.swift
//  Kalendarium
//
//  Created by Mike Manzo on 1/7/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Cocoa

class CalendarPopUp: NSPopUpButton {
    override var acceptsFirstResponder: Bool { return true }
    override var canBecomeKeyView: Bool { return true }
    override var needsPanelToBecomeKey: Bool {return true }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    override func mouseDown(with event: NSEvent) {
        NSMenu.popUpContextMenu(menu!, with: event, for: superview!)
        print("Mouse Down")
    }
    
    override func willOpenMenu(_ menu: NSMenu, with event: NSEvent) {
        print("willOpenMenu")
    }
}
