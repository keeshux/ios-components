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
