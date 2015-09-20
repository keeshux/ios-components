//
//  VC_NSTimer_Pause.m
//  Components
//
//  Created by Davide De Rosa on 1/18/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import "VC_NSTimer_Pause.h"
#import "NSTimer+Pause.h"

@implementation VC_NSTimer_Pause

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.countdownLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, (self.view.bounds.size.height - 100) / 2)];
    self.countdownLabel.textAlignment = NSTextAlignmentCenter;
    self.countdownLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:self.countdownLabel];

    // pause after 2.2s
    [self performSelector:@selector(delayCountdown) withObject:nil afterDelay:2.2];

    // countdown for 5s
    self.seconds = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // Return YES for supported orientations
    return UIInterfaceOrientationMaskPortrait;
}

- (void)delayCountdown
{
    [self.timer pause];
    self.countdownLabel.text = @"Paused for 3s";

    // resume in 3s
    [self.timer performSelector:@selector(resume) withObject:nil afterDelay:3.0];
}

- (void)count
{
    if (self.seconds > 0) {
        self.countdownLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.seconds];
        --self.seconds;
    } else {
        [self.timer invalidate];
        self.timer = nil;
        self.countdownLabel.text = @"Stopped";
    }
}

@end
