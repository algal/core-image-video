//
//  Extensions.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import AVFoundation

extension CGAffineTransform {
    
    init(rotatingWithAngle angle: CGFloat) {
        let t = CGAffineTransform(rotationAngle: angle)
        self.init(a: t.a, b: t.b, c: t.c, d: t.d, tx: t.tx, ty: t.ty)
        
    }
    init(scaleX sx: CGFloat, scaleY sy: CGFloat) {
        let t = CGAffineTransform(scaleX: sx, y: sy)
        self.init(a: t.a, b: t.b, c: t.c, d: t.d, tx: t.tx, ty: t.ty)
        
    }
    
    func scale(_ sx: CGFloat, sy: CGFloat) -> CGAffineTransform {
        return self.scaledBy(x: sx, y: sy)
    }
    func rotate(_ angle: CGFloat) -> CGAffineTransform {
        return self.rotated(by: angle)
    }
}

extension CIImage {
    convenience init(buffer: CMSampleBuffer) {
        self.init(cvPixelBuffer: CMSampleBufferGetImageBuffer(buffer)!)
    }
}

extension CGRect {
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension AVCaptureDevicePosition {
    var transform: CGAffineTransform {
        switch self {
        case .front:
            return CGAffineTransform(rotatingWithAngle: -CGFloat(M_PI_2)).scale(1, sy: -1)
        case .back:
            return CGAffineTransform(rotatingWithAngle: -CGFloat(M_PI_2))
        default:
            return CGAffineTransform.identity
            
        }
    }
    
    var device: AVCaptureDevice? {
        return AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).filter {
            ($0 as AnyObject).position == self
            }.first as? AVCaptureDevice
    }
}
