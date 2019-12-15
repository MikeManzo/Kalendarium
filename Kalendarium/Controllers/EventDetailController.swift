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
        eventTitle.stringValue = theEvent.title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gridView.wantsLayer = true
        gridView.layer?.backgroundColor = NSColor.red.cgColor
        gridView.mergeCellsInRow(row: 0, startingColumn: 0, endingColumn: 1)
               
        preferredContentSize = NSSize(width: 253, height: 190)
    }
    
    override func viewDidAppear() {
        gridView.row(at: 5).isHidden = true
    }
}
