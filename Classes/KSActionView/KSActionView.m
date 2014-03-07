/*
 * KSActionView.m
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

#import "KSActionView.h"

#define KSActionViewAnimationDuration   0.7
#define KSActionViewOverlayAlpha        0.6

@interface KSActionView ()

@property (nonatomic, strong) UIView *actionView;
@property (nonatomic, strong) UIWindow *statusBarOverlay;
@property (nonatomic, strong) UIControl *overlayView;

@end

@implementation KSActionView

+ (KSActionView *)sharedInstance
{
    static KSActionView *instance = nil;
    if (!instance) {
        instance = [[self alloc] init];
    }
    return instance;
}

- (id)init
{
    if ((self = [super init])) {
        _hidden = YES;

        _statusBarOverlay = [[UIWindow alloc] initWithFrame:CGRectZero];
        _statusBarOverlay.frame = [[UIApplication sharedApplication] statusBarFrame];
        _statusBarOverlay.windowLevel = UIWindowLevelStatusBar + 1.0;
        _statusBarOverlay.backgroundColor = [UIColor blackColor];
        _statusBarOverlay.alpha = 0.0;
        _statusBarOverlay.hidden = YES;
    }
    return self;
}

- (void)dealloc
{
    self.actionView = nil;
    self.statusBarOverlay = nil;
    self.overlayView = nil;
    self.inputView = nil;

    self.itemCancelString = nil;
    self.itemDoneString = nil;

    [super ah_dealloc];
}

- (UIView *)actionView
{
    // lazy
    if (!_actionView) {
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:_itemCancelString
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(cancelClicked:)];
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:_itemDoneString
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(doneClicked:)];
        [items addObject:itemCancel];
        [items addObject:itemSpace];
        [items addObject:itemDone];
        [itemCancel release];
        [itemSpace release];
        [itemDone release];
        
        UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        bar.barStyle = UIBarStyleBlackTranslucent;
        bar.items = items;
        [items release];
        
        [_actionView addSubview:bar];
        [bar release];
    }
    return _actionView;
}

- (void)setSelectorView:(UIView *)aSelectorView
{
    [_inputView removeFromSuperview];
    [_inputView release];

    _inputView = [aSelectorView ah_retain];
    _inputView.frame = CGRectMake(0, 44, _inputView.frame.size.width, _inputView.frame.size.height);
    [self.actionView addSubview:_inputView];
}

- (void)show
{
    if (!_hidden) {
        return;
    }

    [_delegate actionViewWillShow:self];

    // make modal, touch outside to dismiss (popover like)
    _overlayView = [[UIControl alloc] initWithFrame:_window.bounds];
    _overlayView.backgroundColor = [UIColor blackColor];
    _overlayView.alpha = 0.0;
    _statusBarOverlay.alpha = 0.0;
    _statusBarOverlay.hidden = NO;
    [_overlayView addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_window addSubview:_overlayView];

    // slide up (lazy creation with self)
    self.actionView.frame = CGRectOffset(_actionView.bounds, 0, _window.bounds.size.height);
    [_window addSubview:_actionView];
    [UIView animateWithDuration:KSActionViewAnimationDuration animations:^{
        _actionView.frame = CGRectOffset(_actionView.frame, 0, -_actionView.bounds.size.height);
        _overlayView.alpha = KSActionViewOverlayAlpha;
        _statusBarOverlay.alpha = KSActionViewOverlayAlpha;
        _hidden = NO;

        [_delegate actionViewDidShow:self];
    }];
}

- (void)dismiss
{
    if (_hidden) {
        return;
    }

    [_delegate actionViewWillDismiss:self];

    // slide down
    [UIView animateWithDuration:KSActionViewAnimationDuration animations:^{
        _actionView.frame = CGRectOffset(_actionView.frame, 0, _actionView.bounds.size.height);
        _overlayView.alpha = 0.0;
        _statusBarOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [_actionView removeFromSuperview];
        [_overlayView removeFromSuperview];

        self.actionView = nil;
        _statusBarOverlay.hidden = YES;
        self.overlayView = nil;
        self.inputView = nil;
        self.delegate = nil;
        _hidden = YES;

        [_delegate actionViewDidDismiss:self];
    }];
}

- (void)doneClicked:(id)sender
{
    [_delegate actionView:self didClickDone:YES];
}

- (void)cancelClicked:(id)sender
{
    [_delegate actionView:self didClickDone:NO];
}

@end
