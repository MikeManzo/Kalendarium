//
//  CustomMenuItemView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/16/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

// [2019 Update](https://stackoverflow.com/questions/6054331/highlighting-a-nsmenuitem-with-a-custom-view#)

class CustomMenuItemView: NSView {
    var isHighlighted: Bool = false {
        didSet {
            if oldValue != isHighlighted {
                needsDisplay = true
            }
        }
    }

    // By default, every menu item has its superview as NSVisualEffectView
    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)

        guard let menuItemViewer = self.superview as? NSVisualEffectView else {
            return
        }
        
        if !NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency {                   // Check if transparency is allowed
            menuItemViewer.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)      // Change the appearance and material for the selection of menu
            menuItemViewer.material = .selection
            if #available(OSX 10.12, *) {
                if NSColor.currentControlTint == NSControlTint.blueControlTint {
                    menuItemViewer.isEmphasized = true
                }
            }
        }
        isHighlighted = true        // It will call the draw(:)
    }
    
    // While exiting from the view, It will make NSVisualEffectView as default.
    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        
        if let v = enclosingMenuItem?.view?.superview as? NSVisualEffectView {
            v.appearance = nil
            v.material = .menu
        }
    }

    // Adding Tracking area to track mouse movements on view.
    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()

        let trackingArea = NSTrackingArea(rect: bounds, options: [NSTrackingArea.Options.mouseEnteredAndExited, NSTrackingArea.Options.activeInActiveApp], owner: self, userInfo: nil)
        self.addTrackingArea(trackingArea)
    }
    
    override init(frame: NSRect) {
        super.init(frame: frame)
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // If user has enabled 'Reduce Transparency' in System Preferences then this block should execute
        if NSWorkspace.shared.accessibilityDisplayShouldReduceTransparency {
            if isHighlighted {
                NSColor.selectedMenuItemColor.set()
            } else {
                NSColor.clear.set()
            }
            NSBezierPath.fill(dirtyRect)
        }
    }
}
