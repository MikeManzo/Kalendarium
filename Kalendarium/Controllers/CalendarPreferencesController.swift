//
//  CalendarPreferencesController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/19/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit
import Preferences
import SwiftyUserDefaults

class CalendarPreferencesController: NSViewController, PreferencePane {
    @IBOutlet weak var calendarTable: NSTableView!
    
    let preferencePaneIdentifier = PreferencePane.Identifier.calendar
    let toolbarItemIcon = NSImage(named: NSImage.advancedName)!
    let preferencePaneTitle = "Calendar"

    override var nibName: NSNib.Name? { "CalendarPreferencesController" }
    var tableData = [Any]()

    override func viewDidLoad() {
        super.viewDidLoad()

        preferredContentSize = NSSize(width: 480, height: 272)
        setupCalendars()
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
            } else { // Jusrt the Calendar
                tableData.append(calendar)
                formerSource = calendar.source.title
            }
        }
    }
}

/**
Extensions to handle the table
*/
extension CalendarPreferencesController: NSTableViewDataSource, NSTableViewDelegate {
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
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "SourceView"), owner: self) as? CalendarSourceView
            if view != nil {
                let sourceName = tableData[row] as? String
                (view as? CalendarSourceView)?.name.stringValue = sourceName!
            } else {
                print("Error")
            }
        case is EKCalendar:
            view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CalendarView"), owner: self) as? CalendarDetailView
            if view != nil {
                let calendar = tableData[row] as? EKCalendar
                (view as? CalendarDetailView)?.color.image = NSImage(withRadius: 10.0, color: (calendar?.color)!)
                (view as? CalendarDetailView)?.name.stringValue = (calendar?.title)!
                (view as? CalendarDetailView)?.uuID = (calendar?.calendarIdentifier)!
                
                if Defaults.calendarsToDisplay.firstIndex(of: (calendar?.calendarIdentifier)!) != nil {
//                    print("Name:\((calendar?.title)!), Row: \(row), ID:\(calendar?.calendarIdentifier ?? "")!)")
                    (view as? CalendarDetailView)?.check.state = .on
                }
            } else {
                print("Error")
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

class CalendarSourceView: NSTableCellView {
    @IBOutlet weak var name: NSTextField!
}

class CalendarDetailView: NSTableCellView {
    @IBOutlet weak var check: NSButton!
    @IBOutlet weak var color: NSImageView!
    @IBOutlet weak var name: NSTextField!
    
    var uuID: String = ""
    
    @IBAction func calendarSelected(_ sender: NSButton) {
        switch sender.state {
        case .on:
            Defaults.calendarsToDisplay.append(uuID)
//            print("Added:\(uuID)")
        case .off:
            if let index = Defaults.calendarsToDisplay.firstIndex(of: uuID) {
                Defaults.calendarsToDisplay.remove(at: index)
//                print("Removed:\(uuID)")
            }
        case .mixed:
            break
        default:
            break
        }
    }
}
