//
//  VC_KSKeyboardScroller.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 1/23/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_KSKeyboardScroller.h"

@implementation VC_KSKeyboardScroller

@synthesize fields;
@synthesize scroller;

- (void) dealloc
{
    self.fields = nil;
    self.scroller = nil;
    
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

    self.fields = [NSMutableArray array];
    
    const CGFloat width = self.view.frame.size.width - 40;    
    CGRect fieldFrame = CGRectMake(20, 20, width, 30);
    for (NSUInteger i = 0; i < 10; ++i) {
        UITextField *field = [[UITextField alloc] initWithFrame:fieldFrame];
        field.borderStyle = UITextBorderStyleRoundedRect;
        field.delegate = self;
        [self.view addSubview:field];
        
        [fields addObject:field];
        [field release];
        
        fieldFrame.origin.y += 40;
    }
    
    // automatically added to the view
    self.scroller = [KSKeyboardScroller scrollerWithMainView:self.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.fields = nil;
    self.scroller = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    scroller.activeView = textField;
}

- (void) textFieldDidEndEditing:(UITextField *)textField
{
    scroller.activeView = nil;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
