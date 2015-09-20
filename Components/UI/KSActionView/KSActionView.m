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
@property (nonatomic, assign) BOOL hidden;

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
        self.hidden = YES;

        self.statusBarOverlay = [[UIWindow alloc] initWithFrame:CGRectZero];
        self.statusBarOverlay.frame = [[UIApplication sharedApplication] statusBarFrame];
        self.statusBarOverlay.windowLevel = UIWindowLevelStatusBar + 1.0;
        self.statusBarOverlay.backgroundColor = [UIColor blackColor];
        self.statusBarOverlay.alpha = 0.0;
        self.statusBarOverlay.hidden = YES;
    }
    return self;
}

- (UIView *)actionView
{
    // lazy
    if (!_actionView) {
        _actionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 260)];
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        UIBarButtonItem *itemCancel = [[UIBarButtonItem alloc] initWithTitle:self.itemCancelString
                                                                       style:UIBarButtonItemStylePlain
                                                                      target:self
                                                                      action:@selector(cancelClicked:)];
        UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                   target:nil
                                                                                   action:nil];
        UIBarButtonItem *itemDone = [[UIBarButtonItem alloc] initWithTitle:self.itemDoneString
                                                                     style:UIBarButtonItemStyleDone
                                                                    target:self
                                                                    action:@selector(doneClicked:)];
        [items addObject:itemCancel];
        [items addObject:itemSpace];
        [items addObject:itemDone];
        
        UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
        bar.barStyle = UIBarStyleBlackTranslucent;
        bar.items = items;
        
        [_actionView addSubview:bar];
    }
    return _actionView;
}

- (void)setInputView:(UIView *)inputView
{
    [_inputView removeFromSuperview];

    _inputView = inputView;
    _inputView.frame = CGRectMake(0, 44, _inputView.frame.size.width, _inputView.frame.size.height);
    [self.actionView addSubview:_inputView];
}

- (void)show
{
    if (!self.hidden) {
        return;
    }

    [self.delegate actionViewWillShow:self];

    // make modal, touch outside to dismiss (popover like)
    self.overlayView = [[UIControl alloc] initWithFrame:_window.bounds];
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.alpha = 0.0;
    self.statusBarOverlay.alpha = 0.0;
    self.statusBarOverlay.hidden = NO;
    [self.overlayView addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.window addSubview:self.overlayView];

    // slide up (lazy creation with self)
    self.actionView.frame = CGRectOffset(self.actionView.bounds, 0, self.window.bounds.size.height);
    [self.window addSubview:self.actionView];
    [UIView animateWithDuration:KSActionViewAnimationDuration animations:^{
        self.actionView.frame = CGRectOffset(self.actionView.frame, 0, -self.actionView.bounds.size.height);
        self.overlayView.alpha = KSActionViewOverlayAlpha;
        self.statusBarOverlay.alpha = KSActionViewOverlayAlpha;
        self.hidden = NO;

        [self.delegate actionViewDidShow:self];
    }];
}

- (void)dismiss
{
    if (self.hidden) {
        return;
    }

    [self.delegate actionViewWillDismiss:self];

    // slide down
    [UIView animateWithDuration:KSActionViewAnimationDuration animations:^{
        self.actionView.frame = CGRectOffset(self.actionView.frame, 0, self.actionView.bounds.size.height);
        self.overlayView.alpha = 0.0;
        self.statusBarOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.actionView removeFromSuperview];
        [self.overlayView removeFromSuperview];

        self.actionView = nil;
        self.statusBarOverlay.hidden = YES;
        self.overlayView = nil;
        self.inputView = nil;
        self.delegate = nil;
        self.hidden = YES;

        [self.delegate actionViewDidDismiss:self];
    }];
}

- (void)doneClicked:(id)sender
{
    [self.delegate actionView:self didClickDone:YES];
}

- (void)cancelClicked:(id)sender
{
    [self.delegate actionView:self didClickDone:NO];
}

@end
