//
//  NSImage+Extension.swift
//  Kalendarium
//
//  Created by Mike Manzo on 11/23/19.
//  Copyright © 2019 Mike Manzo. All rights reserved.
//

import Cocoa

extension NSImage {
    class func swatchWithColor(color: NSColor, size: NSSize) -> NSImage {
        let image = NSImage(size: size)
        image.lockFocus()
        color.drawSwatch(in: NSRect(x: 0, y: 0, width: size.width, height: size.height))
        image.unlockFocus()
        
        return image
    }
    
    convenience init?(withRadius radius: CGFloat, color: NSColor) {
        self.init(size: NSSize(width: radius, height: radius))
        
        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(radius),
                                        pixelsHigh: Int(radius),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSColorSpaceName.calibratedRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)
        
        self.addRepresentation(rep!)
        self.lockFocus()
        
        let rect = NSRect(x: 0, y: 0, width: radius, height: radius)
        guard let context = NSGraphicsContext.current?.cgContext else {
            self.unlockFocus()
            return nil
        }

        context.setFillColor(color.cgColor)
        context.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
        context.fillPath()
        self.unlockFocus()
    }
    
    class func cicle(withRadius radius: CGFloat, color: NSColor) -> NSImage? {
        let image = NSImage.init(size: NSSize(width: radius, height: radius))
        let rep = NSBitmapImageRep.init(bitmapDataPlanes: nil,
                                        pixelsWide: Int(radius),
                                        pixelsHigh: Int(radius),
                                        bitsPerSample: 8,
                                        samplesPerPixel: 4,
                                        hasAlpha: true,
                                        isPlanar: false,
                                        colorSpaceName: NSColorSpaceName.calibratedRGB,
                                        bytesPerRow: 0,
                                        bitsPerPixel: 0)
        
        image.addRepresentation(rep!)
        image.lockFocus()
        
        let rect = NSRect(x: 0, y: 0, width: radius, height: radius)
        guard let context = NSGraphicsContext.current?.cgContext else {
            image.unlockFocus()
            return nil
        }

        context.setFillColor(color.cgColor)
        context.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
        context.fillPath()
        image.unlockFocus()
        
        return image
    }

    func roundCorners(withRadius radius: CGFloat, color: CGColor) -> NSImage {
        let rect = NSRect(origin: NSPoint.zero, size: size)
        if
            let cgImage = self.cgImage,
            let context = CGContext(data: nil,
                                width: Int(size.width),
                                height: Int(size.height),
                                bitsPerComponent: 8,
                                bytesPerRow: 4 * Int(size.width),
                                space: CGColorSpaceCreateDeviceRGB(),
                                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue) {
            context.setFillColor(color)
            context.beginPath()
            context.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
            context.fillPath()
            context.closePath()
            context.clip()
            context.draw(cgImage, in: rect)

            if let composedImage = context.makeImage() {
                return NSImage(cgImage: composedImage, size: size)
            }
        }

        return self
    }
    
    func drawCenteredText(text: String, size: CGFloat, offset: CGFloat = 0) -> NSImage? {
        let textRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height - offset)
        let imageRect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        let font = NSFont.systemFont(ofSize: size)
        
        guard let textStyle = NSMutableParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle else {
            return nil
        }
        
        textStyle.alignment = .center
        let textFontAttributes = [
            NSAttributedString.Key.font: font,
            NSAttributedString.Key.foregroundColor: NSColor.white,
            NSAttributedString.Key.paragraphStyle: textStyle
        ]
        
        let rep: NSBitmapImageRep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: Int(self.size.width),
                                                     pixelsHigh: Int(self.size.height), bitsPerSample: 8,
                                                     samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                                     colorSpaceName: NSColorSpaceName.calibratedRGB,
                                                     bytesPerRow: 0, bitsPerPixel: 0)!
        addRepresentation(rep)
        lockFocus()
        draw(in: imageRect)
        text.draw(in: textRect, withAttributes: textFontAttributes)
        unlockFocus()
        
        return self
    }
}

fileprivate extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect.init(origin: .zero, size: self.size)
        return self.cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
