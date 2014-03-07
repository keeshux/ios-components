/*
 * KSGridViewIndex.h
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

#import <Foundation/Foundation.h>
#import "ARCHelper.h"

@class KSGridViewCell;

@interface KSGridViewIndex : NSObject

@property (nonatomic, readonly) NSUInteger position;
@property (nonatomic, readonly) NSUInteger row;
@property (nonatomic, readonly) NSUInteger column;

+ (id) indexWithPosition:(NSUInteger)aPosition row:(NSUInteger)aRow column:(NSUInteger)aColumn;
+ (id) indexWithCell:(KSGridViewCell *)aCell column:(NSUInteger)aColumn;
- (id) initWithPosition:(NSUInteger)aPosition row:(NSUInteger)aRow column:(NSUInteger)aColumn;
- (id) initWithCell:(KSGridViewCell *)aCell column:(NSUInteger)aColumn;

@end
