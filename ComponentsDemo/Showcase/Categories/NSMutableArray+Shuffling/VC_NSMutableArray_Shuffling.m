//
//  VC_NSMutableArray_Shuffling.m
//  Components
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import "VC_NSMutableArray_Shuffling.h"
#import "NSMutableArray+Shuffling.h"

@implementation VC_NSMutableArray_Shuffling

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

    self.testData = [@[@"A", @"B", @"C", @"D", @"E", @"F"] mutableCopy];

    self.beforeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 20)];
    self.shuffleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.shuffleButton.frame = CGRectMake(20, 140, self.view.bounds.size.width - 40, 40);
    self.afterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 20)];

    [self.shuffleButton setTitle:@"Shuffle" forState:UIControlStateNormal];
    [self.shuffleButton addTarget:self action:@selector(shuffleData:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.beforeLabel];
    [self.view addSubview:self.shuffleButton];
    [self.view addSubview:self.afterLabel];

    self.beforeLabel.text = [self.testData componentsJoinedByString:@" "];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)shuffleData:(id)sender
{
    [self.testData shuffle];
    self.afterLabel.text = [self.testData componentsJoinedByString:@" "];
}

@end
