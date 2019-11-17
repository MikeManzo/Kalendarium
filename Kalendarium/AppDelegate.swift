//
//  AppDelegate.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/9/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    // MARK: IBOutlets
    
    // MARK: Class members
    var menuController: MenuController?
   
    // MARK: Compulsary Base Class Methods
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Kick off all the things
        menuController = MenuController()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
    }
}
