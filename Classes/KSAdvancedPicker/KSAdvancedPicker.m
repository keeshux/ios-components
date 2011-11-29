/*
 * KSAdvancedPicker.m
 *
 * Copyright 2011 Davide De Rosa
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 *     http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "KSAdvancedPicker.h"

@interface KSAdvancedPicker ()

@property (nonatomic, retain) UIView *selector;

- (void) alignToRowBoundary;

@end

@implementation KSAdvancedPicker

// public
@synthesize table;
@synthesize selectedRowIndex;
@synthesize delegate;

// private
@synthesize selector;

- (id) initWithFrame:(CGRect)frame delegate:(id<KSAdvancedPickerDelegate>)aDelegate
{
    if ((self = [super initWithFrame:frame])) {
        delegate = aDelegate;

        // custom row height?
        CGFloat rowHeight;
        if ([delegate respondsToSelector:@selector(heightForRowInAdvancedPicker:)]) {
            rowHeight = [delegate heightForRowInAdvancedPicker:self];
        } else {
            rowHeight = 44;
        }

        // distance from center
        const CGFloat centralRowOffset = (frame.size.height - rowHeight) / 2;

        // picker content
        table = [[UITableView alloc] initWithFrame:self.bounds];
        table.rowHeight = rowHeight;
        table.contentInset = UIEdgeInsetsMake(centralRowOffset, 0, centralRowOffset, 0);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;

        // custom background?
        if ([delegate respondsToSelector:@selector(backgroundViewForAdvancedPicker:)]) {
            table.backgroundView = [delegate backgroundViewForAdvancedPicker:self];
        } else if ([delegate respondsToSelector:@selector(backgroundColorForAdvancedPicker:)]) {
            table.backgroundColor = [delegate backgroundColorForAdvancedPicker:self];
        } else {
            table.backgroundColor = [UIColor whiteColor];
        }

        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
        
        // custom selector?
        if ([delegate respondsToSelector:@selector(viewForAdvancedPickerSelector:)]) {
            self.selector = [delegate viewForAdvancedPickerSelector:self];
        } else if ([delegate respondsToSelector:@selector(viewColorForAdvancedPickerSelector:)]) {
            selector = [[UIView alloc] init];
            selector.backgroundColor = [delegate viewColorForAdvancedPickerSelector:self];
        } else {
            selector = [[UIView alloc] init];
            selector.backgroundColor = [UIColor blueColor];
            selector.alpha = 0.5;
        }
        
        // ignore user input on selector
        selector.userInteractionEnabled = NO;
        
        // override selector frame
        CGRect selectorFrame;
        selectorFrame.origin.x = 0;
        selectorFrame.origin.y = centralRowOffset;
        selectorFrame.size.width = frame.size.width;
        selectorFrame.size.height = rowHeight;
        selector.frame = selectorFrame;
        
        [self addSubview:selector];
        
//        NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
//        NSLog(@"table.frame = %@", NSStringFromCGRect(table.frame));
//        NSLog(@"selector.frame = %@", NSStringFromCGRect(selector.frame));
    }
    return self;
}

- (void) dealloc
{
    self.delegate = nil;
    [table release];
    self.selector = nil;

    [super dealloc];
}

- (void) scrollToRowAtIndex:(NSInteger)rowIndex animated:(BOOL)animated
{
    selectedRowIndex = rowIndex;

    const CGPoint alignedOffset = CGPointMake(0, rowIndex * table.rowHeight - table.contentInset.top);
    [table setContentOffset:alignedOffset animated:animated];

    if ([delegate respondsToSelector:@selector(advancedPicker:didSelectRowAtIndex:)]) {
        [delegate advancedPicker:self didSelectRowAtIndex:rowIndex];
    }
}

- (void) reloadData
{
    [table reloadData];
}

#pragma mark - UITableViewDataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [delegate numberOfRowsInAdvancedPicker:self];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [delegate advancedPicker:self tableView:tableView cellForRowAtIndex:indexPath.row];

    // allow selection but keep invisible
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

#pragma mark - UITableViewDelegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self scrollToRowAtIndex:indexPath.row animated:YES];

    if ([delegate respondsToSelector:@selector(advancedPicker:didClickRowAtIndex:)]) {
        [delegate advancedPicker:self didClickRowAtIndex:indexPath.row];
    }
    
}

#pragma mark - UIScrollViewDelegate

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self alignToRowBoundary];
    }
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self alignToRowBoundary];
}

#pragma mark - Private methods

- (void) alignToRowBoundary
{
//    NSLog(@"contentOffset = %@", NSStringFromCGPoint(table.contentOffset));
//    NSLog(@"rowHeight = %f", table.rowHeight);

    const CGPoint relativeOffset = CGPointMake(0, table.contentOffset.y + table.contentInset.top);
//    NSLog(@"relativeOffset = %@", NSStringFromCGPoint(relativeOffset));

    const NSUInteger rowIndex = round(relativeOffset.y / table.rowHeight);
//    NSLog(@"rowIndex = %d", rowIndex);

    [self scrollToRowAtIndex:rowIndex animated:YES];
}

@end
