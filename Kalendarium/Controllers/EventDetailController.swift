//
//  EventDetailController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit

class EventDetailController: NSViewController {
    @IBOutlet weak var eventTitle: NSTextField!
    @IBOutlet weak var eventFromTime: NSTextField!
    @IBOutlet weak var eventToTime: NSTextField!
    @IBOutlet weak var eventCalendar: NSPopUpButton!
    @IBOutlet weak var gridView: NSGridView!
    @IBOutlet weak var theView: EventDetailsView!
    
    let theEvent: EKEvent
    
    init(event: EKEvent) {
        theEvent = event
        super.init(nibName: "EventDetailController", bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear() {
        populateDetails()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.mergeCellsInRow(row: 0, startingColumn: 0, endingColumn: 1)
        setupCalendarSelector()
               
//        gridView.row(at: 5).isHidden = true
        preferredContentSize = gridView.fittingSize
    }
    
    override func viewDidAppear() {
//        gridView.row(at: 5).isHidden = true
        preferredContentSize = gridView.fittingSize
    }
    
    private func populateDetails() {
        let items = eventCalendar.itemArray
        if let menuItem = items.first(where: { ($0.representedObject as? String) == theEvent.calendar.calendarIdentifier}) {
            eventCalendar.select(menuItem)
        }
        
        eventFromTime.stringValue   = theEvent.startDate.time()
        eventToTime.stringValue     = theEvent.endDate.time()
        eventTitle.stringValue      = theEvent.title
    }
    
    private func setupCalendarSelector() {
        let sortedcalendars = EventStore.shared.getCalendars()?.sorted { $0.source.title.localizedCaseInsensitiveCompare($1.source.title) == ComparisonResult.orderedAscending }
        var formerSource = ""
        
        sortedcalendars?.forEach { calendar in
            if calendar.source.title != formerSource { // New Calendar Source + Calendar
                let item = NSMenuItem()
                item.title = calendar.source.title
                item.isEnabled = false
                item.representedObject = calendar.title
                eventCalendar.menu?.addItem(item)
                
                let item2 = NSMenuItem()
                item2.image = NSImage(withRadius: 10.0, color: calendar.color)
                item2.title = calendar.title
                item2.representedObject = calendar.calendarIdentifier
                eventCalendar.menu?.addItem(item2)
                
                formerSource = calendar.source.title
            } else { // Jusrt the Calendar
                let item = NSMenuItem()
                item.image = NSImage(withRadius: 10.0, color: calendar.color)
                item.title = calendar.title
                item.representedObject = calendar.calendarIdentifier
                eventCalendar.menu?.addItem(item)
                formerSource = calendar.source.title
            }
        }
    }
}
