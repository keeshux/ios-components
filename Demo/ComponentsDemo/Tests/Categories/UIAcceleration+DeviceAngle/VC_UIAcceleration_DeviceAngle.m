//
//  VC_UIAcceleration_DeviceAngle.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_UIAcceleration_DeviceAngle.h"
#import "UIAcceleration+DeviceAngle.h"

#define R2D(rads)       (rads * 180.0 / M_PI)

@implementation VC_UIAcceleration_DeviceAngle

@synthesize accelerometer;
@synthesize angleLabel;

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
    accelerometer.delegate = nil;
    self.accelerometer = nil;
    self.angleLabel = nil;

    [super dealloc];
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

#if !TARGET_IPHONE_SIMULATOR
    angleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.view.bounds, 20, (self.view.bounds.size.height - 100) / 2)];
    angleLabel.textAlignment = UITextAlignmentCenter;
    angleLabel.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin |
                                  UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:angleLabel];

    self.accelerometer = [UIAccelerometer sharedAccelerometer];
    accelerometer.updateInterval = .1;
    accelerometer.delegate = self;
#endif
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

#if TARGET_IPHONE_SIMULATOR
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ios-components"
                                                        message:@"Unavailable on Simulator!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
    [self.navigationController popViewControllerAnimated:YES];
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.accelerometer = nil;
    self.angleLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIAccelerometerDelegate

- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    const CGPoint angle = [acceleration deviceAngle];

    angleLabel.text = [NSString stringWithFormat:@"{x=%.0f, y=%.0f}", R2D(angle.x), R2D(angle.y)];
}

@end
