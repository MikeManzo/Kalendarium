//
//  CalendarPreferencesController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/19/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import Preferences

class CalendarPreferencesController: NSViewController, PreferencePane {
    let preferencePaneIdentifier = PreferencePane.Identifier.calendar
    let toolbarItemIcon = NSImage(named: NSImage.advancedName)!
    let preferencePaneTitle = "Calendar"

    override var nibName: NSNib.Name? { "CalendarPreferencesController" }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = NSSize(width: 480, height: 272)
    }
}
