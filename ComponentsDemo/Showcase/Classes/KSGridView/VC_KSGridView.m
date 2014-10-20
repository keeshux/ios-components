//
//  VC_KSGridView.m
//  Components
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "VC_KSGridView.h"

@implementation VC_KSGridView

@synthesize grid;

- (void)dealloc
{
    self.grid = nil;

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

    grid = [[KSGridView alloc] initWithFrame:self.view.bounds];
    grid.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.8 alpha:1.0];
    grid.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    grid.dataSource = self;
    grid.delegate = self;
    [self.view addSubview:grid];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    self.grid = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [grid reloadData];
}

#pragma mark - KSGridViewDataSource

- (NSString *)identifierForGridView:(KSGridView *)gridView
{
    if (alternative) {
        return @"AlternativeGrid";
    } else {
        return @"StandardGrid";
    }
}

- (NSInteger)numberOfItemsInGridView:(KSGridView *)gridView
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 73;
    } else {
        return 37;
    }
}

- (NSInteger)numberOfColumnsInGridView:(KSGridView *)gridView
{
    const UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;

    if (UIInterfaceOrientationIsPortrait(orientation)) {
        return 2;
    } else {
        return 3;
    }
}

- (CGSize)sizeForItemInGridView:(KSGridView *)gridView
{
    if (alternative) {
        return CGSizeMake(80, 50);
    } else {
        return CGSizeMake(120, 70);
    }
}

- (CGFloat)heightForRowInGridView:(KSGridView *)gridView
{
//    if (alternative) {
        return 100;
//    } else {
//        return 120;
//    }
}

- (UIView *)gridView:(KSGridView *)gridView viewForItemInRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    if (alternative) {
        label.textColor = [UIColor blueColor];
    } else {
        label.textColor = [UIColor redColor];
    }
    label.textAlignment = UITextAlignmentCenter;
    return [label autorelease];
}

- (void)gridView:(KSGridView *)gridView setDataForItemView:(UIView *)itemView atIndex:(KSGridViewIndex *)index
{
    NSString *title = [NSString stringWithFormat:@"%d", index.position + 1];

    [(UILabel *)itemView setText:title];
}

#pragma mark - KSGridViewDelegate

- (void)gridView:(KSGridView *)gridView didSelectIndex:(KSGridViewIndex *)index
{
    NSLog(@"selected = %@", index);

    alternative = !alternative;
    [gridView reloadData];
}

@end
