//
//  Defaults.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/4/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import AppKit
import SwiftyUserDefaults

extension DefaultsKeys {
    var menuBarCalendarColor: DefaultsKey<NSColor> { return .init("menuBarCalendarColor", defaultValue: NSColor.red) }
    var dayHoverHighlightColor: DefaultsKey<NSColor> { return .init("dayHoverHighlightColor", defaultValue: NSColor.blue) }
    var dayHighlightColor: DefaultsKey<NSColor> { return .init("dayHighlightColor", defaultValue: .accent) }
    var defaultCalendar: DefaultsKey<String> { return .init("defaultCalendar", defaultValue: "") }
    var calendarsToDisplay: DefaultsKey<[String]> { return .init("calendarsToDisplay", defaultValue: []) }
    var eventDaysToDisplay: DefaultsKey<Int> { return .init("eventDaysToDisplay", defaultValue: 5) }
}
