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
    
    let menuItem: NSMenuItem
    let theEvent: EKEvent
    
    lazy var popover: NSPopover = {
        let popover = NSPopover()
        popover.behavior = .semitransient
        popover.contentViewController = EventDetailController(event: theEvent)
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
    }

    @objc private func viewInCalendar(_ sender: NSMenuItem) {
        if !NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency {                   // Check if transparency is allowed
            popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)      // Change the appearance and material for the selection of menu
        }
        
        popover.show(relativeTo: NSRect.zero, of: view, preferredEdge: NSRectEdge.minX)
    }
}

extension EventMenuItemViewController: NSPopoverDelegate {

}

/*
class EventMenuItemViewController: NSViewController {
    let design = DesignFacts.defaultDesign.events
    var locationLabel: NSTextField?
    let titleLabel: NSTextField
    var timeLabel: NSTextField?
    var separator: NSTextField?
    let menuItem: NSMenuItem
    let theEvent: EKEvent
    
    private var isMultiLine: Bool {
        return !theEvent.isAllDay || theEvent.location != nil
    }

    init(event: EKEvent) {
        theEvent = event
        menuItem = NSMenuItem(title: event.title, action: #selector(self.viewInCalendar(_:)), keyEquivalent: "")
        menuItem.isEnabled = true

        let paragraphStyle = NSMutableParagraphStyle()

        paragraphStyle.lineBreakMode = .byTruncatingTail
        let primaryAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13),
            .paragraphStyle: paragraphStyle
        ]

        let secondaryAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11),
            .foregroundColor: NSColor.secondaryLabelColor,
            .paragraphStyle: paragraphStyle
        ]

        titleLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.title, attributes: primaryAttributes))
        
        if !event.isAllDay {
            timeLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: event.startDate.time(), attributes: secondaryAttributes))
        }
        if !event.isAllDay && event.location != nil {
            separator = NSTextField(labelWithAttributedString: NSAttributedString(string: "･", attributes: secondaryAttributes))
        }
        if let location = event.location {
            locationLabel = NSTextField(labelWithAttributedString: NSAttributedString(string: location, attributes: secondaryAttributes))
        }
        
        super.init(nibName: nil, bundle: nil)
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

    override func loadView() {
        let height = isMultiLine ? design.multiLineMenuItemHeight : design.singleLineMenuItemHeight
        view = CustomMenuItemView(frame: NSRect(x: 0, y: 0, width: 240, height: height))
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        let marginLeft = DesignFacts.defaultDesign.common.menuMarginLeft
        let marginRight = DesignFacts.defaultDesign.common.menuMarginRight

        // Title
        setupTextField(titleLabel)
        titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: marginLeft).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -marginRight).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: design.menuItemLineMargin).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: design.primaryLabelHeight).isActive = true
        
        // Dot
        let dot = NSView()
        dot.translatesAutoresizingMaskIntoConstraints = false
        dot.wantsLayer = true
        dot.layer?.backgroundColor = theEvent.calendar.color.cgColor
        dot.layer?.cornerRadius = design.dotSize / 4
        view.addSubview(dot)
        dot.widthAnchor.constraint(equalToConstant: design.dotSize).isActive = true
        dot.heightAnchor.constraint(equalToConstant: design.dotSize).isActive = true
        dot.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        dot.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: design.dotOffsetLeft).isActive = true
        
        // Time
        if let timeLabel = timeLabel {
            let intrinsicWidth = ceil(timeLabel.attributedStringValue.boundingRect(with: view.frame.size, options: []).width)
            setupTextField(timeLabel)
            timeLabel.widthAnchor.constraint(equalToConstant: intrinsicWidth).isActive = true
            timeLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            timeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            timeLabel.heightAnchor.constraint(equalToConstant: design.secondaryLabelHeight).isActive = true
        }
        
        // Separator
        if let separator = separator {
            let intrinsicWidth = ceil(separator.attributedStringValue.boundingRect(with: view.frame.size, options: []).width)
            setupTextField(separator)
            separator.widthAnchor.constraint(equalToConstant: intrinsicWidth).isActive = true
            separator.leadingAnchor.constraint(equalTo: timeLabel!.trailingAnchor, constant: design.menuItemBulletMargin).isActive = true
            separator.heightAnchor.constraint(equalToConstant: design.secondaryLabelHeight).isActive = true
            separator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        }
        
        // Location
        if let locationLabel = locationLabel {
            setupTextField(locationLabel)
            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -marginRight).isActive = true
            if let separator = separator {
                locationLabel.leadingAnchor.constraint(equalTo: separator.trailingAnchor, constant: design.menuItemBulletMargin).isActive = true
            } else {
                locationLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor).isActive = true
            }
        }
    }
    
    private func setupTextField(_ textField: NSTextField) {
        textField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(textField)
        textField.isEditable = false
        textField.isBezeled = false
    }
    
    public func highlight() {
        print("Event Highlighted")
    }
    
    public func unhighlight() {
        print("Event Un-Highlighted")
    }
    
    @objc private func viewInCalendar(_ sender: NSMenuItem) {
        print("\(sender.title) was selected")
    }
}
*/
