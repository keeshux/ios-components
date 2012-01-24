/*
 * KSKeyboardScroller.m
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

#import "KSKeyboardScroller.h"

@implementation KSKeyboardScroller

@synthesize mainView;
@synthesize activeView;
@synthesize scrollView;

+ (id) scrollerWithMainView:(UIView *)aMainView
{
    return [[[self alloc] initWithMainView:aMainView] autorelease];
}

- (id) initWithMainView:(UIView *)aMainView
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        
        self.mainView = aMainView;
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [scrollView release];
    
    [super dealloc];
}

- (void) setMainView:(UIView *)aMainView
{
    // unwrap previous
    if (scrollView) {
        
        // replace parent in subviews
        for (UIView *subview in scrollView.subviews) {
            [subview retain];
            [subview removeFromSuperview];
            [mainView addSubview:subview];
            [subview release];
        }
        
        // detach from main view
        [scrollView removeFromSuperview];
        [scrollView release];
        scrollView = nil;
    }
    
    mainView = aMainView;
    
    // might be nil
    if (mainView) {
        
        // wrap into scroll view
        scrollView = [[UIScrollView alloc] initWithFrame:mainView.bounds];
        scrollView.contentSize = mainView.bounds.size;
        
        // replace parent in subviews
        for (UIView *subview in mainView.subviews) {
            [subview retain];
            [subview removeFromSuperview];
            [scrollView addSubview:subview];
            [subview release];
        }
        
        // attach to main view
        [mainView addSubview:scrollView];
    }
}

- (void) keyboardWasShown:(NSNotification *)notification
{
    if (!scrollView || !activeView) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    const CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    scrollView.contentInset = UIEdgeInsetsMake(0, 0, keyboardSize.height, 0);
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
    
    // consider keyboard coverage
    CGRect visibleFrame = mainView.frame;
    visibleFrame.size.height -= keyboardSize.height;
    
    // absolute control origin
    CGPoint origin = activeView.frame.origin;
    UIView *parent = activeView.superview;
    while (parent) {
        origin.y += parent.frame.origin.y;
        parent = parent.superview;
    }
    
    // subtract scroll view offset
    origin.y -= scrollView.contentOffset.y;
    
    if (!CGRectContainsPoint(visibleFrame, origin)) {
        const CGPoint offset = CGPointMake(0, origin.y - visibleFrame.size.height);
        [scrollView setContentOffset:offset animated:YES];
    }
}

- (void) keyboardWillBeHidden:(NSNotification *)notification
{
    if (!scrollView || !activeView) {
        return;
    }
    
    scrollView.contentInset = UIEdgeInsetsZero;
    scrollView.scrollIndicatorInsets = scrollView.contentInset;
}

@end
