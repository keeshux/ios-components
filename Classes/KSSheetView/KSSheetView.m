/*
 * KSSheetView.m
 *
 * Copyright 2011 Davide De Rosa
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
