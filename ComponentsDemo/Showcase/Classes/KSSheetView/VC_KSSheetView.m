//
//  VC_KSSheetView.m
//  Components
//
//  Created by Davide De Rosa on 10/23/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_KSSheetView.h"

@implementation VC_KSSheetView

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    KSSheetView *sheet = [[KSSheetView alloc] initWithFrame:self.view.bounds];
    sheet.cellSize = 20;
    sheet.lineWidth = 1.0;
    sheet.delegate = self;
    [self.view addSubview:sheet];
    [sheet release];
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

#pragma mark - KSSheetViewDelegate

- (void) drawInSheet:(KSSheetView *)sheetView inContext:(CGContextRef)context inRect:(CGRect)rect
{
    CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
    CGContextFillRect(context, CGRectMake(100, 100, 80, 120));
    CGContextSetFillColorWithColor(context, [UIColor blueColor].CGColor);
    CGContextFillRect(context, CGRectMake(200, 200, 100, 70));
}

@end
