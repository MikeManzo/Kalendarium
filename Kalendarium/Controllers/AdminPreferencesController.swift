//
//  AdminPreferencesController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 1/9/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Cocoa
import Preferences
import SwiftMoment
import QJColorChooser
import SwiftyUserDefaults

class AdminPreferencesController: NSViewController, PreferencePane {
    @IBOutlet weak var calendarPopup: MockCalendarPopup!

    let toolbarItemIcon             = NSImage(named: NSImage.cautionName)!
    let preferencePaneIdentifier    = PreferencePane.Identifier.admin
    let preferencePaneTitle         = "Admin"
    
    var originalOrigin              = NSPoint()
    var bOpen                       = false
    var originalHeight: CGFloat     = 0
    var calendarWindow: NSWindow?
    
    override var nibName: NSNib.Name? { "AdminPreferencesController" }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        view.wantsLayer = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferredContentSize    = NSSize(width: 480, height: 272)      // Set the size of our view
        originalOrigin          = calendarPopup.frame.origin
        originalHeight          = calendarPopup.frame.height
        calendarPopup.delegate  = self
        
        view.wantsLayer = true
        view.layer?.masksToBounds = false
    }
}

extension AdminPreferencesController: MockCalendarPopupDelegate {
    func calendarRowSelected(table: NSTableView) {

    }
}

/*    func calendarRowSelected(table: NSTableView) {
/*        var rect: NSRect
        let newHeight: CGFloat = 300.0

        if !bOpen {
            rect = NSRect(x: 0, y: (newHeight * -1) + originalHeight, width: 0, height: 0)
            rect = calendarPopup.convert(rect, to: nil)
            rect = calendarPopup.window?.convertToScreen(rect) ?? rect
            rect.size = NSSize(width: 250, height: newHeight)
            calendarWindow = NSWindow(contentRect: rect, styleMask: .borderless, backing: .buffered, defer: false)
            calendarWindow?.contentView = calendarPopup
            calendarWindow?.orderFront(nil)
            bOpen = true
        } else {
            view.addSubview(calendarPopup)
            calendarWindow?.close()
            calendarPopup.setFrameOrigin(NSPoint(x: 115, y: Int(originalOrigin.y)))
            calendarPopup.setFrameSize(NSSize(width: 250, height: originalHeight))
            calendarPopup.selectCalendar(row: table.selectedRow)
            bOpen = false
        }
*/
/*
        let newHeight: CGFloat = CGFloat(calendarPopup.numberOfRows) * CGFloat(17.0)
        
        if !bOpen {
            let newOrigin = NSPoint(x: 115, y: Int(originalOrigin.y) - Int((newHeight - originalHeight)))

            calendarPopup.setFrameOrigin(newOrigin)
            calendarPopup.setFrameSize(NSSize(width: 250, height: newHeight))
            bOpen = true
        } else {
            calendarPopup.setFrameOrigin(NSPoint(x: 115, y: Int(originalOrigin.y)))
            calendarPopup.setFrameSize(NSSize(width: 250, height: originalHeight))
            calendarPopup.selectCalendar(row: table.selectedRow)
            bOpen = false
        }
 */
*/
