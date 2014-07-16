//
//  FlashlightViewController.m
//  flashlight
//
//  Created by Derek Briggs on 7/15/14.
//  Copyright (c) 2014 Neo. All rights reserved.
//

#import "FlashlightViewController.h"
@import AVFoundation;

@interface FlashlightViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *flashlightBodyImageView;
@property (weak, nonatomic) IBOutlet UIImageView *switchImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lowGlowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *midGlowImageView;
@property (weak, nonatomic) IBOutlet UIImageView *highGlowImageView;
@property (assign, nonatomic) BOOL flashlightOn;
@property (strong, nonatomic) UIColor *blackColor;
@property (strong, nonatomic) UIColor *whiteColor;

@end

@implementation FlashlightViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    self.blackColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
    self.whiteColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appEnteredBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appEnteredBackground
{
    if (self.flashlightOn) {
        [self turnFlashlightOff];
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (self.flashlightOn) {
        [self turnFlashlightOff];
    } else {
        [self turnFlashlightOn];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)turnFlashlightOff
{
    self.flashlightOn = NO;
    [UIView animateWithDuration:.25 animations:^{
        self.view.backgroundColor = self.blackColor;
    } completion:nil];
    [UIView transitionWithView:self.flashlightBodyImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.flashlightBodyImageView.image = [UIImage imageNamed:@"flashlight-white"];
    } completion:nil];
    [UIView transitionWithView:self.switchImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.switchImageView.image = [UIImage imageNamed:@"on-off-white"];
        [self.switchImageView setFrame:CGRectMake(self.switchImageView.frame.origin.x, self.switchImageView.frame.origin.y + 17, self.switchImageView.frame.size.width, self.switchImageView.frame.size.height)];
    } completion:nil];
    [UIView transitionWithView:self.lowGlowImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.lowGlowImageView.hidden = YES;
    } completion:nil];
    [UIView transitionWithView:self.midGlowImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.midGlowImageView.hidden = YES;
    } completion:nil];
    [UIView transitionWithView:self.highGlowImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.highGlowImageView.hidden = YES;
    } completion:nil];
    [self toggleTorch:NO];
}

- (void)turnFlashlightOn
{
    self.flashlightOn = YES;
    [UIView animateWithDuration:.25 animations:^{
        self.view.backgroundColor = self.whiteColor;
    } completion:nil];
    [UIView transitionWithView:self.flashlightBodyImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.flashlightBodyImageView.image = [UIImage imageNamed:@"flashlight"];
    } completion:nil];
    [UIView transitionWithView:self.switchImageView duration:.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.switchImageView.image = [UIImage imageNamed:@"on-off"];
                [self.switchImageView setFrame:CGRectMake(self.switchImageView.frame.origin.x, self.switchImageView.frame.origin.y - 17, self.switchImageView.frame.size.width, self.switchImageView.frame.size.height)];
    } completion:^ (BOOL finished){
        [self toggleTorch:YES];
    }];
    [UIView transitionWithView:self.lowGlowImageView duration:.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.lowGlowImageView.hidden = NO;
    } completion:nil];
    [UIView transitionWithView:self.midGlowImageView duration:1.0 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.midGlowImageView.hidden = NO;
    } completion:nil];
    [UIView transitionWithView:self.highGlowImageView duration:1.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.highGlowImageView.hidden = NO;
    } completion:nil];
    

}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.flashlightOn) {
        return UIStatusBarStyleDefault;
    } else {
        return UIStatusBarStyleLightContent;
    }
}

- (void)toggleTorch:(BOOL)on
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        if (on) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        
        [device unlockForConfiguration];
    }
}

@end
