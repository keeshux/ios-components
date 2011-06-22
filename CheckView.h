//
//  CheckView.h
//
//  Created by Davide De Rosa on 6/14/11.
//  Copyright 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckView : UIView {
    CGFloat width;
    CGMutablePathRef path;

    BOOL enabled;
    UIColor *color;
}

@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, retain) UIColor *color;

@end
