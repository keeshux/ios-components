//
//  VC_UIBarButtonItem_CustomImage.m
//  Components
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_UIBarButtonItem_CustomImage.h"
#import "UIBarButtonItem+CustomImage.h"

@implementation VC_UIBarButtonItem_CustomImage

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

    UIBarButtonItem *leftItem = [UIBarButtonItem itemWithBackgroundImage:[UIImage imageNamed:@"ItemBackgroundImage.png"]
                                                                  target:self
                                                                  action:@selector(leftItemClicked:)];
    [leftItem setCustomButtonTitle:@"Back" forState:UIControlStateNormal];
    [leftItem setCustomButtonTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    UIBarButtonItem *rightItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"ItemImage.png"]
                                                         target:self
                                                         action:@selector(rightItemClicked:)];

    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.rightBarButtonItem = rightItem;
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

- (void) leftItemClicked:(id)sender
{
    NSLog(@"leftItemClicked");

    [self.navigationController popViewControllerAnimated:YES];
}

- (void) rightItemClicked:(id)sender
{
    NSLog(@"rightItemClicked");

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Title"
                                                    message:@"You clicked right item!"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

@end
