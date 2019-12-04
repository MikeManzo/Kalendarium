//
//  CalendarNameView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/28/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//
// [Creating a Custom NSView With Xib | @samwize](https://samwize.com/2018/11/21/creating-a-custom-nsview-with-xib/)
//

import Cocoa

class CalendarNameView: NSView {

    @IBOutlet weak var calendarColor: NSImageView!
    @IBOutlet weak var calendarName: NSTextField!
    @IBOutlet weak var contentView: NSView!

    override func awakeFromNib() {
        self.frame = NSRect(x: 0, y: 0, width: 215, height: 25)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
    }

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setup()
    }

    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
  //      setup()
    }

    private func setup() {
        let bundle = Bundle(for: type(of: self))
        let nib = NSNib(nibNamed: .init(String(describing: type(of: self))), bundle: bundle)!
        nib.instantiate(withOwner: self, topLevelObjects: nil)

        addSubview(contentView)
    }
    
    func setupView(name: String, color: NSColor) {
        calendarColor.image?.backgroundColor = color
        calendarName.stringValue = name
    }
}
