//
//  VC_UIViewController_SubtitleView.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 06/20/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_UIViewController_SubtitleView.h"
#import "UIViewController+SubtitleView.h"

@implementation VC_UIViewController_SubtitleView

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setTitle:@"Title" subtitle:@"Subtitle"];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // still no rotation
//    return YES;
    return NO;
}

@end
