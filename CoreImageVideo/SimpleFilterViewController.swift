//
//  ViewController.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleFilterViewController: UIViewController {
    var source: CaptureBufferSource?
    var coreImageView: CoreImageView?

    var angleForCurrentTime: Float {
        return Float(NSDate.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: M_PI)*2)
    }

    override func loadView() {
        coreImageView = CoreImageView(frame: CGRect())
        self.view = coreImageView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupCameraSource()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        source?.running = false
    }
    
    func setupCameraSource() {
        source = CaptureBufferSource(position: AVCaptureDevicePosition.front) { [unowned self] (buffer, transform) in
            let input = CIImage(buffer: buffer).applying(transform)
            let filter = hueAdjust(self.angleForCurrentTime)
            self.coreImageView?.image = filter(input)
        }
        source?.running = true
    }
}

