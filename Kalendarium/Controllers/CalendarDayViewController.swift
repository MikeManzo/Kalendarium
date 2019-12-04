//
//  CalendarDayViewController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import SwiftMoment

class CalendarDayViewController: NSViewController {
    public let inAdjacentMonth: Bool
    private let onClick: () -> Void
    static let margin = (8, 4)
    private let frame: NSRect
    public let day: Int

    private var dayView: CalendarDayButton? {
        guard let retView = view as? CalendarDayButton else {
            return nil
        }
        return retView
    }

    private var dayViewState: DayViewState {
        if isSelected {
            return .selected
        }
        if isToday {
            return .today
        }
        if inAdjacentMonth {
            return .outOfMonth
        }
        return .normal
    }
    
    public var isSelected: Bool = false {
        didSet {
            dayView?.viewState = dayViewState
        }
    }

    public var isToday: Bool = false {
        didSet {
            dayView?.viewState = dayViewState
        }
    }
    
    init(frame: NSRect, day: Int, isToday: Bool, inAdjacentMonth: Bool, onClick: @escaping () -> Void) {
        self.inAdjacentMonth = inAdjacentMonth
        self.onClick = onClick
        self.isToday = isToday
        self.frame = frame
        self.day = day
        
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = CalendarDayButton(string: "\(day)", state: dayViewState,
                                 frame: frame, target: self, action: #selector(runClickCallback))
    }
    
    @objc private func runClickCallback() {
        onClick()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
