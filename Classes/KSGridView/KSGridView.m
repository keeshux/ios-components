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

#import "KSGridView.h"
#import "KSGridViewCell.h"

@interface KSGridView ()

@property (nonatomic, strong) UITableView *table;

@end

@implementation KSGridView

// public
@synthesize dataSource;
@synthesize delegate;

// private
@synthesize table;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        table = [[UITableView alloc] initWithFrame:self.bounds];
        table.backgroundColor = [UIColor clearColor];
        table.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.dataSource = self;
        table.delegate = self;
        [self addSubview:table];
    }
    return self;
}

- (void) dealloc
{
    self.table = nil;

    [super ah_dealloc];
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
    const NSUInteger numberOfItems = [dataSource numberOfItemsInGridView:self];
    const NSUInteger numberOfColumns = [dataSource numberOfColumnsInGridView:self];
    NSUInteger rows = numberOfItems / numberOfColumns;

    // add partial row
    if (numberOfItems % numberOfColumns) {
        ++rows;
    }

    return rows;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *defaultIdentifier = @"KSGridViewCell";

    // LEGACY: default identifier (mandatory method instead)
    NSString *identifier = nil;
    if ([dataSource respondsToSelector:@selector(identifierForGridView:)]) {
        identifier = [dataSource identifierForGridView:self];
    } else {
        identifier = defaultIdentifier;
    }

    // data source size
    const NSUInteger numberOfItems = [dataSource numberOfItemsInGridView:self];
    const NSUInteger numberOfColumns = [dataSource numberOfColumnsInGridView:self];
    const NSUInteger numberOfRows = [self tableView:tableView numberOfRowsInSection:0];

    KSGridViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[KSGridViewCell alloc] initWithReuseIdentifier:identifier] autorelease];
        cell.delegate = self;

        // fixed item size
        cell.itemSize = [dataSource sizeForItemInGridView:self];
    }

    // set current row and number of columns
    cell.row = indexPath.row;
    cell.numberOfColumns = numberOfColumns;

    // remark number of visible items (different for last row)
    NSUInteger numberOfVisibleItems = 0;
    if (cell.row < numberOfRows - 1) {
        numberOfVisibleItems = numberOfColumns;
    } else {
        numberOfVisibleItems = numberOfItems - (numberOfRows - 1) * numberOfColumns;
    }

    // fill item content
    for (NSUInteger i = 0; i < numberOfVisibleItems; ++i) {
        UIView *itemView = [cell itemAtIndex:i];

        // provide compound index to data source
        KSGridViewIndex *index = [KSGridViewIndex indexWithCell:cell column:i];
        [dataSource gridView:self setDataForItemView:itemView atIndex:index];
    }

    // save visible items count
    cell.numberOfVisibleItems = numberOfVisibleItems;

    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([dataSource respondsToSelector:@selector(heightForRowInGridView:)]) {
        return [dataSource heightForRowInGridView:self];
    } else {
        return [dataSource sizeForItemInGridView:self].height;
    }
}

#pragma mark - KSGridViewCellDelegate

- (UIView *) gridViewCell:(KSGridViewCell *)cell viewForItemInRect:(CGRect)rect
{
    if ([dataSource respondsToSelector:@selector(gridView:viewForItemInRect:)]) {
        return [dataSource gridView:self viewForItemInRect:rect];
    } else {
        return [dataSource viewForItemInGridView:self];
    }
}

- (void) gridViewCell:(KSGridViewCell *)cell didSelectItemIndex:(NSInteger)itemIndex
{
    KSGridViewIndex *index = [KSGridViewIndex indexWithCell:cell column:itemIndex];
    [delegate gridView:self didSelectIndex:index];
}

@end
