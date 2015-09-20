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

+ (instancetype)indexWithPosition:(NSUInteger)position row:(NSUInteger)row column:(NSUInteger)column
{
    return [[self alloc] initWithPosition:position row:row column:column];
}

+ (instancetype)indexWithCell:(KSGridViewCell *)cell column:(NSUInteger)column
{
    return [[self alloc] initWithCell:cell column:column];
}

- (instancetype)initWithPosition:(NSUInteger)position row:(NSUInteger)row column:(NSUInteger)column
{
    if ((self = [super init])) {
        _position = position;
        _row = row;
        _column = column;
    }
    return self;
}

- (instancetype)initWithCell:(KSGridViewCell *)cell column:(NSUInteger)column
{
    const NSInteger position = cell.row * cell.numberOfColumns + column;
    
    return [self initWithPosition:position row:cell.row column:column];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"{position:%lu, row:%lu, column:%lu}",
            (unsigned long)self.position, (unsigned long)self.row, (unsigned long)self.column];
}

@end
