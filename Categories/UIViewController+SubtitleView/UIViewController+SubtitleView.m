/*
 * UIViewController+SubtitleView.m
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

#import "UIViewController+SubtitleView.h"

@implementation UIViewController (SubtitleView)

- (void) setTitle:(NSString *)title subtitle:(NSString *)subtitle
{
    // standard title
    if (!subtitle) {
        self.title = title;
        return;
    }

#warning XXX: restart from scratch
    self.navigationItem.titleView = nil;

    BOOL created = NO;
    UIView *titleView = self.navigationItem.titleView;
    UILabel *labelTitle = nil;
    UILabel *labelSubtitle = nil;
    if (!titleView) {
        created = YES;
        
        titleView = [[UIView alloc] initWithFrame:CGRectZero];
        labelTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        labelSubtitle = [[UILabel alloc] initWithFrame:CGRectZero];
        
        labelTitle.backgroundColor = [UIColor clearColor];
        labelTitle.textAlignment = UITextAlignmentCenter;
        labelTitle.shadowColor = [UIColor darkGrayColor];
        labelTitle.textColor = [UIColor whiteColor];
        labelTitle.lineBreakMode = UILineBreakModeTailTruncation;
        labelSubtitle.backgroundColor = [UIColor clearColor];
        labelSubtitle.textAlignment = UITextAlignmentCenter;
        labelSubtitle.textColor = [UIColor whiteColor];
        labelSubtitle.shadowColor = [UIColor darkGrayColor];
        labelSubtitle.lineBreakMode = UILineBreakModeTailTruncation;
        labelTitle.font = [UIFont boldSystemFontOfSize:18];
        labelSubtitle.font = [UIFont systemFontOfSize:14];
        
        [titleView addSubview:labelTitle];
        [titleView addSubview:labelSubtitle];
        
//        titleView.backgroundColor = [UIColor greenColor];
//        labelTitle.backgroundColor = [UIColor orangeColor];
//        labelSubtitle.backgroundColor = [UIColor orangeColor];
        
        [titleView autorelease];
        [labelTitle autorelease];
        [labelSubtitle autorelease];
    }
    
    labelTitle.text = title;
    labelSubtitle.text = subtitle;
    [labelTitle sizeToFit];
    [labelSubtitle sizeToFit];
    
    titleView.frame = CGRectMake(0,
                                 0,
                                 MAX(labelTitle.bounds.size.width, labelSubtitle.bounds.size.width),
                                 self.navigationController.navigationBar.bounds.size.height);
    
    labelTitle.center = CGPointMake(titleView.bounds.size.width / 2, 15);
    labelSubtitle.center = CGPointMake(titleView.bounds.size.width / 2, 31);    
    labelTitle.frame = CGRectIntegral(labelTitle.frame);
    labelSubtitle.frame = CGRectIntegral(labelSubtitle.frame);
    
    titleView.autoresizesSubviews = YES;
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    labelTitle.autoresizingMask = titleView.autoresizingMask;
    labelSubtitle.autoresizingMask = titleView.autoresizingMask;
    
//    DDLog(@"titleView.frame = %@", NSStringFromCGRect(titleView.frame));
//    DDLog(@"labelTitle.frame = %@", NSStringFromCGRect(labelTitle.frame));
//    DDLog(@"labelSubtitle.frame = %@", NSStringFromCGRect(labelSubtitle.frame));
    
    if (created) {
        self.navigationItem.titleView = titleView;
    }
}

- (void) setTitle2:(NSString *)title subtitle:(NSString *)subtitle
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectZero];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    UILabel *subtitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    
    // Set font for sizing width
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.shadowColor = [UIColor darkGrayColor];
    subtitleLabel.font = [UIFont systemFontOfSize:14];
    subtitleLabel.shadowColor = [UIColor darkGrayColor];
    
    // Set the width of the views according to the text size
    CGFloat titleDesiredWidth = [title sizeWithFont:titleLabel.font
                                  constrainedToSize:CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, titleLabel.frame.size.height)
                                      lineBreakMode:UILineBreakModeCharacterWrap].width;
    CGFloat subtitleDesiredWidth = [subtitle sizeWithFont:subtitleLabel.font
                                        constrainedToSize:CGSizeMake([[UIScreen mainScreen] applicationFrame].size.width, subtitleLabel.frame.size.height)
                                            lineBreakMode:UILineBreakModeCharacterWrap].width;
    
    CGRect frame;
    
    frame = titleLabel.frame;
    frame.size.height = 20;
    frame.size.width = titleDesiredWidth;
    titleLabel.frame = frame;
    
    frame = subtitleLabel.frame;
    frame.size.height = 20;
    frame.size.width = subtitleDesiredWidth;
    subtitleLabel.frame = frame;
    
    frame = titleView.frame;
    frame.size.height = 44;
    frame.size.width = MAX(titleDesiredWidth, subtitleDesiredWidth);
    titleView.frame = frame;
    
    // Ensure text is on one line, centered and truncates if the bounds are restricted
    titleLabel.numberOfLines = 1;
    titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    titleLabel.textAlignment = UITextAlignmentCenter;
    
    // Use autoresizing to restrict the bounds to the area that the titleview allows
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    subtitleLabel.autoresizingMask = titleView.autoresizingMask;
    
    // Set the text
    titleLabel.text = title;
    subtitleLabel.text = subtitle;
    
    // Add as the nav bar's titleview
    [titleView addSubview:titleLabel];
    [titleView addSubview:subtitleLabel];
    self.navigationItem.titleView = titleView;
}

@end
