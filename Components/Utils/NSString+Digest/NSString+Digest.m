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

#import "NSString+Digest.h"

@implementation NSString (Digest)

- (NSString *)digestByMD5
{
    const char *stringBytes = [self UTF8String];
    unsigned char digestBytes[CC_MD5_DIGEST_LENGTH];

    // check failure
    if (!CC_MD5(stringBytes, (CC_LONG)strlen(stringBytes), digestBytes)) {
        return nil;
    }
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:(CC_MD5_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; ++i) {
        [digest appendFormat:@"%02x", digestBytes[i]];
    }
    
    return [digest lowercaseString];
}

- (NSString *)digestBySHA1
{
    const char *stringBytes = [self UTF8String];
    unsigned char digestBytes[CC_SHA1_DIGEST_LENGTH];
    
    // check failure
    if (!CC_SHA1(stringBytes, (CC_LONG)strlen(stringBytes), digestBytes)) {
        return nil;
    }
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:(CC_SHA1_DIGEST_LENGTH * 2)];
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; ++i) {
        [digest appendFormat:@"%02x", digestBytes[i]];
    }
    
    return [digest lowercaseString];
}

@end
