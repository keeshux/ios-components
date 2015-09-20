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

@interface KSCheckView ()

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, unsafe_unretained) CGMutablePathRef path;

@end

@implementation KSCheckView

- (instancetype)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.width = self.frame.size.width / 8.0;

        self.path = CGPathCreateMutable();
        CGPathMoveToPoint(self.path, NULL, self.width, self.frame.size.height / 2);
        CGPathAddLineToPoint(self.path, NULL, self.frame.size.width * 0.4, self.frame.size.height - self.width);
        CGPathAddLineToPoint(self.path, NULL, self.frame.size.width - self.width, self.width);

        self.backgroundColor = [UIColor whiteColor];
        self.color = [UIColor blackColor];

        // toggle action
        [self addTarget:self action:@selector(toggleChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc
{
    CGPathRelease(self.path);
}

- (void)setChecked:(BOOL)checked
{
    if (_checked == checked) {
        return;
    }

    _checked = checked;
    [self setNeedsDisplay];

    [self.delegate checkView:self didChangeToChecked:_checked];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // background
    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
    CGContextFillRect(context, rect);

    // check mark
    if (self.checked) {
        CGContextSetStrokeColorWithColor(context, self.color.CGColor);
        CGContextSetShouldAntialias(context, YES);
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, self.width);

        CGContextBeginPath(context);
        CGContextAddPath(context, self.path);
        CGContextStrokePath(context);
    }
}

- (void)toggleChecked
{
    self.checked = !self.checked;
}

@end
