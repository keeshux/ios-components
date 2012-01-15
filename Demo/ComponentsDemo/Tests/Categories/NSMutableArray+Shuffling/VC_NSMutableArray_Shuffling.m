//
//  VC_NSMutableArray_Shuffling.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/15/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_NSMutableArray_Shuffling.h"

#import "NSMutableArray+Shuffling.h"

@implementation VC_NSMutableArray_Shuffling

@synthesize testData;
@synthesize beforeLabel;
@synthesize shuffleButton;
@synthesize afterLabel;

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
    self.testData = nil;
    self.beforeLabel = nil;
    self.shuffleButton = nil;
    self.afterLabel = nil;

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

    self.testData = [NSMutableArray arrayWithObjects:@"A", @"B", @"C", @"D", @"E", @"F", nil];

    beforeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 100, self.view.bounds.size.width - 40, 20)];
    self.shuffleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shuffleButton.frame = CGRectMake(20, 140, self.view.bounds.size.width - 40, 40);
    afterLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 200, self.view.bounds.size.width - 40, 20)];

    [shuffleButton setTitle:@"Shuffle" forState:UIControlStateNormal];
    [shuffleButton addTarget:self action:@selector(shuffleData:) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:beforeLabel];
    [self.view addSubview:shuffleButton];
    [self.view addSubview:afterLabel];

    beforeLabel.text = [testData description];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.testData = nil;
    self.beforeLabel = nil;
    self.shuffleButton = nil;
    self.afterLabel = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) shuffleData:(id)sender
{
    [testData shuffle];
    afterLabel.text = [testData description];
}

@end
