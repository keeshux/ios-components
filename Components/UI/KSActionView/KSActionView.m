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
                                                                       style:UIBarButtonItemStylePlain
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
