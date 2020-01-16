//
//  XibView.swift
//  Kalendarium
//
//  Created by Mike Manzo on 1/9/20.
//  Copyright © 2020 Mike Manzo. All rights reserved.
//

import Cocoa

@IBDesignable
class XibView: NSView {
    var contentView: NSView?
    var _nibName: String?

    @IBInspectable
    var XibName: String = "__CHANGE ME__" {
        willSet {
            needsDisplay = true
            _nibName = newValue
            commonInit()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        wantsLayer = true
//         commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
        contentView?.prepareForInterfaceBuilder()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        commonInit()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    func commonInit() {
        guard let newView = loadViewFromNib() else { return }
        newView.frame = self.bounds
        newView.autoresizingMask = [.width, .height]
        self.addSubview(newView)
        contentView = newView
    }

    func loadViewFromNib() -> NSView? {
        var topLevelObjects: NSArray?
        let myBundle = Bundle(for: type(of: self))

        if myBundle.loadNibNamed(_nibName!, owner: self, topLevelObjects: &topLevelObjects) {
            return topLevelObjects?.first(where: { $0 is NSView }) as? NSView
        } else {
            print("Error trying to load the Xib: \(_nibName!)")
            return nil
        }
    }
}
