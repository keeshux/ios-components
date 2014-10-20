//
//  VC_KSEditEnder.m
//  Components
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "VC_KSEditEnder.h"

@implementation VC_KSEditEnder

@synthesize fields;
@synthesize editEnder;

- (void) dealloc
{
    self.fields = nil;
    self.editEnder = nil;
    
    [super ah_dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fields = [NSMutableArray array];

    const CGFloat width = self.view.frame.size.width - 40;    
    CGRect fieldFrame = CGRectMake(20, 20, width, 30);
    for (NSUInteger i = 0; i < 5; ++i) {
        UITextField *field = [[UITextField alloc] initWithFrame:fieldFrame];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.delegate = self;
        [self.view addSubview:field];
        
        [fields addObject:field];
        [field release];
        
        fieldFrame.origin.y += 40;
    }

    // automatically added to the view
    self.editEnder = [KSEditEnder enderWithView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.fields = nil;
    self.editEnder = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - UITextFieldDelegate

// choose when to intercept outside touches

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    editEnder.userInteractionEnabled = YES;

    // keep keyboard visible on touch within currently edited text field
    [self.view bringSubviewToFront:textField];
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    editEnder.userInteractionEnabled = NO;
}

@end
