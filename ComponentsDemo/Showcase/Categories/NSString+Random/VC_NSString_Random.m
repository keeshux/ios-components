//
//  VC_NSString_Random.m
//  Components
//
//  Created by Davide De Rosa on 3/26/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import "VC_NSString_Random.h"
#import "NSString+Random.h"

@interface VC_NSString_Random ()

@end

@implementation VC_NSString_Random

- (void)viewDidLoad
{
    [super viewDidLoad];

    const CGFloat width = self.view.bounds.size.width - 40;
    
    self.outputField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, width, 30)];
    UIButton *generateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    generateButton.frame = CGRectMake(20, 80, width, 50);
    [generateButton setTitle:@"Generate" forState:UIControlStateNormal];
    [generateButton addTarget:self action:@selector(generateString) forControlEvents:UIControlEventTouchUpInside];
    
    self.outputField.borderStyle = UITextBorderStyleRoundedRect;
    self.outputField.placeholder = @"Random string";
    self.outputField.enabled = NO;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.outputField.font = [UIFont systemFontOfSize:18];
    } else {
        self.outputField.font = [UIFont systemFontOfSize:14];
    }
    
    [self.view addSubview:self.outputField];
    [self.view addSubview:generateButton];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void) generateString
{
    self.outputField.text = [NSString randomStringWithLength:16];
}

@end
