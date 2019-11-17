//
//  DesignFacts.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Foundation

protocol CommonDesignFacts {
    var menuMarginRight: CGFloat { get }
    var menuMarginLeft: CGFloat { get }
}

protocol CalendarDesignFacts {
    init(commonDesignFacts: CommonDesignFacts)
    var controlButtonMargin: CGFloat { get }
    var dayViewMargin: CGFloat { get }
    var dayViewSize: CGFloat { get }
}

protocol EventsDesignFacts {
    init(commonDesignFacts: CommonDesignFacts)
    var singleLineMenuItemHeight: CGFloat { get }
    var multiLineMenuItemHeight: CGFloat { get }
    var menuItemBulletMargin: CGFloat { get }
    var secondaryLabelHeight: CGFloat { get }
    var menuItemLineMargin: CGFloat { get }
    var primaryLabelHeight: CGFloat { get }
    var dotOffsetLeft: CGFloat { get }
    var dotSize: CGFloat { get }
}

class DesignFacts: NSObject {
    public let common: CommonDesignFacts
    public let calendar: CalendarDesignFacts
    public let events: EventsDesignFacts

    init(commonDesignFacts: CommonDesignFacts, calendarDesignFacts: CalendarDesignFacts, eventsDesignFacts: EventsDesignFacts) {
        common = commonDesignFacts
        calendar = calendarDesignFacts
        events = eventsDesignFacts
    }

    public static var defaultDesign: DesignFacts = {
        let commonDesignFacts = DefaultCommonDesignFacts()
        return DesignFacts(
            commonDesignFacts: commonDesignFacts,
            calendarDesignFacts: DefaultCalendarDesignFacts(commonDesignFacts: commonDesignFacts),
            eventsDesignFacts: DefaultEventsDesignFacts(commonDesignFacts: commonDesignFacts))
    }()
}

class DefaultCommonDesignFacts: NSObject, CommonDesignFacts {
    public let menuMarginRight: CGFloat = 16
    public let menuMarginLeft: CGFloat = 20
}

class DefaultCalendarDesignFacts: NSObject, CalendarDesignFacts {
    required init(commonDesignFacts: CommonDesignFacts) {
        super.init()
    }
    public let controlButtonMargin: CGFloat = 0
    public let dayViewSize: CGFloat = 24
    public let dayViewMargin: CGFloat = 4
}

class DefaultEventsDesignFacts: NSObject, EventsDesignFacts {
    required init(commonDesignFacts: CommonDesignFacts) {
        super.init()
    }
    public let singleLineMenuItemHeight: CGFloat = 19
    public let multiLineMenuItemHeight: CGFloat = 33
    public let secondaryLabelHeight: CGFloat = 14
    public let menuItemBulletMargin: CGFloat = 2
    public let primaryLabelHeight: CGFloat = 15
    public let menuItemLineMargin: CGFloat = 2
    public let dotOffsetLeft: CGFloat = 10
    public let dotSize: CGFloat = 4
}
