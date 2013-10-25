/*
 * NSArray+Varargs.m
 *
 * Copyright 2013 Davide De Rosa
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

#import "NSArray+Varargs.h"

@implementation NSArray (Varargs)

- (NSString *)stringWithFormat:(NSString *)format
{
    const NSUInteger count = [self count];
    char *args[count];
    
    NSUInteger i = 0;
    for (id item in self) {
        args[i] = (char *)CFBridgingRetain(item);
        ++i;
    }
    
    NSString *string = [[NSString alloc] initWithFormat:format arguments:(va_list)args];
    for (NSUInteger i = 0; i < count; ++i) {
        CFBridgingRelease(args[i]);
    }
    return [string autorelease];
}

@end
