//
//  EventStore.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/15/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa
import EventKit
import SwiftMoment

protocol EventStoreDelegate: AnyObject {
    func receivedErrorRequestingAccessToEvents(error: Error)
    func wasDeniedAccessToEvents()
    func receivedAccessToEvents()
}

class EventStore: NSObject {
    private let backingStore = EKEventStore()
    weak var delegate: EventStoreDelegate?
    
    public var hasAccessToEvents: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    init(delegate: EventStoreDelegate) {
        self.delegate = delegate
    }
    
    public func requestAccessToEvents() {
        backingStore.requestAccess(to: .event) { [weak self] (isAuthorized, error) in
            if let error = error {
                self?.delegate?.receivedErrorRequestingAccessToEvents(error: error)
            } else if isAuthorized {
                self?.delegate?.receivedAccessToEvents()
            } else {
                self?.delegate?.wasDeniedAccessToEvents()
            }
        }
    }
    
    public func getEventsForDay(endingAfter: Moment, in calendars: [EKCalendar]? = nil) -> [EKEvent] {
        let calendars = calendars ?? backingStore.calendars(for: .event)
        let eod = moment([endingAfter.year, endingAfter.month, endingAfter.day + 1, 0, 0, -1])!
        let predicate = backingStore.predicateForEvents(withStart: endingAfter.date, end: eod.date, calendars: calendars)

        return backingStore.events(matching: predicate)
    }
}
