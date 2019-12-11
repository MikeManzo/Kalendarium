//
//  NSDate+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/16/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Foundation

class DateFormatters {
    public let dayOfWeek = DateFormatter()
    public let fullDayOfWeek = DateFormatter()
    public let time = DateFormatter()
    public let date = DateFormatter()

    init() {
        dayOfWeek.setLocalizedDateFormatFromTemplate("E")
        fullDayOfWeek.setLocalizedDateFormatFromTemplate("EEEE")
        time.dateStyle = .none
        time.timeStyle = .short
        date.dateStyle = .full
        date.timeStyle = .none
    }
    
    public static var shared: DateFormatters = {
        return DateFormatters()
    }()
}

extension Date {
    static func dayOfWeekAndTime() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        let dayOfWeek = DateFormatters.shared.dayOfWeek.string(from: date)
        let time = DateFormatters.shared.time.string(from: date)
        return "\(dayOfWeek) \(time)"
    }
    
    static func fullDate() -> String {
        let date = Date(timeIntervalSinceNow: 0)
        return DateFormatters.shared.date.string(from: date)
    }
    
    func dayOfTheWeek() -> String {
        return "\(DateFormatters.shared.dayOfWeek.string(from: self))"
    }

    func fullDayOfTheWeek() -> String {
        return "\(DateFormatters.shared.fullDayOfWeek.string(from: self))"
    }
    
    func day() -> Int {
        return Calendar.current.dateComponents([.day], from: self).day!
    }

    func month() -> Int {
        return Calendar.current.dateComponents([.day], from: self).month!
    }

    func year() -> Int {
        return Calendar.current.dateComponents([.day], from: self).year!
    }
    
    func time() -> String {
        return DateFormatters.shared.time.string(from: self)
    }
    
    func isToday() -> Bool {
        let calendar = Calendar.current
        
        return calendar.isDateInToday(self)
    }
}
