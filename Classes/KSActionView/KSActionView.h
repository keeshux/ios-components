/*
 * KSActionView.h
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

#import <Foundation/Foundation.h>
#import "ARCHelper.h"

@protocol KSActionViewDelegate;

@interface KSActionView : NSObject

@property (nonatomic, assign) UIWindow *window;
@property (nonatomic, strong) UIView *inputView;
@property (nonatomic, readonly) BOOL hidden;
@property (nonatomic, assign) id<KSActionViewDelegate> delegate;

@property (nonatomic, copy) NSString *itemCancelString;
@property (nonatomic, copy) NSString *itemDoneString;

+ (KSActionView *)sharedInstance;

- (void)show;
- (void)dismiss;

@end

@protocol KSActionViewDelegate <NSObject>

- (void)actionViewWillShow:(KSActionView *)actionView;
- (void)actionViewDidShow:(KSActionView *)actionView;
- (void)actionView:(KSActionView *)actionView didClickDone:(BOOL)done;
- (void)actionViewWillDismiss:(KSActionView *)actionView;
- (void)actionViewDidDismiss:(KSActionView *)actionView;

@end
