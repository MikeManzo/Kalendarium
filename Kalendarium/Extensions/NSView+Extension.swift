//
//  NSView+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 12/11/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

extension NSView {
    var parentViewController: NSViewController? {
        var parentResponder: NSResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder?.nextResponder
            if let viewController = parentResponder as? NSViewController {
                return viewController
            }
        }
        return nil
    }
}
