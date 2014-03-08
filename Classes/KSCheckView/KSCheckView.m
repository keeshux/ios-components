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

#import "KSCheckView.h"

@implementation KSCheckView

@synthesize checked;
@synthesize color;

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        width = self.frame.size.width / 8.0;

        path = CGPathCreateMutable();
        CGPathMoveToPoint(path, NULL, width, self.frame.size.height / 2);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width * 0.4, self.frame.size.height - width);
        CGPathAddLineToPoint(path, NULL, self.frame.size.width - width, width);

        self.backgroundColor = [UIColor whiteColor];
        self.color = [UIColor blackColor];

        // toggle action
        [self addTarget:self action:@selector(toggleChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) dealloc
{
    CGPathRelease(path);
    self.color = nil;

    [super ah_dealloc];
}

- (void) setChecked:(BOOL)aChecked
{
    // do nothing
    if (checked == aChecked) {
        return;
    }

    checked = aChecked;
    [self setNeedsDisplay];

    [delegate checkView:self didChangeToChecked:checked];
}

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);

    // check mark
    if (checked) {
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, width);

        CGContextBeginPath(context);
        CGContextAddPath(context, path);
        CGContextStrokePath(context);
    }
}

- (void) toggleChecked
{
    self.checked = !checked;
}

@end
