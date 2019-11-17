//
//  NSGraphicsImageRenderer.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/10/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

public class NSGraphicsImageRenderer {
    let size: CGSize

    init(size: CGSize) {
        self.size = size
    }

    func image(actions: (CGContext) -> Void) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocusFlipped(true)
        actions(NSGraphicsContext.current!.cgContext)
        image.unlockFocus()

        return image
    }
}
