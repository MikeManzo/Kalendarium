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
    
    // there can be other views between `subview` and `self`
    func getConvertedFrame(fromSubview subview: NSView) -> CGRect? {
        // check if `subview` is a subview of self
        guard subview.isDescendant(of: self) else {
            return nil
        }

        var frame = subview.frame
        if subview.superview == nil {
            return frame
        }

        var superview = subview.superview
        while superview != self {
            frame = superview!.convert(frame, to: superview!.superview)
            if superview!.superview == nil {
                break
            } else {
                superview = superview!.superview
            }
        }

        return superview!.convert(frame, to: self)
    }
    
    func setAnchorPoint(anchorPoint: CGPoint) {
        if let layer = self.layer {
            var newPoint = CGPoint(x: self.bounds.size.width * anchorPoint.x, y: self.bounds.size.height * anchorPoint.y)
            var oldPoint = CGPoint(x: self.bounds.size.width * layer.anchorPoint.x, y: self.bounds.size.height * layer.anchorPoint.y)

            newPoint = newPoint.applying(layer.affineTransform())
            oldPoint = oldPoint.applying(layer.affineTransform())

            var position = layer.position

            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            layer.position = position
            layer.anchorPoint = anchorPoint
        }
    }
    
    func resizeFrame(newWidth: CGFloat, newHeight: CGFloat) {
        if let originalFrame = self.window?.frame {
            let newSize = CGSize(width: newWidth, height: newHeight)
            self.window?.setFrame(NSRect(origin: originalFrame.origin, size: newSize), display: true, animate: true)
        }
    }
    
    func resizeFrameHeight(newHeight: CGFloat) {
        if let originalFrame = self.window?.frame {
            let newSize = CGSize(width: (self.window?.frame.width)!, height: newHeight)
            self.window?.setFrame(NSRect(origin: originalFrame.origin, size: newSize), display: true, animate: true)
        }
    }

    func resizeFrameWidth(newWidth: CGFloat) {
        if let originalFrame = self.window?.frame {
            let newSize = CGSize(width: newWidth, height: (self.window?.frame.height)!)
            self.window?.setFrame(NSRect(origin: originalFrame.origin, size: newSize), display: true, animate: true)
        }
    }
}
