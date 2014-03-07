//
//  VC_NSString_Digest.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 11/15/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_NSString_Digest.h"
#import "NSString+Digest.h"

@implementation VC_NSString_Digest

@synthesize inputField;
@synthesize outputField;
@synthesize digestChoice;

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
    self.inputField = nil;
    self.outputField = nil;
    self.digestChoice = nil;

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

    const CGFloat width = self.view.bounds.size.width - 40;

    inputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 30)];
    outputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 60, width, 30)];
    NSArray *digestItems = [NSArray arrayWithObjects:@"MD5", @"SHA1", nil];
    digestChoice = [[UISegmentedControl alloc] initWithItems:digestItems];
    digestChoice.frame = CGRectMake(20, 100, width, 50);
    digestChoice.momentary = YES;
    [digestChoice addTarget:self action:@selector(updateDigest) forControlEvents:UIControlEventValueChanged];

    inputField.borderStyle = UITextBorderStyleRoundedRect;
    inputField.placeholder = @"Input string";
    outputField.borderStyle = UITextBorderStyleRoundedRect;
    outputField.placeholder = @"Output digest";
    outputField.enabled = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        inputField.font = [UIFont systemFontOfSize:14];
        outputField.font = [UIFont systemFontOfSize:14];
    } else {
        inputField.font = [UIFont systemFontOfSize:12];
        outputField.font = [UIFont systemFontOfSize:12];
    }

    [self.view addSubview:inputField];
    [self.view addSubview:outputField];
    [self.view addSubview:digestChoice];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.inputField = nil;
    self.outputField = nil;
    self.digestChoice = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) updateDigest
{
    switch (digestChoice.selectedSegmentIndex) {
        case 0:
            outputField.text = [inputField.text digestByMD5];
            break;
        case 1:
            outputField.text = [inputField.text digestBySHA1];
            break;
    }
}

@end
