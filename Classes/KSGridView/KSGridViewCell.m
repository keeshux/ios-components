/*
 * KSGridViewCell.m
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

#import "KSGridViewCell.h"

@implementation KSGridViewCell

@synthesize row;
@synthesize numberOfColumns;
@synthesize numberOfVisibleItems;
@synthesize itemSize;
@synthesize delegate;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        items = [[NSMutableArray alloc] init];
        itemSize = CGSizeZero;
    }
    return self;
}

- (void) dealloc
{
    [items release];

    [super ah_dealloc];
}

- (void) setNumberOfColumns:(NSUInteger)aNumberOfColumns
{
    [self setNumberOfColumns:aNumberOfColumns removeExceedingItems:NO];
}

- (void) setNumberOfColumns:(NSUInteger)aNumberOfColumns removeExceedingItems:(BOOL)removeExceedingItems
{
    if (aNumberOfColumns == numberOfColumns) {
        return;
    }

    numberOfColumns = aNumberOfColumns;

    // append new items if necessary
    const NSInteger neededItems = numberOfColumns - [items count];
    if (neededItems > 0) {
        for (NSUInteger i = 0; i < neededItems; ++i) {
            UIView *itemView = [delegate gridViewCell:self viewForItemInRect:self.contentView.bounds];
            itemView.userInteractionEnabled = NO; // for touchesBegan
            [items addObject:itemView];

            // add to cell content
            [self.contentView addSubview:itemView];
        }
    }
    // optionally destroy unused items
    else if (removeExceedingItems && (neededItems < 0)) {
        for (NSUInteger i = 0; i < -neededItems; ++i) {
            UIView *itemView = [items lastObject];
            [itemView removeFromSuperview];
            [items removeLastObject];
        }
    }
    
    // cap visible items
    self.numberOfVisibleItems = MIN(numberOfColumns, numberOfVisibleItems);

    [self setNeedsLayout];
}

- (void) setNumberOfVisibleItems:(NSUInteger)aNumberOfVisibleItems
{
    NSAssert2(aNumberOfVisibleItems <= numberOfColumns,
              @"numberOfVisibleItems must be <= numberOfColumns (%d > %d)",
              aNumberOfVisibleItems, numberOfColumns);

    numberOfVisibleItems = aNumberOfVisibleItems;

    NSUInteger i = 0;
    for (UIView *itemView in items) {
        itemView.hidden = (i >= numberOfVisibleItems);
        ++i;
    }
}

- (UIView *) itemAtIndex:(NSUInteger)index
{
    return [items objectAtIndex:index];
}

#pragma mark - Layout

- (void) layoutSubviews
{
    CGSize paddedSize;
    paddedSize.width = (NSUInteger)(self.bounds.size.width / numberOfColumns);
    paddedSize.height = (NSUInteger) self.bounds.size.height;

    // fixed item size
    CGRect itemFrame = CGRectZero;
    itemFrame.size = itemSize;

    // size and center items
    NSUInteger i = 0;
    for (UIView *itemView in items) {
        itemView.frame = itemFrame;
        itemView.center = CGPointMake((i + 0.5) * paddedSize.width, 0.5 * paddedSize.height);

        ++i;
    }
}

#pragma mark - Events

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    const CGPoint location = [touch locationInView:self];

    // notify touched item
    NSUInteger i = 0;
    for (UIView *itemView in items) {
        if (!itemView.hidden && CGRectContainsPoint(itemView.frame, location)) {
            [delegate gridViewCell:self didSelectItemIndex:i];
            return;
        }
        ++i;
    }
}

@end
