//
//  NSRect+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 1/11/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Foundation

extension CGRect {
    func scaleLinear(amount: Double) -> CGRect {
        guard amount != 1.0, amount > 0.0 else { return self }
        let ratio = CGFloat(((1.0 - amount) / 2.0))
        return insetBy(dx: width * ratio, dy: height * ratio)
    }

    func scaleArea(amount: Double) -> CGRect {
        return scaleLinear(percent: sqrt(amount))
    }

    func scaleLinear(percent: Double) -> CGRect {
        return scaleLinear(amount: percent / 100)
    }

    func scaleArea(percent: Double) -> CGRect {
        return scaleArea(amount: percent / 100)
    }
}
