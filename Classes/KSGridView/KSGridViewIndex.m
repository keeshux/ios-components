/*
 * KSGridViewIndex.m
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
