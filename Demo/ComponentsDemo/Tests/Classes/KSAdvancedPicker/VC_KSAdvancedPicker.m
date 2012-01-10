//
//  VC_KSAdvancedPicker.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_KSAdvancedPicker.h"

#define LEGACY

@implementation VC_KSAdvancedPicker

- (void) dealloc
{
    [data release];

    [super dealloc];
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

    data = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 20; ++i) {
        [data addObject:[NSString stringWithFormat:@"%d", i]];
    }

    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(20, 20, 728, 350);
    } else {
        frame = CGRectMake(20, 20, 280, 200);
    }

    KSAdvancedPicker *ap = [[KSAdvancedPicker alloc] initWithFrame:frame delegate:self];
    [ap reloadData];
#ifndef LEGACY
    [ap scrollToRowAtIndex:4 inComponent:0 animated:YES];
#else
    [ap scrollToRowAtIndex:4 animated:YES];
#endif
    [self.view addSubview:ap];
    [ap release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [data release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

#pragma mark - KSAdvancedPickerDelegate

- (CGFloat) heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 80;
    } else {
        return 50;
    }
}

#ifndef LEGACY

- (NSInteger) numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker
{
//    return 1;
    return 3;
}

- (NSInteger) numberOfRowsInAdvancedPicker:(KSAdvancedPicker *)picker inComponent:(NSInteger)component
{
    return [data count];
}

- (UITableViewCell *) advancedPicker:(KSAdvancedPicker *)picker tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)rowIndex forComponent:(NSInteger)component
{
    static NSString *identifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        [cell autorelease];
    }
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [data objectAtIndex:rowIndex];
    
    return cell;
}

- (CGFloat) advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component
{
    const CGFloat width = picker.frame.size.width;

    switch (component) {
        case 0:
            return width * 0.45;
        case 1:
            return width * 0.25;
        case 2:
            return width * 0.3;
        default:
            return 0; // never
    }
}

//- (UIView *) advancedPicker:(KSAdvancedPicker *)picker backgroundViewForComponent:(NSInteger)component
//{
//    return nil;
//}

- (UIColor *) advancedPicker:(KSAdvancedPicker *)picker backgroundColorForComponent:(NSInteger)component
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

- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRowAtIndex:(NSInteger)rowIndex inComponent:(NSInteger)component
{
    NSLog(@"selected row %d in component %d", rowIndex, component);
}

- (void) advancedPicker:(KSAdvancedPicker *)picker didClickRowAtIndex:(NSInteger)rowIndex inComponent:(NSInteger)component
{
    NSLog(@"clicked row %d in component %d", rowIndex, component);
}

#else

- (NSInteger) numberOfRowsInAdvancedPicker:(KSAdvancedPicker *)picker
{
    return [data count];
}

- (UITableViewCell *) advancedPicker:(KSAdvancedPicker *)picker tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)rowIndex
{
    static NSString *identifier = @"CellIdentifier";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        [cell autorelease];
    }

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = [data objectAtIndex:rowIndex];

    return cell;
}

- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"selected row %d", rowIndex);
}

- (void) advancedPicker:(KSAdvancedPicker *)picker didClickRowAtIndex:(NSInteger)rowIndex
{
    NSLog(@"clicked row %d", rowIndex);
}

#endif

//- (UIView *) backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker
//{
//    return nil;
//}

- (UIColor *) backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker
{
    return [UIColor lightGrayColor];
}

//- (UIView *) viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker
//{
//    return nil;
//}

- (UIColor *) viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker
{
    return [UIColor colorWithRed:1.0 green:0.5 blue:0.0 alpha:0.3];
}

@end
