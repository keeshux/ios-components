//
//  VC_NSString_DateConversion.m
//  Components
//
//  Created by Davide De Rosa on 11/6/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "VC_NSString_DateConversion.h"
#import "NSString+DateConversion.h"

@implementation VC_NSString_DateConversion

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

    UIScrollView *scroller = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    
    CGSize scrollableSize = self.view.frame.size;
    scrollableSize.height += 100;
    scroller.contentSize = scrollableSize;
    const CGFloat x = 20;
    const CGFloat width = scrollableSize.width - 2 * x;
    
    self.inputDate = [[UITextField alloc] initWithFrame:CGRectMake(x, 20, width, 30)];
    self.inputDate.placeholder = @"Input date (e.g.: 06/15/2011)";
    self.inputFormat = [[UITextField alloc] initWithFrame:CGRectMake(x, 60, width, 30)];
    self.inputFormat.placeholder = @"Input format (e.g.: MM/dd/yyyy)";
    self.outputFormat = [[UITextField alloc] initWithFrame:CGRectMake(x, 100, width, 30)];
    self.outputFormat.placeholder = @"Output format (e.g.: eee dd)";
    self.outputDate = [[UILabel alloc] initWithFrame:CGRectMake(x, 140, width, 50)];
    self.convertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    self.inputDate.borderStyle = UITextBorderStyleRoundedRect;
    self.inputDate.delegate = self;
    self.inputFormat.borderStyle = UITextBorderStyleRoundedRect;
    self.inputFormat.delegate = self;
    self.outputFormat.borderStyle = UITextBorderStyleRoundedRect;
    self.outputFormat.delegate = self;
    self.convertButton.frame = CGRectMake(20, 200, width, 40);
    [self.convertButton setTitle:@"Convert" forState:UIControlStateNormal];
    [self.convertButton addTarget:self action:@selector(convertDate:) forControlEvents:UIControlEventTouchUpInside];
    
    [scroller addSubview:self.inputDate];
    [scroller addSubview:self.inputFormat];
    [scroller addSubview:self.outputFormat];
    [scroller addSubview:self.outputDate];
    [scroller addSubview:self.convertButton];
    
    [self.view addSubview:scroller];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (void)convertDate:(id)sender
{
    self.outputDate.text = [self.inputDate.text dateStringFromFormat:self.inputFormat.text toFormat:self.outputFormat.text];

    [self.view endEditing:NO];    
}

#pragma mark UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

@end
