/*
 * NSString+Digest.m
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

#import "NSString+Digest.h"

@implementation NSString (Digest)

- (NSString *) digestByMD5
{
    const char *stringBytes = [self UTF8String];
    unsigned char digestBytes[CC_MD5_DIGEST_LENGTH];

    // check failure
    if (!CC_MD5(stringBytes, strlen(stringBytes), digestBytes)) {
        return nil;
    }
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [digest appendFormat:@"%02x", digestBytes[i]];
    }
    
    return [digest lowercaseString];
}

- (NSString *) digestBySHA1
{
    const char *stringBytes = [self UTF8String];
    unsigned char digestBytes[CC_SHA1_DIGEST_LENGTH];
    
    // check failure
    if (!CC_SHA1(stringBytes, strlen(stringBytes), digestBytes)) {
        return nil;
    }
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:(CC_SHA1_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i) {
        [digest appendFormat:@"%02x", digestBytes[i]];
    }
    
    return [digest lowercaseString];
}

@end
