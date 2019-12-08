//
//  MenuController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/11/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit
import Preferences
import SwiftMoment
import SwiftyUserDefaults

extension PreferencePane.Identifier {
    static let calendar = Identifier("calendar")
    static let general = Identifier("general")
}

class MenuController: NSObject, NSMenuDelegate, CalendarViewDelegate {
    // MARK: Class members
    let appBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var calendarViewController: CalendarViewController?
    var highlightedEvent: EventMenuItemViewController?
    let eventItemSeperator = NSMenuItem.separator()
    var events: [EKEvent] = []
    let mainMenu = NSMenu()
    var menuIsOpen = false
    
    lazy var preferences: [PreferencePane] = [
        GeneralPreferencesController(),
        CalendarPreferencesController()
    ]

    lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: preferences,
        style: .toolbarItems,
        animated: true,
        hidesToolbarForSingleItem: true
    )

    var selectedTime: Moment {
        didSet {
            calendarViewController?.updateCalendar(currentTime: Clock.shared.currentTick, selectedTime: selectedTime)
            if EventStore.shared.isAuthorized {
                updateEventItems()
            }
        }
    }

    /**
     Event Items to display
     Add them to the 6th position in the menu
         
     - Returns: Nothing
     */
    var eventItems: [EventMenuItemViewController] = [] {
        didSet {
            oldValue.forEach { mainMenu.removeItem($0.menuItem) }
            if !eventItems.isEmpty && oldValue.isEmpty {
                mainMenu.insertItem(eventItemSeperator, at: 6)
            } else if eventItems.isEmpty && !oldValue.isEmpty {
                mainMenu.removeItem(eventItemSeperator)
            }

            eventItems.enumerated().forEach { mainMenu.insertItem($0.element.menuItem, at: 6 + $0.offset) }
        }
    }
    
    override init() {
        selectedTime = Clock.shared.currentTick

        super.init()

        setupAppMenu()                                  // Setup the menu for the app
        setupEvents()                                   // Setup Event Store
        
        appBarItem.button?.image = createMenuBarIcon()  // Calendar Icon w/ Day
        appBarItem.button?.target = self                // Make sure we recieve all actions
        appBarItem.menu = mainMenu                      // Attach the menu to the appBar

        Clock.shared.onChange(quantum: .minute) { [weak self] time in   // Let's check the calendar every minute ... low maintenance
            DispatchQueue.main.async {
                self?.updateMenuBar()
                self?.calendarViewController?.updateCalendar(currentTime: time, selectedTime: self!.selectedTime)
            }
        }
        
        /// Setup a call-forward listener for anyone to tell the controller that the color of the MenuBar item has changed
         NotificationCenter.default.addObserver(self, selector: #selector(menuBarColorUpdate(sender:)), name: NSNotification.Name(rawValue: "UpdateMenuBarColor"), object: nil)

        /// Setup a call-forward listener for anyone to tell the controller that the calanders to be displayed has changed
         NotificationCenter.default.addObserver(self, selector: #selector(displayCalendarUpdate(sender:)), name: NSNotification.Name(rawValue: "UpdateCalendarsToDisplay"), object: nil)
    }
    
    @objc func menuBarColorUpdate(sender: AnyObject) {
        updateMenuBar()
    }

    @objc func displayCalendarUpdate(sender: AnyObject) {
        setupEvents()
    }
    
    // MARK: IBActions from the Menu
    /**
     Display the abaout window
     
     - Parameters :
        - sender: The menuitem that sent message
     
     - Returns: Nothing
     */
    @IBAction func showAbout(_ sender: NSMenuItem) {
        print("Showing About")
    }

    /**
     Quit Kaendarium
     
     - Parameters :
        - sender: The menuitem that sent message
     
     - Returns: Nothing
     */
    @IBAction func showPreferences(_ sender: NSMenuItem) {
        print("Showing Preferences")
        preferencesWindowController.show(preferencePane: .general)
    }
    
    /**
     Quit Kaendarium
     
     - Parameters :
        - sender: The menuitem that sent message
     
     - Returns: Nothing
     */
    @IBAction func quitApp(_ sender: NSMenuItem) {
        print("Quitting Kalendarium")
        NSApplication.shared.terminate(self)
    }

    /**
     Setup the Event Store for displaying events

     - Parameters (none):
     
     - Returns: Nothing
     */
    func setupEvents() {
        EventStore.shared.requestAccessToEvents(callback: { [unowned self] isAuthorized, error in
            switch isAuthorized {
            case true:
                self.updateEventItems()
            case false:
                print(error!)
            }
        })
    }
    
    // MARK: Private methods
    /**
     Setup the menu that we will see (and use) once the user clicks the app icon.  The Menu will look like
        ===================
        -  About Kalendarium  -
        - -------------- -
        -      Preferences    -
        - -------------- -
        -    Calendar View    -
        - -------------- -
        -   Quit Kalendarium  -
        ===================
     
     - Parameters (none):
     
     - Returns: Nothing
     */
    private func setupAppMenu() {
        /// About Menu Item
        let aboutMenuItem = NSMenuItem(title: "About Kalendarium", action: #selector(showAbout), keyEquivalent: "")
        aboutMenuItem.target = self
        mainMenu.addItem(aboutMenuItem)
        /// About Menu Item

        /// Separator
        mainMenu.addItem(NSMenuItem.separator())
        /// Separator

        /// Preferences
        let prefMenuItem = NSMenuItem(title: "Preferences", action: #selector(showPreferences), keyEquivalent: "")
        prefMenuItem.target = self
        mainMenu.addItem(prefMenuItem)
        /// Preferences

        /// Separator
        mainMenu.addItem(NSMenuItem.separator())
        /// Separator

        /// Calendar View
        let calendarMenuItem = NSMenuItem()
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        calendarViewController = storyboard.instantiateController(withIdentifier: "CalendarViewController") as? CalendarViewController //CalendarViewController(delegate: self)
        calendarViewController?.delegate = self
        calendarMenuItem.view = calendarViewController?.view
        mainMenu.addItem(calendarMenuItem)
        /// Calendar View

        /// Separator
        mainMenu.addItem(NSMenuItem.separator())
        /// Separator

        /// Quit Menu Item
        let quitMenuItem = NSMenuItem(title: "Quit Kalendarium", action: #selector(quitApp), keyEquivalent: "")
        quitMenuItem.target = self
        mainMenu.addItem(quitMenuItem)
        /// Quit Menu Item
    }
    
    /**
     Create a new icon for display in the menubar; the base image is a simple image with a
     rectangle at the top (user configurable)
     
     - Parameters (none):
     
     - Returns: A properly formatted NSImage to be displayed in the menubar
     */
    private func createMenuBarIcon() -> NSImage? {
        let renderer = NSGraphicsImageRenderer(size: CGSize(width: 18, height: 18))
        let img = renderer.image { ctx in
            // Border
            ctx.setFillColor(NSColor.clear.cgColor)
            ctx.setStrokeColor(NSColor.white.cgColor)
            ctx.addRect(NSRect(x: 0, y: 0, width: 18, height: 18))
            ctx.drawPath(using: .fillStroke)
                        
            // Calendar Top
            ctx.setFillColor(Defaults.menuBarCalendarColor.cgColor)
            ctx.setStrokeColor(Defaults.menuBarCalendarColor.cgColor)
            ctx.addRect(CGRect(x: 0, y: 0, width: 18, height: 3))
            ctx.drawPath(using: .fillStroke)
        }
        
        return img.drawCenteredText(text: String(moment().day), size: 12, offset: 4)
    }
    
    /**
     Draw Text onta an Image
     
     - Parameters:
     - text: The text to display
     - image: The image to draw the text on
     
     - Returns: The original image with text superimposed in the center
     */
    private func drawTextOnImage(text: String, image: NSImage) -> NSImage? {
        let font = NSFont.systemFont(ofSize: 12)
        let imageRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        let textRect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height - 4)
        guard let textStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {return nil}
        
        textStyle.alignment = .center
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: NSColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        let im: NSImage = NSImage(size: image.size)
        let rep: NSBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(image.size.width),
                                                     pixelsHigh: Int(image.size.height), bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                                     colorSpaceName: NSColorSpaceName.calibratedRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        im.addRepresentation(rep)
        im.lockFocus()
        image.draw(in: imageRect)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        im.unlockFocus()
        
        return im
    }
        
    /**
     Update the menubar on the main queue
     
     - Parameters (None):
     
     - Returns: Nothing
     */
    private func updateMenuBar() {
        DispatchQueue.main.async { [weak self] in
            self?.appBarItem.button?.image = nil
            self?.appBarItem.button?.image = self?.createMenuBarIcon()
        }
    }
  
    /**
     Update event items
     
     - Parameters (None):
     
     - Returns: Nothing
     */
    private func updateEventItems() {
        events.removeAll()
        eventItems.removeAll()
        
        events = (EventStore.shared.getEventsForDay(endingAfter: selectedTime.startOf(.days), in: Defaults.calendarsToDisplay))
        
        if !events.isEmpty {
            DispatchQueue.main.async { [unowned self] in
                self.eventItems = self.events[...min(self.events.count - 1, 3)].map { event in
                    return EventMenuItemViewController(event: event)
                }
            }
        } else {
            eventItems.removeAll()
        }
    }
}

/**
 Let's handle the delegates here
 
 - Parameters (None):
 
 - Returns: Nothing
 */
extension MenuController {
    func calendarViewController(viewController: CalendarViewController, didRequestSelectedTime time: Moment) {
        selectedTime = time
        print("\(time) was selected")
    }
    
    func calendarViewController(viewController: CalendarViewController, didRequestMonthChange addMonths: Int) {
        let now = Clock.shared.currentTick
        let newMonth = moment([selectedTime.year, selectedTime.month + addMonths])!
        let isCurrentMonth = newMonth.isSameMonth(now)
        let newTime = isCurrentMonth ? moment([newMonth.year, newMonth.month, now.day])! : newMonth
        selectedTime = newTime
    }
    
    func calendarViewControllerDidRequestSelectedTimeToNow(viewController: CalendarViewController) {
        selectedTime = Clock.shared.currentTick
    }
        
    func menuWillOpen(_ menu: NSMenu) {
        menuIsOpen = true
        updateEventItems()
    }
    
    // After becoming unhighlighted, the text gets stuck kind of bold for some reason
    func menuDidClose(_ menu: NSMenu) {
        menuIsOpen = false
    }
    
    func menu(_ menu: NSMenu, willHighlight item: NSMenuItem?) {
        if let prevController = highlightedEvent {
            prevController.unhighlight()
        }
        if let controller = eventItems.first(where: { $0.menuItem == item }) {
            controller.highlight()
            highlightedEvent = controller
        }
    }
}
