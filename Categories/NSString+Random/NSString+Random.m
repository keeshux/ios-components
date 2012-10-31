/*
 * NSString+Random.m
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

#import "NSString+Random.h"

@implementation NSString (Random)

static NSString *const letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

+ (id) randomStringWithLength:(NSUInteger)length
{
    NSMutableString *randomString = [[NSMutableString alloc] initWithCapacity:length];

    for (NSUInteger i = 0; i < length; ++i) {
        [randomString appendFormat:@"%c", [letters characterAtIndex:(arc4random() % [letters length])]];
    }

    return [randomString autorelease];
}

@end
