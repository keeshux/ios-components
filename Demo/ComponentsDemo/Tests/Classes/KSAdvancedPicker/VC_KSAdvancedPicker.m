//
//  VC_KSAdvancedPicker.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 10/17/11.
//  Copyright (c) 2011 algoritmico. All rights reserved.
//

#import "VC_KSAdvancedPicker.h"

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

    self.title = @"KSAdvancedPicker";

    //

    data = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < 20; ++i) {
        [data addObject:[NSString stringWithFormat:@"Row %d", i]];
    }

    CGRect frame;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        frame = CGRectMake(20, 20, 728, 350);
    } else {
        frame = CGRectMake(20, 20, 280, 200);
    }

    KSAdvancedPicker *ap = [[KSAdvancedPicker alloc] initWithFrame:frame delegate:self];
    [ap reloadData];
    [ap scrollToRowAtIndex:4 animated:YES];
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

    cell.textLabel.textColor = [UIColor blueColor];
    cell.textLabel.text = [data objectAtIndex:rowIndex];

    return cell;
}

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
