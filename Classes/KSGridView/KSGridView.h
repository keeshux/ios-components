/*
 * KSGridView.h
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
#import "KSGridViewCell.h"
#import "KSGridViewIndex.h"

@protocol KSGridViewDataSource;
@protocol KSGridViewDelegate;

@interface KSGridView : UIView<UITableViewDataSource, UITableViewDelegate, KSGridViewCellDelegate>

@property (nonatomic, ah_weak) id<KSGridViewDataSource> dataSource;
@property (nonatomic, ah_weak) id<KSGridViewDelegate> delegate;

- (void) reloadData;

@end

@protocol KSGridViewDataSource<NSObject>

- (NSString *) identifierForGridView:(KSGridView *)gridView;

- (NSInteger) numberOfItemsInGridView:(KSGridView *)gridView;
- (NSInteger) numberOfColumnsInGridView:(KSGridView *)gridView;

- (CGSize) sizeForItemInGridView:(KSGridView *)gridView;
- (UIView *) gridView:(KSGridView *)gridView viewForItemInRect:(CGRect)rect;

- (void) gridView:(KSGridView *)gridView setDataForItemView:(UIView *)itemView atIndex:(KSGridViewIndex *)index;

@optional

- (UIView *) __attribute__((deprecated)) viewForItemInGridView:(KSGridView *)gridView;

// defaults to .height from sizeForItemInGridView:
- (CGFloat) heightForRowInGridView:(KSGridView *)gridView;

@end

@protocol KSGridViewDelegate<NSObject>

- (void) gridView:(KSGridView *)gridView didSelectIndex:(KSGridViewIndex *)index;

@end
