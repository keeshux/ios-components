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

#import "KSGridViewIndex.h"
#import "KSGridViewCell.h"

@implementation KSGridViewIndex

@synthesize position;
@synthesize row;
@synthesize column;

+ (id) indexWithPosition:(NSUInteger)aPosition row:(NSUInteger)aRow column:(NSUInteger)aColumn
{
    return [[[self alloc] initWithPosition:aPosition row:aRow column:aColumn] autorelease];
}

+ (id) indexWithCell:(KSGridViewCell *)aCell column:(NSUInteger)aColumn
{
    return [[[self alloc] initWithCell:aCell column:aColumn] autorelease];
}

- (id) initWithPosition:(NSUInteger)aPosition row:(NSUInteger)aRow column:(NSUInteger)aColumn
{
    if ((self = [super init])) {
        position = aPosition;
        row = aRow;
        column = aColumn;
    }
    return self;
}

- (id) initWithCell:(KSGridViewCell *)aCell column:(NSUInteger)aColumn
{
    const NSInteger aPosition = aCell.row * aCell.numberOfColumns + aColumn;
    
    return [self initWithPosition:aPosition row:aCell.row column:aColumn];
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"{position:%d, row:%d, column:%d}", position, row, column];
}

@end
