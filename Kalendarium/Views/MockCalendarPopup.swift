//
//  MockCalendarPopup.swift
//  Kalendarium
//
//  Created by Mike Manzo on 1/8/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit
import Preferences
import SwiftyUserDefaults

protocol MockCalendarPopupDelegate: class {
    func calendarRowSelected(table: NSTableView)
}

class MockCalendarPopup: XibView {
    @IBOutlet weak var calendarTable: NSTableView!
    @IBOutlet weak var calendarName: NSTextField!
    @IBOutlet weak var calendarColor: NSImageView!
    @IBOutlet var calendarPopupWindow: NSWindow!
    
    weak var delegate: MockCalendarPopupDelegate?
    var originalHeight: CGFloat = 0
    var originalOrigin = NSPoint()
    var calendarOpen = false
    var tableData = [Any]()

    var numberOfRows: Int {
        return tableData.count
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableData.removeAll()                                           // Start fresh (likely not needed)
        setupCalendars()                                                // Setup the control & fill w/ calendars
        calendarTable.action = #selector(onTableItemClicked(sender:))   // Callback for the table click
        originalHeight       = self.frame.height
        originalOrigin       = self.frame.origin
    }
    
    /**
    Give the user the "current" calendar.  Make it look like what a 'static' NSPopupButton woudl look like
      
     - Parameter calendar: the calendar to display
     
     - Returns: nothing
    */
    private func currentCalendar(calendar: EKCalendar) {
        calendarColor.image = NSImage(withRadius: 10.0, color: (calendar.color)!)
        calendarName.stringValue = calendar.title
    }
    
    func selectCalendar(row: Int) {
        currentCalendar(calendar: (tableData[row] as? EKCalendar)!)
    }
    
    /**
    Setup the data source for the table.  We want an array that has two types, String and EKCalendar.
    We can then use the object type to format the table row
      
     - Returns: nothing
    */
    private func setupCalendars() {
        let sortedcalendars = EventStore.shared.getCalendars()?.sorted { $0.source.title.localizedCaseInsensitiveCompare($1.source.title) == ComparisonResult.orderedAscending }
        var formerSource = ""
        
        sortedcalendars?.forEach { calendar in
            if calendar.source.title != formerSource { // New Calendar Source + Calendar
                tableData.append(calendar.source?.title as Any)
                tableData.append(calendar)
                formerSource = calendar.source.title
            } else { // Just the Calendar
                tableData.append(calendar)
                formerSource = calendar.source.title
            }
        }
        calendarTable.reloadData()
    }
    
    /**
    Toggle the widow that holds the calendar list
     
     - Parameter show: True for showing the window; false for closing it
      
     - Returns: nothing
    */
    private func toggleCalendarPopup(_ show: Bool) {
        var rect: NSRect
        let newHeight: CGFloat = 300.0

        if show {
            rect = NSRect(x: 0, y: (newHeight * -1) + originalHeight, width: 0, height: 0)
            rect = self.convert(rect, to: nil)
            rect = self.window?.convertToScreen(rect) ?? rect
            rect.size = NSSize(width: 250, height: newHeight)
            calendarPopupWindow.setFrame(rect, display: true)
            calendarPopupWindow?.makeKeyAndOrderFront(nil)
            calendarOpen = true
        } else {
            calendarPopupWindow.orderOut(nil)
            currentCalendar(calendar: (tableData[calendarTable.selectedRow] as? EKCalendar)!)
            calendarOpen = false
        }
    }
    
    /**
    Toggle the widow that holds the calendar list
     
     - Parameter event: We want to intercept the mouse down event to see if we are over the lable.  If so,
        fake it, and make it feel like a click.
      
     - Returns: nothing
    */
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        
        if calendarName.frame.contains(convert(event.locationInWindow, from: nil)) {
            toggleCalendarPopup(!calendarOpen)
        }
    }
    
    /**
     The user has clicked somewhere on the tableView.  Let's take a look at where and determe what action we need to take
     
     - Parameter sender: the TableView that sent the message
      
     - Returns: nothing
    */
    @objc func onTableItemClicked(sender: AnyObject) {
        if delegate != nil {
            guard let theTable = sender as? NSTableView else { return }
            
            switch tableData[theTable.clickedRow] {
            case is String:     // Eat it - it's not a 'valid' click
                break
            case is EKCalendar: // Pass along a click event for the parent to adjudicate
                toggleCalendarPopup(!calendarOpen)
                delegate?.calendarRowSelected(table: theTable)
            default:
                print("Error: Unknown View")
            }
        }
    }
    
    @IBAction func calendarDisclosureClicked(_ sender: Any) {
        toggleCalendarPopup(true)
    }
    
    @IBAction func calendarSelected(_ sender: NSTableView) {
    }
}

/**
Extensions to handle the table
*/
extension MockCalendarPopup: NSTableViewDataSource, NSTableViewDelegate {
    /**
    Returns the number of rows that shoudl be displayed by the table
    
     - Parameter tableView: the TableView in question
    
     - Returns: the number of rows to display
    */
    func numberOfRows(in tableView: NSTableView) -> Int {
        return tableData.count
    }
    
    /**
    TableView override to format the contents of our cutom row (Note the custom AttributionTableCellView class)
    
    - Parameters:
     - tableView: the TableView in-question
     - tableColumn: the column to format (we only have one)
     - row: the row to format
    
     - Returns: the fully formatted view (AttributionTableCellView in our case)
     */
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var view: NSTableCellView?
  
        switch tableData[row] {
        case is String:
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PopupSourceView"), owner: self) as? PopupCalendarSourceView
            if view != nil {
                let sourceName = tableData[row] as? String
                (view as? PopupCalendarSourceView)?.name.stringValue = sourceName!
            } else {
                print("Error")
            }
        case is EKCalendar:
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "PopupCalendarView"), owner: self) as? PopupCalendarDetailView
            if view != nil {
                let calendar = tableData[row] as? EKCalendar
                (view as? PopupCalendarDetailView)?.color.image = NSImage(withRadius: 10.0, color: (calendar?.color)!)
                (view as? PopupCalendarDetailView)?.name.stringValue = (calendar?.title)!
                (view as? PopupCalendarDetailView)?.uuID = (calendar?.calendarIdentifier)!
            } else {
                print("Error: Unable to show Calendar Table View")
            }
        default:
            print("Error: Unknown View")
        }
        
        return view
    }
    
    /**
     Programatcially enable and disable selectable rows

     - Parameters:
      - tableView: the TableView in-question
      - row: the row to format
     
      - Returns: bool whether to enable or diable the row for selection
     */
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        var selectable = true
        
        switch tableData[row] {
        case is String:
            selectable = false
        case is EKCalendar:
            selectable = true
        default:
            selectable = false
        }
        
        return selectable
    }
}

class PopupCalendarSourceView: NSTableCellView {
    @IBOutlet weak var name: NSTextField!
}

class PopupCalendarDetailView: NSTableCellView {
    @IBOutlet weak var color: NSImageView!
    @IBOutlet weak var name: NSTextField!
    
    var uuID: String = ""
}
