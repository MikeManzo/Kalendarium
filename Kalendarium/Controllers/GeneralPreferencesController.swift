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
    @IBOutlet weak var calendarIcon: NSImageView!
    @IBOutlet weak var calendarColorView: QJColorChooser!
    @IBOutlet weak var calendarList: NSPopUpButton!

    let toolbarItemIcon = NSImage(named: NSImage.preferencesGeneralName)!
    let preferencePaneIdentifier = PreferencePane.Identifier.general
    let preferencePaneTitle = "General"
    
    override var nibName: NSNib.Name? { "GeneralPreferencesController" }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize = NSSize(width: 480, height: 272)      // Set the size of our view
        calendarIcon.image = createMenuBarIcon()

        setupCalendarColorView()
        setupCalendarSelector()
        
        let items = calendarList.itemArray
        if let menuItem = items.first(where: { ($0.representedObject as? String) == Defaults.defaultCalendar }) {
            calendarList.select(menuItem)
        }
    }

    /**
     Setup the color selector for the calandar icon in the menubar
     
     - Parameters (none):
     
     - Returns: None
     */
    private func setupCalendarColorView() {
        calendarColorView.selectedMenuItemColor = Defaults.menuBarCalendarColor
        calendarColorView.selectedMenuItemTextColor = NSColor.black
        calendarColorView.selectedBoxColor = Defaults.menuBarCalendarColor
        calendarColorView.color = Defaults.menuBarCalendarColor
        calendarColorView.boxBorderColor = NSColor.black
        calendarColorView.borderRadius = 1
        calendarColorView.darkMode = true
        calendarColorView.delegate = self
        calendarColorView.boxWidth = 30
    }
    
    @IBAction func defaultCalendarChanged(_ sender: NSPopUpButton) {
        guard let uuID = sender.selectedItem?.representedObject as? String else {
            return
        }
        Defaults.defaultCalendar = uuID
    }
    
    /**
     Load the calendars into the calendar list; sorting alphabetically first
     Caledar source first, then actuall calendar
     
     - Parameters (none):
     
     - Returns: None
     */
    private func setupCalendarSelector() {
        let sortedcalendars = EventStore.shared.getCalendars()?.sorted { $0.source.title.localizedCaseInsensitiveCompare($1.source.title) == ComparisonResult.orderedAscending }
        var formerSource = ""
        
        sortedcalendars?.forEach { calendar in
            if calendar.source.title != formerSource { // New Calendar Source + Calendar
                let item = NSMenuItem()
                item.title = calendar.source.title
                item.isEnabled = false
                item.representedObject = calendar.title
                calendarList.menu?.addItem(item)
                
                let item2 = NSMenuItem()
                item2.image = NSImage(withRadius: 10.0, color: calendar.color)
                item2.title = calendar.title
                item2.representedObject = calendar.calendarIdentifier
                calendarList.menu?.addItem(item2)
                
                formerSource = calendar.source.title
            } else { // Jusrt the Calendar
                let item = NSMenuItem()
                item.image = NSImage(withRadius: 10.0, color: calendar.color)
                item.title = calendar.title
                item.representedObject = calendar.calendarIdentifier
                calendarList.menu?.addItem(item)
                formerSource = calendar.source.title
            }
        }
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
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateMenuBarColor"), object: nil, userInfo: nil)
    }
}
