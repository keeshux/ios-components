//
//  VC_NSTimer_Pause.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/18/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_NSTimer_Pause.h"
#import "NSTimer+Pause.h"

@implementation VC_NSTimer_Pause

@synthesize countdownLabel;
@synthesize timer;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) dealloc
{
    self.countdownLabel = nil;
    self.timer = nil;
    
    [super ah_dealloc];
}

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

    countdownLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, (self.view.bounds.size.height - 100) / 2)];
    countdownLabel.textAlignment = UITextAlignmentCenter;
    countdownLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
    UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:countdownLabel];

    // pause after 2.2s
    [self performSelector:@selector(delayCountdown) withObject:nil afterDelay:2.2];

    // countdown for 5s
    seconds = 5;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(count) userInfo:nil repeats:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.countdownLabel = nil;
    self.timer = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) delayCountdown
{
    [timer pause];
    countdownLabel.text = @"Paused for 3s";

    // resume in 3s
    [timer performSelector:@selector(resume) withObject:nil afterDelay:3.0];
}

- (void) count
{
    if (seconds > 0) {
        countdownLabel.text = [NSString stringWithFormat:@"%d", seconds];
        --seconds;
    } else {
        [timer invalidate];
        self.timer = nil;
        countdownLabel.text = @"Stopped";
    }
}

@end
