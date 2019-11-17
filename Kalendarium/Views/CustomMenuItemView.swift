//
//  CustomMenuItemView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/16/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

class CustomMenuItemView: NSView {
    private var effectView: NSVisualEffectView

    override init(frame: NSRect) {
        effectView = NSVisualEffectView()
        effectView.blendingMode = .behindWindow
        effectView.material = .selection
        effectView.isEmphasized = true
        effectView.state = .active

        super.init(frame: frame)
        addSubview(effectView)
        effectView.frame = bounds
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ dirtyRect: NSRect) {
        effectView.isHidden = !(enclosingMenuItem?.isHighlighted ?? false)
    }
}
