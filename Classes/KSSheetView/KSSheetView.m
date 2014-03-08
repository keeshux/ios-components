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

#import "KSSheetView.h"

@implementation KSSheetView

@synthesize cellSize;
@synthesize offset;
@synthesize lineWidth;

@synthesize gridWidth;
@synthesize gridHeight;

@synthesize delegate;

#pragma mark - init/dealloc

- (id) initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        paperColor = CGColorCreateCopy([UIColor colorWithRed:0.93
                                                       green:0.93
                                                        blue:0.93
                                                       alpha:1.0].CGColor);
        lineColor = CGColorCreateCopy([UIColor colorWithRed:0.48
                                                      green:0.73
                                                       blue:0.96
                                                      alpha:1.0].CGColor);

        // default
        self.cellSize = frame.size.width / 12;
        self.offset = CGPointMake((frame.size.width - cellSize * gridWidth) / 2,
                                  (frame.size.height - cellSize * gridHeight) / 2);
        self.lineWidth = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 2.0 : 1.0);
    }
    return self;
}

- (void) dealloc
{
    CGColorRelease(paperColor);
    CGColorRelease(lineColor);
    
    [super ah_dealloc];
}

- (void) setCellSize:(NSUInteger)aCellSize
{
    cellSize = aCellSize;

    // dependent ivars
    gridWidth = self.frame.size.width / cellSize;
    gridHeight = self.frame.size.height / cellSize;
}

#pragma mark - Draw loop

- (void) drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // paper color
    CGContextSetFillColorWithColor(context, paperColor);
    CGContextFillRect(context, rect);

    // grid color
    CGContextSetStrokeColorWithColor(context, lineColor);
    CGContextSetLineWidth(context, lineWidth);

    CGPoint delta;

    // horizontal lines
    delta.y = offset.y;
    while (delta.y < rect.size.height) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, rect.origin.x, rect.origin.y + delta.y);
        CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + delta.y);
        CGContextStrokePath(context);

        delta.y += cellSize;
    }

    // vertical lines
    delta.x = offset.x;
    while (delta.x < rect.size.width) {
        CGContextBeginPath(context);
        CGContextMoveToPoint(context, rect.origin.x + delta.x, rect.origin.y);
        CGContextAddLineToPoint(context, rect.origin.x + delta.x, rect.origin.y + rect.size.height);
        CGContextStrokePath(context);
        
        delta.x += cellSize;
    }

    // delegate custom drawing
    [delegate drawInSheet:self inContext:context inRect:rect];
}

@end
