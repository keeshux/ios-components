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

@interface KSAdvancedPicker : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, readonly) UITableView __attribute__((deprecated)) *table;
@property (nonatomic, readonly) NSInteger __attribute__((deprecated)) selectedRowIndex;
@property (nonatomic, assign) id<KSAdvancedPickerDelegate> delegate;

- (id) initWithFrame:(CGRect)frame delegate:(id<KSAdvancedPickerDelegate>)aDelegate;

- (UITableView *) tableViewForComponent:(NSInteger)component;
- (NSInteger) selectedRowIndexInComponent:(NSInteger)component;
- (void) scrollToRowAtIndex:(NSInteger)rowIndex inComponent:(NSInteger)component animated:(BOOL)animated;
- (void) __attribute__((deprecated)) scrollToRowAtIndex:(NSInteger)rowIndex animated:(BOOL)animated;
- (void) reloadData;
- (void) reloadDataInComponent:(NSInteger)component;

@end

@protocol KSAdvancedPickerDelegate<NSObject>

// row view (multiple components)
- (NSInteger) numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker;
- (NSInteger) advancedPicker:(KSAdvancedPicker *)picker numberOfRowsInComponent:(NSInteger)component;
- (UITableViewCell *) advancedPicker:(KSAdvancedPicker *)picker tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)rowIndex forComponent:(NSInteger)component;

@optional

// row view (single component)
- (NSInteger) __attribute__((deprecated)) numberOfRowsInAdvancedPicker:(KSAdvancedPicker *)picker;
- (UITableViewCell *) __attribute__((deprecated)) advancedPicker:(KSAdvancedPicker *)picker tableView:(UITableView *)tableView cellForRowAtIndex:(NSInteger)rowIndex;

// row height
- (CGFloat) heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker;

// component width
- (CGFloat) advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component;

// selected row
- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRowAtIndex:(NSInteger)rowIndex inComponent:(NSInteger)component;
- (void) advancedPicker:(KSAdvancedPicker *)picker didClickRowAtIndex:(NSInteger)rowIndex inComponent:(NSInteger)component;
- (void) __attribute__((deprecated)) advancedPicker:(KSAdvancedPicker *)picker didSelectRowAtIndex:(NSInteger)rowIndex;
- (void) __attribute__((deprecated)) advancedPicker:(KSAdvancedPicker *)picker didClickRowAtIndex:(NSInteger)rowIndex;

// picker background view (checked in the same order)
- (UIView *) backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker;
- (UIColor *) backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker;

// components background view (checked in the same order)
- (UIView *) advancedPicker:(KSAdvancedPicker *)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *) advancedPicker:(KSAdvancedPicker *)picker backgroundColorForComponent:(NSInteger)component;

// selector view (checked in the same order)
- (UIView *) viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

@end
