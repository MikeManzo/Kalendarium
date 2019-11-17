//
//  Moment+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import SwiftMoment

extension Moment {
    func isSameMonth(_ moment: Moment) -> Bool {
        return (year, month) == (moment.year, moment.month)
    }
    func isSameDay(_ moment: Moment) -> Bool {
        return (year, month, day) == (moment.year, moment.month, moment.day)
    }
}
