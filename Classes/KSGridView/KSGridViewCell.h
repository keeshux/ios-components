/*
 * KSGridViewCell.h
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

#import <UIKit/UIKit.h>
#import "ARCHelper.h"

@protocol KSGridViewCellDelegate;

@interface KSGridViewCell : UITableViewCell {
    NSMutableArray *items;
}

@property (nonatomic, assign) NSUInteger row;
@property (nonatomic, assign) NSUInteger numberOfColumns;
@property (nonatomic, assign) NSUInteger numberOfVisibleItems;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, ah_weak) id<KSGridViewCellDelegate> delegate;

- (id) initWithReuseIdentifier:(NSString *)reuseIdentifier;

- (void) setNumberOfColumns:(NSUInteger)aNumberOfColumns removeExceedingItems:(BOOL)removeExceedingItems;
- (UIView *) itemAtIndex:(NSUInteger)index;

@end

@protocol KSGridViewCellDelegate

- (UIView *) gridViewCell:(KSGridViewCell *)cell viewForItemInRect:(CGRect)rect;
- (void) gridViewCell:(KSGridViewCell *)cell didSelectItemIndex:(NSInteger)itemIndex;

@end
