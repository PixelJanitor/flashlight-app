//
//  FlashlightController.swift
//  Flashlight
//
//  Created by Derek Briggs on 7/16/14.
//  Copyright (c) 2014 Neo. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class FlashlightController: UIViewController {
    
    @IBOutlet var flashlightImage: UIImageView
    @IBOutlet var highGlowImage: UIImageView
    @IBOutlet var midGlowImage: UIImageView
    @IBOutlet var lowGlowImage: UIImageView
    @IBOutlet var switchImage: UIImageView
    @IBOutlet var countLabel: UILabel
    
    var flashlightIsOn = false
    let animationDurationTime = 0.25
    let blackColor = UIColor(red: 0, green:0, blue:0, alpha:1)
    let whiteColor = UIColor(red: 1, green:1, blue:1, alpha:1)
    let switchOffset: CGFloat = 17.5
    var tapCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let singleFingerTap = UITapGestureRecognizer(target: self, action: "handleSingleTap")
        self.view.addGestureRecognizer(singleFingerTap)
    }
    
    func handleSingleTap() {
        if (flashlightIsOn) {
            turnFlashlightOff()
        } else {
            turnFlashlightOn()
        }
        setNeedsStatusBarAppearanceUpdate()
        tapCount++
        countLabel.text = tapCount.description
    }
    
    func turnFlashlightOff() {
        toggleTorch()
        flashlightIsOn = false
        UIView.animateWithDuration(animationDurationTime, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.flashlightImage.image = UIImage(named: "flashlight-white")
            self.view.backgroundColor = self.blackColor
            self.switchImage.image = UIImage(named: "on-off-white")
            let frame = self.switchImage.frame
            self.switchImage.frame = CGRectMake(frame.origin.x, frame.origin.y + self.switchOffset, frame.size.width, frame.size.height)
            self.lowGlowImage.alpha = 0.0
            self.lowGlowImage.frame = CGRectMake(self.lowGlowImage.frame.origin.x, self.lowGlowImage.frame.origin.y + self.switchOffset, self.lowGlowImage.frame.size.width, frame.size.height)
            self.midGlowImage.alpha = 0.0
            self.midGlowImage.frame = CGRectMake(self.midGlowImage.frame.origin.x, self.midGlowImage.frame.origin.y + self.switchOffset, self.midGlowImage.frame.size.width, self.midGlowImage.frame.size.height)
            self.highGlowImage.alpha = 0.0
            self.highGlowImage.frame = CGRectMake(self.highGlowImage.frame.origin.x, self.highGlowImage.frame.origin.y + self.switchOffset, self.highGlowImage.frame.size.width, self.highGlowImage.frame.size.height)
            self.countLabel.textColor = self.whiteColor
            }, completion: nil)
    }
    
    func turnFlashlightOn() {
        toggleTorch()
        flashlightIsOn = true
        
        UIView.animateWithDuration(animationDurationTime, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.flashlightImage.image = UIImage(named: "flashlight")
            self.view.backgroundColor = self.whiteColor
            self.switchImage.image = UIImage(named: "on-off")
            let frame = self.switchImage.frame
            self.switchImage.frame = CGRectMake(frame.origin.x, frame.origin.y - self.switchOffset, frame.size.width, frame.size.height)
            self.countLabel.textColor = self.blackColor
            }, completion: nil)
        UIView.animateWithDuration(animationDurationTime, delay: 0.0, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.lowGlowImage.alpha = 1.0
            self.lowGlowImage.frame = CGRectMake(self.lowGlowImage.frame.origin.x, self.lowGlowImage.frame.origin.y - self.switchOffset, self.lowGlowImage.frame.size.width, self.lowGlowImage.frame.size.height)
            }, completion: nil)
        UIView.animateWithDuration(animationDurationTime, delay: animationDurationTime / 2, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.midGlowImage.alpha = 1.0
            self.midGlowImage.frame = CGRectMake(self.midGlowImage.frame.origin.x, self.midGlowImage.frame.origin.y - self.switchOffset, self.midGlowImage.frame.size.width, self.midGlowImage.frame.size.height)
            }, completion: nil)
        UIView.animateWithDuration(animationDurationTime, delay: animationDurationTime, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: {
            self.highGlowImage.alpha = 1.0
            self.highGlowImage.frame = CGRectMake(self.highGlowImage.frame.origin.x, self.highGlowImage.frame.origin.y - self.switchOffset, self.highGlowImage.frame.size.width, self.highGlowImage.frame.size.height)
            }, completion: nil)
    }
    
    func toggleTorch() {
        if let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo) {
            if (device.hasTorch) {
                device.lockForConfiguration(nil)
                if (flashlightIsOn) {
                    device.torchMode = AVCaptureTorchMode.Off
                } else {
                    device.torchMode = AVCaptureTorchMode.On
                }
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        if (flashlightIsOn) {
            return UIStatusBarStyle.Default
        } else {
            return UIStatusBarStyle.LightContent
        }
    }
}

