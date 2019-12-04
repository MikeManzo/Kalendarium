//
//  GeneralPreferencesController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/19/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import Preferences
import SwiftMoment
import QJColorChooser
import SwiftyUserDefaults

class GeneralPreferencesController: NSViewController, QJColorButtonDelegate, PreferencePane {
    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = "General"
    
    @IBOutlet weak var calendarIcon: NSImageView!
    @IBOutlet weak var calendarColorView: QJColorChooser!
    @IBOutlet weak var calendarList: NSPopUpButton!
    
    override var nibName: NSNib.Name? { "GeneralPreferencesController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = NSSize(width: 480, height: 272)      // Set the size of our view
        
        calendarColorView.selectedMenuItemColor = Defaults.menuBarCalendarColor
        calendarColorView.selectedMenuItemTextColor = NSColor.black
        calendarColorView.selectedBoxColor = Defaults.menuBarCalendarColor
        calendarColorView.color = Defaults.menuBarCalendarColor
        calendarColorView.boxBorderColor = NSColor.black
        calendarColorView.borderRadius = 1
        calendarColorView.darkMode = true
        calendarColorView.delegate = self
        calendarColorView.boxWidth = 30

        calendarIcon.image = createMenuBarIcon()

        let item = NSMenuItem()
        item.title = "Calendar A"
        item.isEnabled = false
        calendarList.menu?.addItem(item)
        
        let item2 = NSMenuItem()
        item2.image = NSImage(withRadius: 10.0, color: .blue)
        item2.title = "Chris"
        calendarList.menu?.addItem(item2)

        let item3 = NSMenuItem()
        item3.image = NSImage(withRadius: 10.0, color: .green)
        item3.title = "Mike"
        calendarList.menu?.addItem(item3)

        let item4 = NSMenuItem.separator()
        calendarList.menu?.addItem(item4)

        let item5 = NSMenuItem()
        item5.title = "Calendar B"
        item5.isEnabled = false
        calendarList.menu?.addItem(item5)
        
        let item6 = NSMenuItem()
        item6.image = NSImage(withRadius: 10.0, color: .purple)
        item6.title = "Chris"
        calendarList.menu?.addItem(item6)

        let item7 = NSMenuItem()
        item7.image = NSImage(withRadius: 10.0, color: .orange)
        item7.title = "Mike"
        calendarList.menu?.addItem(item7)
        
        calendarList.select(item2)
    }
    
    /**
     Create a new icon for display in the menubar; the base image is a simple image with a
     rectangle at the top (user configurable)
     
     - Parameters (none):
     
     - Returns: A properly formatted NSImage to be displayed in the menubar
     */
    private func createMenuBarIcon() -> NSImage? {
        let renderer = NSGraphicsImageRenderer(size: CGSize(width: 32, height: 32))
        let img = renderer.image { ctx in
            // Border
            ctx.setFillColor(NSColor.clear.cgColor)
            ctx.setStrokeColor(NSColor.white.cgColor)
            ctx.addRect(NSRect(x: 0, y: 0, width: 32, height: 32))
            ctx.drawPath(using: .fillStroke)
            
            // Calendar Top
            ctx.setFillColor(Defaults.menuBarCalendarColor.cgColor)
            ctx.setStrokeColor(Defaults.menuBarCalendarColor.cgColor)
            ctx.addRect(CGRect(x: 0, y: 0, width: 32, height: 8))
            ctx.drawPath(using: .fillStroke)
        }
        
        return img.drawCenteredText(text: String(moment().day), size: 18, offset: 10)
    }
}

extension GeneralPreferencesController {
    func colorSelected(_ sender: QJColorChooser, color: NSColor) {
        Defaults.menuBarCalendarColor = color
        calendarIcon.image = createMenuBarIcon()
    }
}
