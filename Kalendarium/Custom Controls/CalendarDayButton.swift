//
//  CalendarDayButton.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

enum DayViewState {
    case normal
    case selected
    case today
    case outOfMonth
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
    
    override func viewDidChangeEffectiveAppearance() {
        // New CGColors need to be recalculated from NSColor
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
}
