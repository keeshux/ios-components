/*
 * KSGridView.m
 *
 * Copyright 2012 Davide De Rosa
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
