//
//  Clock.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/12/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Foundation
import SwiftMoment

typealias ClockHandler = (_ time: Moment) -> Void

enum ClockQuantum {
    case minute
    case day
    case month
}

class Handlers {
    var minute = [UInt: ClockHandler]()
    var month = [UInt: ClockHandler]()
    var day = [UInt: ClockHandler]()
    private var idCounter: UInt = 0

    func pushHandler(quantum: ClockQuantum, handler: @escaping ClockHandler) {
        let id = idCounter
        idCounter += 1
        switch quantum {
        case .minute:
            insert(dict: &minute, key: id, value: handler)
        case .day:
            insert(dict: &day, key: id, value: handler)
        case .month:
            insert(dict: &month, key: id, value: handler)
        }
    }
    
    private func insert(dict: inout [UInt: ClockHandler], key: UInt, value: @escaping ClockHandler) {
        dict[key] = value
    }
}

class Clock: NSObject {
    public static var shared: Clock = {
        return Clock()
    }()

    private let queue = DispatchQueue(label: "com.quantumjoker.kalendarium.queues.clock", qos: .userInteractive)
    private let timer: DispatchSourceTimer
    private var handlers = Handlers()
    public var currentTick = moment()

    private override init() {
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: queue)
        super.init()

        let now = Date(timeIntervalSinceNow: 0).timeIntervalSince1970
        let usecondsToNextMinute = DispatchTimeInterval.microseconds(Int((60 - now.truncatingRemainder(dividingBy: 60)) * 1e6))
        timer.schedule(wallDeadline: .now() + usecondsToNextMinute, repeating: 60, leeway: .microseconds(0))
        timer.setEventHandler { [weak self] in
            self?.runHandlers()
        }
        timer.resume()
    }
    
    public func onChange(quantum: ClockQuantum, handler: @escaping ClockHandler) {
        handlers.pushHandler(quantum: quantum, handler: handler)
    }
    
    private func runHandlers() {
        let now = moment()
        handlers.minute.forEach { $0.value(now) }
        if !now.isSameDay(currentTick) {
            handlers.day.forEach { $0.value(now) }
        }
        if !now.isSameMonth(currentTick) {
            handlers.month.forEach { $0.value(now) }
        }
        currentTick = now
    }
}
