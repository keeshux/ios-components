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

#import <UIKit/UIKit.h>
#import "ARCHelper.h"

@protocol KSAdvancedPickerDataSource;
@protocol KSAdvancedPickerDelegate;

@interface KSAdvancedPicker : UIView <UITableViewDataSource, UITableViewDelegate> {
    CGFloat rowHeight;
    CGFloat centralRowOffset;
}

@property (nonatomic, ah_weak) id<KSAdvancedPickerDataSource> dataSource;
@property (nonatomic, ah_weak) id<KSAdvancedPickerDelegate> delegate;

- (UITableView *) tableViewForComponent:(NSInteger)component;
- (NSInteger) selectedRowInComponent:(NSInteger)component;
- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)animated;
- (void) reloadData;
- (void) reloadDataInComponent:(NSInteger)component;

@end

@protocol KSAdvancedPickerDataSource<NSObject>

// row view (multiple components)
- (NSInteger) numberOfComponentsInAdvancedPicker:(KSAdvancedPicker *)picker;
- (NSInteger) advancedPicker:(KSAdvancedPicker *)picker numberOfRowsInComponent:(NSInteger)component;

// content
- (UIView *) advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component inRect:(CGRect)rect;
- (void) advancedPicker:(KSAdvancedPicker *)picker setDataForView:(UIView *)view row:(NSInteger)row inComponent:(NSInteger)component;

@optional

- (UIView *) __attribute__((deprecated)) advancedPicker:(KSAdvancedPicker *)picker viewForComponent:(NSInteger)component;

// row height
- (CGFloat) heightForRowInAdvancedPicker:(KSAdvancedPicker *)picker;

// component width
- (CGFloat) advancedPicker:(KSAdvancedPicker *)picker widthForComponent:(NSInteger)component;

@end

@protocol KSAdvancedPickerDelegate<NSObject>

@optional

// selected row
- (void) advancedPicker:(KSAdvancedPicker *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void) advancedPicker:(KSAdvancedPicker *)picker didClickRow:(NSInteger)row inComponent:(NSInteger)component;

// picker background view (checked in the same order)
- (UIView *) backgroundViewForAdvancedPicker:(KSAdvancedPicker *)picker;
- (UIColor *) backgroundColorForAdvancedPicker:(KSAdvancedPicker *)picker;

// components background view (checked in the same order)
- (UIView *) advancedPicker:(KSAdvancedPicker *)picker backgroundViewForComponent:(NSInteger)component;
- (UIColor *) advancedPicker:(KSAdvancedPicker *)picker backgroundColorForComponent:(NSInteger)component;

// overlay view (checked in the same order)
- (UIView *) overlayViewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) overlayColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

// selector view (checked in the same order)
- (UIView *) viewForAdvancedPickerSelector:(KSAdvancedPicker *)picker;
- (UIColor *) viewColorForAdvancedPickerSelector:(KSAdvancedPicker *)picker;

@end
