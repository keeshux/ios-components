//
//  VC_NSString_Digest.m
//  Components
//
//  Created by Davide De Rosa on 11/15/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "VC_NSString_Digest.h"
#import "NSString+Digest.h"

@implementation VC_NSString_Digest

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

    const CGFloat width = self.view.bounds.size.width - 40;

    self.inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 30)];
    self.outputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, width, 30)];
    NSArray *digestItems = [NSArray arrayWithObjects:@"MD5", @"SHA1", nil];
    self.digestChoice = [[UISegmentedControl alloc] initWithItems:digestItems];
    self.digestChoice.frame = CGRectMake(20, 100, width, 50);
    self.digestChoice.momentary = YES;
    [self.digestChoice addTarget:self action:@selector(updateDigest) forControlEvents:UIControlEventValueChanged];

    self.inputField.borderStyle = UITextBorderStyleRoundedRect;
    self.inputField.placeholder = @"Input string";
    self.outputField.borderStyle = UITextBorderStyleRoundedRect;
    self.outputField.placeholder = @"Output digest";
    self.outputField.enabled = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.inputField.font = [UIFont systemFontOfSize:14];
        self.outputField.font = [UIFont systemFontOfSize:14];
    } else {
        self.inputField.font = [UIFont systemFontOfSize:12];
        self.outputField.font = [UIFont systemFontOfSize:12];
    }

    [self.view addSubview:self.inputField];
    [self.view addSubview:self.outputField];
    [self.view addSubview:self.digestChoice];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)updateDigest
{
    switch (self.digestChoice.selectedSegmentIndex) {
        case 0: {
            self.outputField.text = [self.inputField.text digestByMD5];
            break;
        }
        case 1: {
            self.outputField.text = [self.inputField.text digestBySHA1];
            break;
        }
    }
}

@end
