//
//  CalendarDayButton.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

enum DayViewState {
    case outOfMonth
    case selected
    case normal
    case today
    case hover
}

class CalendarDayButton: NSButton {
    private let label: String

    override var allowsVibrancy: Bool {
        return viewState != .selected
    }

    public var viewState: DayViewState {
        didSet {
            refreshAppearance()
        }
    }

    init(string: String, state: DayViewState, frame: NSRect, target: AnyObject, action: Selector) {
        label = string
        viewState = state
        super.init(frame: frame)
        
        (cell as? NSButtonCell)?.highlightsBy = .contentsCellMask
        sendAction(on: .leftMouseDown)
        isBordered = false
        wantsLayer = true
        layer?.cornerRadius = frame.width / 2
        self.target = target
        self.action = action
        
        refreshAppearance()
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // CGColors need to be recalculated from NSColor
    override func viewDidChangeEffectiveAppearance() {
        refreshAppearance()
    }

    func refreshAppearance() {
        switch viewState {
        case .selected:
            layer?.backgroundColor = NSColor.accent.cgColor
            attributedTitle = getStringWithColor(string: label, color: .primaryTextInvert)
        case .today:
            layer?.backgroundColor = NSColor.highlightBackground.cgColor
            attributedTitle = getStringWithColor(string: label, color: .highlightForeground)
        case .outOfMonth:
            layer?.backgroundColor = NSColor.clear.cgColor
            attributedTitle = getStringWithColor(string: label, color: .disabledText)
        case .hover:
            layer?.backgroundColor = NSColor.dayHoverHighlight.cgColor
            attributedTitle = getStringWithColor(string: label, color: .primaryTextInvert)
        default:
            layer?.backgroundColor = NSColor.clear.cgColor
            attributedTitle = getStringWithColor(string: label, color: .primaryText)
        }
    }
    
    private func getStringWithColor(string: String, color: NSColor) -> NSAttributedString {
        return NSAttributedString(string: string, attributes: [
            .kern: -0.15,
            .foregroundColor: color
        ])
    }
    
    // By default, every menu item has its superview as NSVisualEffectView
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)

        if viewState != .selected { // Preserve the "selected" state
            viewState = .hover
        }
    }
    
    // While exiting from the view, It will make NSVisualEffectView as default.
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        if viewState != .selected { // Preserve the "selected" state
            viewState = .normal
        }
    }

    // Adding Tracking area to track mouse movements on view.
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()

        let trackingArea = NSTrackingArea(rect: bounds,
                                          options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeInActiveApp],
                                          owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
}
