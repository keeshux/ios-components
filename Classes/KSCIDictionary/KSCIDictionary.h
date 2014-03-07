/*
 * KSCIDictionary.h
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
- (id)objectForKey:(NSString *)aKey;
- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker;
- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)objectEnumerator;

- (NSArray *)allKeys;
- (NSArray *)allKeysForObject:(id)anObject;    
- (NSArray *)allValues;
- (BOOL)isEqualToCIDictionary:(KSCIDictionary *)otherDictionary;

- (NSDictionary *)backingDictionary;

@end

@interface KSCIMutableDictionary : KSCIDictionary

- (void)removeObjectForKey:(NSString *)aKey;
- (void)setObject:(id)anObject forKey:(NSString *)aKey;

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary;
- (void)removeAllObjects;
- (void)removeObjectsForKeys:(NSArray *)keyArray;
- (void)setDictionary:(NSDictionary *)otherDictionary;

+ (id)dictionaryWithCapacity:(NSUInteger)numItems;
- (id)initWithCapacity:(NSUInteger)numItems;

- (NSMutableDictionary *)backingMutableDictionary;

@end
