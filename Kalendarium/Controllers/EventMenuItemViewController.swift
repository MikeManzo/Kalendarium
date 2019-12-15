//
//  EventMenuItemViewController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/16/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit

class EventMenuItemViewController: NSViewController {
    @IBOutlet weak var eventColor: NSImageView!
    @IBOutlet weak var eventTitle: NSTextField!
    @IBOutlet weak var eventTimeRange: NSTextField!
    @IBOutlet weak var disclosure: NSButton!
    @IBOutlet weak var theView: CustomMenuItemView!
    
    let menuItem: NSMenuItem
    let theEvent: EKEvent
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.contentViewController = EventDetailController(event: theEvent)
        popover.behavior = .applicationDefined
        popover.animates = true
        popover.delegate = self
        return popover
    }()
    
    init(event: EKEvent) {
        theEvent = event
        menuItem = NSMenuItem(title: event.title, action: #selector(self.viewInCalendar(_:)), keyEquivalent: "")
        menuItem.isEnabled = true
       
        super.init(nibName: "EventItemController", bundle: nil)
        menuItem.view = view
        menuItem.target = self
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)

        let menuIndex = (menuItem.menu?.index(of: menuItem))!
        menuItem.menu?.performActionForItem(at: menuIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventColor.image            = NSImage(withRadius: 6.0, color: theEvent.calendar.color)
        eventTimeRange.stringValue  = "\(theEvent.startDate.time()) - \(theEvent.endDate.time())"
        eventTitle.stringValue      = theEvent.title
        disclosure.isHidden         = true
        theView.delegate            = self
    }
    
    override func viewWillAppear() {
        fillDetails()
    }
    
    private func fillDetails() {
        
    }

    @objc private func viewInCalendar(_ sender: NSMenuItem) {
        if !NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency {           // Check if transparency is allowed
            popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)     // Change the appearance and material for the selection of menu
        }
        
        popover.show(relativeTo: NSRect.zero, of: view, preferredEdge: NSRectEdge.minX)

    }
    
    @IBAction func editEventDetails(_ sender: NSButton) {
        let index = (menuItem.menu?.index(of: menuItem))!
        
        guard (menuItem.menu?.item(at: index + 1)!.view as? EventDetailsView) != nil else {
            let vc = EventDetailController(event: theEvent)
            let newItem = NSMenuItem()
            newItem.view = vc.view
            menuItem.menu?.insertItem(newItem, at: index + 1)
            print(index+1)

            return
        }
        guard let vcMenu = menuItem.menu?.item(at: index + 1) else { return }
        menuItem.menu?.removeItem(vcMenu)
    }
}

extension EventMenuItemViewController: CustomMenuItemDelegate {
    @objc func itemEntered() {
        disclosure.isHidden = false
    }

    @objc func itemExited() {
        disclosure.isHidden = true
    }
}

extension EventMenuItemViewController: NSPopoverDelegate {

}
