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
    var menuBarCalendarColor: DefaultsKey<NSColor> { return .init("Defaults", defaultValue: NSColor.red) }
    var dayHoverHighlightColor: DefaultsKey<NSColor> { return .init("Defaults", defaultValue: NSColor.blue) }
    var dayHighlightColor: DefaultsKey<NSColor> { return .init("Defaults", defaultValue: .accent) }
}
