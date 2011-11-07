/*
 * KSAdvancedPicker.h
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

#import <UIKit/UIKit.h>

@protocol KSAdvancedPickerDelegate;

@interface KSAdvancedPicker : UIView<UITableViewDataSource, UITableViewDelegate> {
}

@property (nonatomic, readonly) UITableView *table;
@property (nonatomic, readonly) NSInteger selectedRowIndex;
@property (nonatomic, assign) id<KSAdvancedPickerDelegate> delegate;

- (id) initWithFrame:(CGRect)frame delegate:(id<KSAdvancedPickerDelegate>)aDelegate;

- (void) scrollToRowAtIndex:(NSInteger)rowIndex animated:(BOOL)animated;
- (void) reloadData;

@end

@protocol KSAdvancedPickerDelegate<NSObject>

// row view
- (NSInteger) numberOfRowsInAdvancedPicker:(KSAdvancedPicker *)picker;
- (UITableViewCell *) advancedPicker:(KSAdvancedPicker *)picker tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)rowIndex;

@optional

// row height
- (CGFloat) heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker;

// selected row
- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRowAtIndex:(NSInteger)rowIndex;

// table background view (checked in the same order)
- (UIView *) backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker;
- (UIColor *) backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker;

// selector view (checked in the same order)
- (UIView *) viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

@end
