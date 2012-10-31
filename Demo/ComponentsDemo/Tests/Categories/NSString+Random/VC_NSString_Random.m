//
//  VC_NSString_Random.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 3/26/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_NSString_Random.h"
#import "NSString+Random.h"

@interface VC_NSString_Random ()

@end

@implementation VC_NSString_Random

@synthesize outputField;

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
    self.outputField = nil;
    
    [super ah_dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    const CGFloat width = self.view.bounds.size.width - 40;
    
    outputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 30)];
    UIButton *generateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    generateButton.frame = CGRectMake(20, 80, width, 50);
    [generateButton setTitle:@"Generate" forState:UIControlStateNormal];
    [generateButton addTarget:self action:@selector(generateString) forControlEvents:UIControlEventTouchUpInside];
    
    outputField.borderStyle = UITextBorderStyleRoundedRect;
    outputField.placeholder = @"Random string";
    outputField.enabled = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        outputField.font = [UIFont systemFontOfSize:18];
    } else {
        outputField.font = [UIFont systemFontOfSize:14];
    }
    
    [self.view addSubview:outputField];
    [self.view addSubview:generateButton];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.outputField = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) generateString
{
    outputField.text = [NSString randomStringWithLength:16];
}

@end
