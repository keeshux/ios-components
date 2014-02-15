/*
 * NSFileManager+UserDirectories.m
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

#import "NSFileManager+UserDirectories.h"

@implementation NSFileManager (UserDirectories)

- (NSString *)pathForUserDocuments
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)pathForUserDocumentFile:(NSString *)file
{
    return [[self pathForUserDocuments] stringByAppendingPathComponent:file];
}

- (NSString *)pathForUserCaches
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

- (NSString *)pathForUserCacheFile:(NSString *)file
{
    return [[self pathForUserCaches] stringByAppendingPathComponent:file];
}

@end
