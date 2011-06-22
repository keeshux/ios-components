//
//  SheetView.h
//
//  Created by Davide De Rosa on 6/6/11.
//  Copyright 2011 algoritmico. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SheetContentDelegate;

@interface SheetView : UIView {
    NSUInteger cellSize;
    CGPoint offset;
    CGFloat lineWidth;

    // derived from cellSize
    NSUInteger gridWidth;
    NSUInteger gridHeight;

    CGColorRef paperColor;
    CGColorRef lineColor;

    // custom drawing
    id<SheetContentDelegate> contentDelegate;
}

@property (nonatomic, assign) NSUInteger cellSize;
@property (nonatomic, assign) CGPoint offset;
@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, readonly) NSUInteger gridWidth;
@property (nonatomic, readonly) NSUInteger gridHeight;

@property (nonatomic, assign) id contentDelegate;

@end

@protocol SheetContentDelegate

- (void) drawInView:(SheetView *)sheetView inContext:(CGContextRef)context inRect:(CGRect)rect;

@end
