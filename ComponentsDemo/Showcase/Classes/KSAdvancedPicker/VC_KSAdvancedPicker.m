//
//  VC_KSAdvancedPicker.m
//  Components
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 Davide De Rosa. All rights reserved.
//

#import "VC_KSAdvancedPicker.h"

@implementation VC_KSAdvancedPicker

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];

    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(20, 40, 728, 350);
    } else {
        frame = CGRectMake(20, 40, 280, 200);
    }

    KSAdvancedPicker *ap = [[KSAdvancedPicker alloc] initWithFrame:frame];
    ap.dataSource = self;
    ap.delegate = self;
    [ap selectRow:4 inComponent:0 animated:YES];
    [self.view addSubview:ap];
    [ap release];

//    for (NSUInteger i = 0; i < [self numberOfComponentsInAdvancedPicker:ap]; ++i) {
//        UITableView *table = [ap tableViewForComponent:i];
//
//        NSLog(@"table[%d] width = %f", i, table.frame.size.width);
//        NSLog(@"table[%d] insets = %@", i, NSStringFromUIEdgeInsets(table.contentInset));
//    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - KSAdvancedPickerDataSource

- (NSInteger)numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker
{
    return 3;
}

- (NSInteger)advancedPicker:(KSAdvancedPicker *)picker numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

- (UIView *)advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component inRect:(CGRect)rect
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = UITextAlignmentCenter;

    switch (component) {
        case 0:
            label.textColor = [UIColor orangeColor];
            break;
        case 1:
            label.textColor = [UIColor whiteColor];
            break;
        case 2:
            label.textColor = [UIColor yellowColor];
            break;
    }

    return [label autorelease];
}

- (void)advancedPicker:(KSAdvancedPicker *)picker setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component
{
    UILabel *label = (UILabel *) view;

    label.text = [NSString stringWithFormat:@"%d", component * [self advancedPicker:picker numberOfRowsInComponent:component] + row];
}

- (CGFloat)heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 80;
    } else {
        return 50;
    }
}

- (CGFloat)advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component
{
    CGFloat width = picker.frame.size.width;

    switch (component) {
        case 0:
            width *= 0.45;
            break;
        case 1:
            width *= 0.25;
            break;
        case 2:
            width *= 0.3;
            break;
        default:
            return 0; // never
    }

//    return width;
    return round(width);
}

#pragma mark - KSAdvancedPickerDelegate

- (void)advancedPicker:(KSAdvancedPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"selected row %d in component %d", row, component);
}

- (void)advancedPicker:(KSAdvancedPicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"clicked row %d in component %d", row, component);
}

//- (UIView *)backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker
//{
//    return nil;
//}

- (UIColor *)backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker
{
    return [UIColor lightGrayColor];
}

//- (UIView *)advancedPicker:(KSAdvancedPicker *)picker backgroundViewForComponent:(NSInteger)component
//{
//    return nil;
//}

- (UIColor *)advancedPicker:(KSAdvancedPicker *)picker backgroundColorForComponent:(NSInteger)component
{
//    return [UIColor clearColor];
    
    switch (component) {
        case 0:
            return [UIColor colorWithRed:0.5 green:0.5 blue:0.0 alpha:1.0];
        case 1:
            return [UIColor colorWithRed:0.5 green:0.0 blue:0.5 alpha:1.0];
        case 2:
            return [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:1.0];
        default:
            return 0; // never
    }
}

//- (UIView *)viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker
//{
//    return nil;
//}

- (UIColor *)viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker
{
    return [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.3];
}

@end
