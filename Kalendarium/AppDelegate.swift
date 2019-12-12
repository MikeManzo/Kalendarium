//
//  AppDelegate.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/9/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import SwiftyUserDefaults

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: IBOutlets
    
    // MARK: Class members
    var menuController: MenuController?
   
    // MARK: Compulsary Base Class Methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
//        printAllDefaults(message: "Launching")
        // Kick off all the things
        menuController = MenuController()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
//        printAllDefaults(message: "Exiting")
    }
    
    private func printAllDefaults(message: String) {
        print(message)
        print("Menu Bar Color:\(Defaults.menuBarCalendarColor)")
        print("Hover Highlight Color:\(Defaults.dayHoverHighlightColor)")
        print("Day Highlight Color:\(Defaults.dayHighlightColor)")
        print("Default Calendar:\(Defaults.defaultCalendar)")
        print("Calendars to display:\(Defaults.calendarsToDisplay)")
        print("Number of Events to Display:\(Defaults.eventDaysToDisplay)")
    }
}
