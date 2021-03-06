//
//  UIImage+.swift
//  Squatcho
//
//  Created by Alexandra Francis on 7/23/17.
//  Copyright © 2017 Marlexa. All rights reserved.
//

import Foundation

extension UIImage {
    func maskWithColor(color: UIColor) -> UIImage? {
        let maskImage = cgImage!
        
        let width = size.width
        let height = size.height
        let bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)!
        
        context.clip(to: bounds, mask: maskImage)
        context.setFillColor(color.cgColor)
        context.fill(bounds)
        
        if let cgImage = context.makeImage() {
            let coloredImage = UIImage(cgImage: cgImage)
            return coloredImage
        } else {
            return nil
        }
    }
    /*
    func tintImage(tint: UIColor) {
        guard let tinted = self.copy() as? UIImage else { return }
        tinted.lockFocus()
        tint.set()
        
        let imageRect = CGRect(origin: UIZeroPoint, size: self.size)
        UIRectFillUsingBlendMode(imageRect, .sourceAtop)
        
        tinted.unlockFocus()
        
        self.image! = tinted
    }
    */
}
