//
//  DayMenuItemController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/10/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

class DayMenuItemController: NSViewController {
    @IBOutlet weak var dayLabel: NSTextField!
    
    let menuItem: NSMenuItem
    
    init(title: String) {
        menuItem = NSMenuItem(title: title, action: #selector(self.viewInCalendar(_:)), keyEquivalent: "")
        menuItem.isEnabled = false
        
        super.init(nibName: "DayMenuItemController", bundle: nil)
        menuItem.view = view
        menuItem.target = self
    }
/*
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
    }
    
    override func mouseUp(with event: NSEvent) {
        super.mouseUp(with: event)
        
        let menuIndex = (menuItem.menu?.index(of: menuItem))!
        menuItem.menu?.performActionForItem(at: menuIndex)
    }
*/
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dayLabel.stringValue = menuItem.title
    }
    
    @objc private func viewInCalendar(_ sender: NSMenuItem) {
        print("\(sender.title) was selected")
    }
}

extension DayMenuItemController: NSMenuDelegate, NSMenuItemValidation {
    @objc func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        return false
    }
}
