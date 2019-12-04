//
//  EventStore.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/15/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import EventKit
import SwiftMoment

class EventStore {
    public static var shared: EventStore = {
        return EventStore()
    }()

    private let backingStore = EKEventStore()
    
    public var isAuthorized: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
       
    public func requestAccessToEvents(callback: @escaping (_ response: Bool, _ error: Error?) -> Void) {
        let backingStore = EKEventStore()
        
        backingStore.requestAccess(to: .event) { (isAuthorized, error) in
            callback(isAuthorized, error)
            return
        }
    }

    public func getEventsForDay(endingAfter: Moment, in calendars: [EKCalendar]? = nil) -> [EKEvent] {
        let calendars = calendars ?? backingStore.calendars(for: .event)
        let eod = moment([endingAfter.year, endingAfter.month, endingAfter.day + 1, 0, 0, -1])!
        let predicate = backingStore.predicateForEvents(withStart: endingAfter.date, end: eod.date, calendars: calendars)

        return backingStore.events(matching: predicate)
    }
    
    public func getCalendars() -> [EKCalendar]? {
        if !isAuthorized {
            return nil
        }
        return backingStore.calendars(for: .event)
    }
}