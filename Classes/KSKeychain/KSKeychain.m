//
// KSKeychain.m
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

#import "KSKeychain.h"

@implementation KSKeychain

+ (void)setData:(NSData *)object forKey:(NSString *)key
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
	[dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[dict setObject:key forKey:(__bridge id)kSecAttrService];
	
	SecItemDelete((__bridge CFDictionaryRef)dict);
    
	if (object) {
		[dict setObject:object forKey:(__bridge id)kSecValueData];
		SecItemAdd((__bridge CFDictionaryRef)dict, NULL);
	}
}

+ (NSData *)dataForKey:(NSString *)key
{
	NSMutableDictionary *query = [NSMutableDictionary dictionary];

	[query setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[query setObject:key forKey:(__bridge id)kSecAttrService];
	[query setObject:(id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
	CFTypeRef result = nil;
	SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
	if (!result) {
		return nil;
    }
    
	return (__bridge NSData *)result;
}

+ (void)setString:(NSString *)object forKey:(NSString *)key
{
	[self setData:[object dataUsingEncoding:NSUTF8StringEncoding] forKey:key];
}

+ (NSString *)stringForKey:(NSString *)key
{
	NSData* data = [self dataForKey:key];
	if (!data) {
		return nil;
    }
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

+ (void)removeKey:(NSString *)key
{
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
	[dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
	[dict setObject:key forKey:(__bridge id)kSecAttrService];
	
	SecItemDelete((__bridge CFDictionaryRef)dict);
}

@end
