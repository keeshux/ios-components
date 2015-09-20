//
// Copyright (c) 2011, Davide De Rosa
// All rights reserved.
//
// This code is distributed under the terms and conditions of the BSD license.
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
// 1. Redistributions of source code must retain the above copyright notice, this
// list of conditions and the following disclaimer.
//
// 2. Redistributions in binary form must reproduce the above copyright notice,
// this list of conditions and the following disclaimer in the documentation and/or
// other materials provided with the distribution.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR
// ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
//  LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
// ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "KSAdvancedPicker.h"

@interface KSAdvancedPicker ()

@property (nonatomic, strong) NSMutableArray *tables;
@property (nonatomic, strong) NSMutableArray *selectedRowIndexes;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *overlay;
@property (nonatomic, strong) UIView *selector;

- (void)addContent;
- (void)removeContent;
- (void)updateDelegateSubviews;

- (NSInteger)componentFromTableView:(UITableView *)tableView;
- (void)alignTableViewToRowBoundary:(UITableView *)tableView;

@end

@implementation KSAdvancedPicker

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
    }
    return self;
}

- (void)setDataSource:(id<KSAdvancedPickerDataSource>)dataSource
{
    if (dataSource == _dataSource) {
        return;
    }

    // remove previous content
    [self removeContent];

    // add new content
    _dataSource = dataSource;
    if (_dataSource) {
        [self addContent];
        [self updateDelegateSubviews];
        [self reloadData];
    }
}

- (void)setDelegate:(id<KSAdvancedPickerDelegate>)delegate
{
    if (delegate == _delegate) {
        return;
    }

    // rearrange content
    _delegate = delegate;
    if (_delegate) {
        [self updateDelegateSubviews];
        [self reloadData];
    }
}

- (UITableView *)tableViewForComponent:(NSInteger)component
{
    return [self.tables objectAtIndex:component];
}

- (NSInteger)selectedRowInComponent:(NSInteger)component
{
    return [[self.selectedRowIndexes objectAtIndex:component] integerValue];
}

- (void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated
{
    [self.selectedRowIndexes replaceObjectAtIndex:component withObject:[NSNumber numberWithInteger:row]];
    
    UITableView *table = [self.tables objectAtIndex:component];

    const CGPoint alignedOffset = CGPointMake(0, row * table.rowHeight - table.contentInset.top);
    [table setContentOffset:alignedOffset animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(advancedPicker:didSelectRow:inComponent:)]) {
        [self.delegate advancedPicker:self didSelectRow:row inComponent:component];
    }
}

- (void)reloadData
{
    for (UITableView *table in self.tables) {
        [table reloadData];
    }
}

- (void)reloadDataInComponent:(NSInteger)component
{
    [[self.tables objectAtIndex:component] reloadData];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    const NSInteger component = [self componentFromTableView:tableView];
    return [self.dataSource advancedPicker:self numberOfRowsInComponent:component];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"ComponentCell";
    static const NSInteger tag = 1000;

    const NSInteger component = [self componentFromTableView:tableView];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    UIView *view = nil;
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];

        // allow selection but keep invisible
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // fill contentView
        const CGRect viewRect = cell.contentView.bounds;

        // LEGACY: support old method
        if ([self.dataSource respondsToSelector:@selector(advancedPicker:viewForComponent:inRect:)]) {
            view = [self.dataSource advancedPicker:self viewForComponent:component inRect:viewRect];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            view = [self.dataSource advancedPicker:self viewForComponent:component];
#pragma clang diagnostic pop
        }

        view.frame = viewRect;
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        view.tag = tag;
        [cell.contentView addSubview:view];
    } else {
        view = [cell.contentView viewWithTag:tag];
    }

    // ask content to data source
    [self.dataSource advancedPicker:self setDataForView:view row:indexPath.row inComponent:component];

    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    const NSInteger component = [self componentFromTableView:tableView];

    // call upon animation end?
    if ([self.delegate respondsToSelector:@selector(advancedPicker:didClickRow:inComponent:)]) {
        [self.delegate advancedPicker:self didClickRow:indexPath.row inComponent:component];
    }

    [self selectRow:indexPath.row inComponent:component animated:YES];
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self alignTableViewToRowBoundary:(UITableView *)scrollView];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self alignTableViewToRowBoundary:(UITableView *)scrollView];
}

#pragma mark Content management

- (void)addContent
{
    // custom row height?
    if ([self.dataSource respondsToSelector:@selector(heightForRowInAdvancedPicker:)]) {
        self.rowHeight = [self.dataSource heightForRowInAdvancedPicker:self];
    } else {
        self.rowHeight = 44;
    }
    
    // distance from center
    self.centralRowOffset = (self.frame.size.height - self.rowHeight) / 2;
    
    // number of components
    const NSInteger components = [self.dataSource numberOfComponentsInAdvancedPicker:self];
    
    // picker content
    self.tables = [[NSMutableArray alloc] init];
    self.selectedRowIndexes = [[NSMutableArray alloc] init];
    CGRect tableFrame = CGRectMake(0, 0, 0, self.bounds.size.height);
    for (NSInteger i = 0; i < components; ++i) {
        
        // optional width
        if ([self.dataSource respondsToSelector:@selector(advancedPicker:widthForComponent:)]) {
            tableFrame.size.width = [self.dataSource advancedPicker:self widthForComponent:i];
        } else {
            tableFrame.size.width = (NSUInteger)(self.frame.size.width / components);
        }
        
        // component table
        UITableView *table = [[UITableView alloc] initWithFrame:tableFrame];
        table.rowHeight = self.rowHeight;
        table.contentInset = UIEdgeInsetsMake(self.centralRowOffset, 0, self.centralRowOffset, 0);
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.showsVerticalScrollIndicator = NO;
        
        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
        
        [self.tables addObject:table];
        [self.selectedRowIndexes addObject:[NSNumber numberWithInteger:0]]; // first row selected by default
        
        // next component offset
        tableFrame.origin.x += tableFrame.size.width;
    }
}

- (void)removeContent
{
    // remove tables
    for (UITableView *table in self.tables) {
        [table removeFromSuperview];
    }
    self.tables = nil;
    
    // remove indexes
    self.selectedRowIndexes = nil;
    
    // remove background
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    
    // remove overlay
    [self.overlay removeFromSuperview];
    self.overlay = nil;

    // remove selector
    [self.selector removeFromSuperview];
    self.selector = nil;
}

- (void)updateDelegateSubviews
{
    // remove delegate subviews
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [self.overlay removeFromSuperview];
    self.overlay = nil;
    [self.selector removeFromSuperview];
    self.selector = nil;

    // component background view/color
    NSUInteger i = 0;
    for (UITableView *table in self.tables) {
        if ([self.delegate respondsToSelector:@selector(advancedPicker:backgroundViewForComponent:)]) {
            table.backgroundView = [self.delegate advancedPicker:self backgroundViewForComponent:i];
        } else if ([self.delegate respondsToSelector:@selector(advancedPicker:backgroundColorForComponent:)]) {
            table.backgroundColor = [self.delegate advancedPicker:self backgroundColorForComponent:i];
        } else {
            table.backgroundColor = [UIColor clearColor];
        }
        ++i;
    }
    
    // picker background
    if ([self.delegate respondsToSelector:@selector(backgroundViewForAdvancedPicker:)]) {
        self.backgroundView = [self.delegate backgroundViewForAdvancedPicker:self];

        // add and send to back
        [self addSubview:self.backgroundView];
        [self sendSubviewToBack:self.backgroundView];
    } else if ([self.delegate respondsToSelector:@selector(backgroundColorForAdvancedPicker:)]) {
        self.backgroundColor = [self.delegate backgroundColorForAdvancedPicker:self];
    }
    
    // optional overlay
    if ([self.delegate respondsToSelector:@selector(overlayViewForAdvancedPickerSelector:)]) {
        self.overlay = [self.delegate overlayViewForAdvancedPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(overlayColorForAdvancedPickerSelector:)]) {
        self.overlay = [[UIView alloc] init];
        self.overlay.backgroundColor = [self.delegate overlayColorForAdvancedPickerSelector:self];
    }
    
    if (self.overlay) {
        
        // ignore user input on selector
        self.overlay.userInteractionEnabled = NO;
        
        // fill parent
        self.overlay.frame = self.bounds;
        [self addSubview:self.overlay];
    }
    
    // custom selector?
    if ([self.delegate respondsToSelector:@selector(viewForAdvancedPickerSelector:)]) {
        self.selector = [self.delegate viewForAdvancedPickerSelector:self];
    } else if ([self.delegate respondsToSelector:@selector(viewColorForAdvancedPickerSelector:)]) {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [self.delegate viewColorForAdvancedPickerSelector:self];
    } else {
        self.selector = [[UIView alloc] init];
        self.selector.backgroundColor = [UIColor blackColor];
        self.selector.alpha = 0.3;
    }
    
    // ignore user input on selector
    self.selector.userInteractionEnabled = NO;
    
    // override selector frame
    CGRect selectorFrame;
    selectorFrame.origin.x = 0;
    selectorFrame.origin.y = self.centralRowOffset;
    selectorFrame.size.width = self.frame.size.width;
    selectorFrame.size.height = self.rowHeight;
    self.selector.frame = selectorFrame;
    
    [self addSubview:self.selector];
    
//    NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
//    NSLog(@"table.frame = %@", NSStringFromCGRect(table.frame));
//    NSLog(@"selector.frame = %@", NSStringFromCGRect(selector.frame));
}

#pragma mark Other methods

- (NSInteger)componentFromTableView:(UITableView *)tableView
{
    return [self.tables indexOfObject:tableView];
}

- (void)alignTableViewToRowBoundary:(UITableView *)tableView
{
//    NSLog(@"contentOffset = %@", NSStringFromCGPoint(tableView.contentOffset));
//    NSLog(@"rowHeight = %f", tableView.rowHeight);

    const CGPoint relativeOffset = CGPointMake(0, tableView.contentOffset.y + tableView.contentInset.top);
//    NSLog(@"relativeOffset = %@", NSStringFromCGPoint(relativeOffset));

    const NSUInteger row = round(relativeOffset.y / tableView.rowHeight);
//    NSLog(@"row = %d", row);

    const NSInteger component = [self componentFromTableView:tableView];
    [self selectRow:row inComponent:component animated:YES];
}

@end
