/*
 * UIWebView+Activity.h
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

#import "UIWebView+Activity.h"

static const NSInteger UIWebViewActivityTag = 17000;

@implementation UIWebView (Activity)

- (void)configureForLoading
{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:UIWebViewActivityTag];
    if (activity) {
        return;
    }
    
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activity.tag = UIWebViewActivityTag;
//    activity.center = self.center;
    activity.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    activity.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:activity];
    [activity release];
}

- (BOOL)isLoading
{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:UIWebViewActivityTag];
    
    return activity.isAnimating;
}

- (void)setIsLoading:(BOOL)isLoading
{
    UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[self viewWithTag:UIWebViewActivityTag];
    
    if (isLoading) {
        [activity startAnimating];
        activity.hidden = NO;
        [self bringSubviewToFront:activity];
    } else {
        activity.hidden = YES;
        [activity stopAnimating];
    }
}

@end
