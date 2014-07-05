//
//  VC_KSCheckView.m
//  Components
//
//  Created by Davide De Rosa on 10/23/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_KSCheckView.h"

@implementation VC_KSCheckView

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    KSCheckView *onCheck = [[KSCheckView alloc] initWithFrame:CGRectMake(20, 20, 50, 50)];
    onCheck.backgroundColor = [UIColor blueColor];
    onCheck.color = [UIColor whiteColor];
    onCheck.checked = YES;
    onCheck.delegate = self;
    [self.view addSubview:onCheck];
    [onCheck release];

    KSCheckView *offCheck = [[KSCheckView alloc] initWithFrame:CGRectMake(100, 20, 50, 50)];
    offCheck.backgroundColor = [UIColor redColor];
    offCheck.color = [UIColor yellowColor];
    offCheck.checked = NO;
    offCheck.delegate = self;
    [self.view addSubview:offCheck];
    [offCheck release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - KSCheckViewDelegate

- (void) checkView:(KSCheckView *)checkView didChangeToChecked:(BOOL)checked
{
    NSLog(@"check view is now %@", (checked ? @"checked" : @"unchecked"));
}

@end
