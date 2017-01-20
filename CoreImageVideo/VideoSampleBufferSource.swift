//
//  Library.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import Foundation
import AVFoundation
import GLKit

let pixelBufferDict: [String: Any] =
  [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange]


class VideoSampleBufferSource: NSObject {
    lazy var displayLink: CADisplayLink =
        CADisplayLink(target: self, selector: #selector(VideoSampleBufferSource.displayLinkDidRefresh(_:)))
    
    let videoOutput: AVPlayerItemVideoOutput
    let consumer: (CVPixelBuffer) -> ()
    let player: AVPlayer
    
    init?(url: URL, consumer callback: @escaping (CVPixelBuffer) -> ()) {
        player = AVPlayer(url: url)
        consumer = callback
        videoOutput = AVPlayerItemVideoOutput(pixelBufferAttributes: pixelBufferDict)
        player.currentItem?.add(videoOutput)
        
        super.init()

        start()
        player.play()
    }
    
    func start() {
        displayLink.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
    }
    
    func displayLinkDidRefresh(_ link: CADisplayLink) {
        let itemTime = videoOutput.itemTime(forHostTime: CACurrentMediaTime())
        if videoOutput.hasNewPixelBuffer(forItemTime: itemTime) {
            var presentationItemTime = kCMTimeZero
            let pixelBuffer = videoOutput.copyPixelBuffer(forItemTime: itemTime, itemTimeForDisplay: &presentationItemTime)
            consumer(pixelBuffer!)
        }

    }

}
