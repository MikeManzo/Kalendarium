//
//  CalendarViewController.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/11/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import SwiftMoment

protocol CalendarViewDelegate: AnyObject {
    func calendarViewController(viewController: CalendarViewController, didRequestSelectedTime time: Moment)
    func calendarViewController(viewController: CalendarViewController, didRequestMonthChange addMonths: Int)
    func calendarViewControllerDidRequestSelectedTimeToNow(viewController: CalendarViewController)
}

class CalendarViewController: NSViewController {
    // MARK: Class Outlets
    @IBOutlet weak var monthLabel: NSTextField!
    @IBOutlet weak var calendarInset: NSView!
    @IBOutlet weak var headerView: NSView!
    
    // MARK: Class members
    let controlButtonMargin = DesignFacts.defaultDesign.calendar.controlButtonMargin
    let dayViewMargin = DesignFacts.defaultDesign.calendar.dayViewMargin
    let dayViewSize = DesignFacts.defaultDesign.calendar.dayViewSize
    var dayViewControllers: [CalendarDayViewController] = []
    var calendarHeightConstraint: NSLayoutConstraint?
    weak var _delegate: CalendarViewDelegate?

    weak var delegate: CalendarViewDelegate? {
        get {
            return _delegate
        }
        set {
            _delegate = newValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCalendarInset()
        
        let now = Clock.shared.currentTick
        updateCalendar(currentTime: now, selectedTime: now)
    }
          
    init(delegate: CalendarViewDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupCalendarInset() {
        calendarHeightConstraint = calendarInset.heightAnchor.constraint(equalToConstant: 0)
        calendarInset.widthAnchor.constraint(equalToConstant: 7 * (dayViewSize + dayViewMargin) - dayViewMargin).isActive = true
        let widthConstraint = view.widthAnchor.constraint(equalTo: calendarInset.widthAnchor, constant: dayViewMargin * 2)
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        let monthControlsContainer = NSView()
        let prevButton = MonthControlButton(imageName: "arrowLeft", target: self, action: #selector(self.goToPreviousMonth))
        let todayButton = MonthControlButton(imageName: "dot", target: self, action: #selector(self.goToToday))
        let nextButton = MonthControlButton(imageName: "arrowRight", target: self, action: #selector(self.goToNextMonth))

        monthControlsContainer.translatesAutoresizingMaskIntoConstraints = false
        monthControlsContainer.subviews = [prevButton, todayButton, nextButton]
        headerView.addSubview(monthControlsContainer)
        nextButton.trailingAnchor.constraint(equalTo: monthControlsContainer.trailingAnchor).isActive = true
        todayButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        prevButton.trailingAnchor.constraint(equalTo: todayButton.leadingAnchor, constant: -controlButtonMargin).isActive = true
        monthControlsContainer.subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.centerYAnchor.constraint(equalTo: monthControlsContainer.centerYAnchor).isActive = true
        }
        monthControlsContainer.heightAnchor.constraint(equalTo: headerView.heightAnchor).isActive = true
        monthControlsContainer.widthAnchor.constraint(equalToConstant: prevButton.frame.width + nextButton.frame.width + todayButton.frame.width + 2 * controlButtonMargin).isActive = true
        monthControlsContainer.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        monthControlsContainer.trailingAnchor.constraint(equalTo: headerView.trailingAnchor).isActive = true
    }
    
    @objc func goToToday() {
        delegate?.calendarViewControllerDidRequestSelectedTimeToNow(viewController: self)
    }
    
    @objc func goToPreviousMonth() {
        delegate?.calendarViewController(viewController: self, didRequestMonthChange: -1)
    }
    
    @objc func goToNextMonth() {
        delegate?.calendarViewController(viewController: self, didRequestMonthChange: 1)
    }

    func updateCalendar(currentTime: Moment, selectedTime: Moment) {
        let weeks = CalendarGrid.getWeeks(month: selectedTime.month, year: selectedTime.year)

        dayViewControllers.forEach {
            $0.view.viewWillMove(toSuperview: nil)
            $0.view.removeFromSuperview()
            $0.removeFromParent()
        }

        dayViewControllers.removeAll()
//        dayViewControllers = []
        
        monthLabel.stringValue = weeks[1][0].monthName
        if weeks[1][0].year != currentTime.year {
            monthLabel.stringValue += " \(weeks[1][0].year)"
        }

        weeks.enumerated().forEach { [weak self] week in
            week.element.enumerated().forEach { [weak self] day in
                let vc = CalendarDayViewController(
                    frame: NSRect( x: CGFloat(day.offset) * (dayViewSize + dayViewMargin),
                                   y: CGFloat(weeks.count - 1 - week.offset) * (dayViewSize + dayViewMargin),
                                   width: dayViewSize, height: dayViewSize),
                    day: day.element.day,
                    isToday: day.element.isSameDay(currentTime),
                    inAdjacentMonth: !day.element.isSameMonth(selectedTime),
                    onClick: { [unowned self] in
                        self!.delegate?.calendarViewController(viewController: self!, didRequestSelectedTime: day.element)
                    }
                )
                vc.isSelected = day.element.isSameDay(selectedTime)
                addChild(vc)
                calendarInset.addSubview(vc.view)
                dayViewControllers.append(vc)
            }
        }

        let calendarHeight = CGFloat(weeks.count) * (dayViewSize + dayViewMargin) - dayViewMargin
        calendarHeightConstraint!.constant = calendarHeight
        calendarHeightConstraint!.isActive = true

        view.layoutSubtreeIfNeeded()
    }
    
    private func getDayViewController(forDay day: Int) -> CalendarDayViewController? {
        return dayViewControllers.first { !$0.inAdjacentMonth && $0.day == day }
    }
    
    private func updateSelectedDay(prevDay: Moment, nextDay: Moment) {
        getDayViewController(forDay: prevDay.day)?.isSelected = false
        getDayViewController(forDay: nextDay.day)?.isSelected = true
    }
    
    private func updateCurrentDay(prevDay: Moment, nextDay: Moment) {
        getDayViewController(forDay: prevDay.day)?.isToday = false
        getDayViewController(forDay: nextDay.day)?.isToday = true
    }
}
