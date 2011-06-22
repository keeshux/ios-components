//
//  CheckView.m
//
//  Created by Davide De Rosa on 6/14/11.
//  Copyright 2011 algoritmico. All rights reserved.
//

#import "CheckView.h"

@implementation CheckView

@synthesize enabled;
@synthesize color;

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        width = self.frame.size.width / 8.0;

        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, width, self.frame.size.height / 2);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width * 0.4, self.frame.size.height - width);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width - width, width);
    }
    return self;
}

- (void) dealloc
{
    CGPathRelease(path);
    [color release];

    [super dealloc];
}

- (void) setEnabled:(BOOL)aEnabled
{
    enabled = aEnabled;
    [self setNeedsDisplay];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);

    // check mark
    if (enabled) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, width);

        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

@end
