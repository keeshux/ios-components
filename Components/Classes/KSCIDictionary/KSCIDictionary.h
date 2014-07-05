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

#import <Foundation/Foundation.h>
#import "ARCHelper.h"

@interface KSCIDictionary : NSObject <NSCopying, NSMutableCopying, NSCoding>

+ (id)dictionary;
+ (id)dictionaryWithObject:(id)object forKey:(NSString *)key;
+ (id)dictionaryWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt;
+ (id)dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
+ (id)dictionaryWithDictionary:(NSDictionary *)dict;
+ (id)dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;

- (id)init;
- (id)initWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt;
- (id)initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION;
- (id)initWithDictionary:(NSDictionary *)otherDictionary;
- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag;
- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys;

+ (id)dictionaryWithContentsOfFile:(NSString *)path;
+ (id)dictionaryWithContentsOfURL:(NSURL *)url;
- (id)initWithContentsOfFile:(NSString *)path;
- (id)initWithContentsOfURL:(NSURL *)url;

- (NSUInteger)count;
- (id)objectForKey:(NSString *)key;
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker;
- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;

- (NSArray *)allKeys;
- (NSArray *)allKeysForObject:(id)object;
- (NSArray *)allValues;
- (BOOL)isEqualToCIDictionary:(KSCIDictionary *)otherDictionary;

- (NSDictionary *)backingDictionary;

@end

@interface KSCIMutableDictionary : KSCIDictionary

- (void)removeObjectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
- (void)setDictionary:(NSDictionary *)otherDictionary;

+ (id)dictionaryWithCapacity:(NSUInteger)numItems;
- (id)initWithCapacity:(NSUInteger)numItems;

- (NSMutableDictionary *)backingMutableDictionary;

@end
