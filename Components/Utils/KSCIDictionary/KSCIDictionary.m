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

#import "KSCIDictionary.h"

static inline NSString *KSCIDictionaryKey(NSString *key) {
    return [key lowercaseString];
}

static inline NSArray *KSCIDictionaryKeys(NSArray *keys) {
    NSMutableArray *ciKeys = [NSMutableArray arrayWithCapacity:[keys count]];
    for (NSString *key in keys) {
        [ciKeys addObject:KSCIDictionaryKey(key)];
    }
    return ciKeys;
}

static inline void KSCIDictionarySetObjectAndMapping(NSMutableDictionary *dictionary,
                                                     NSMutableDictionary *mapping,
                                                     id object,
                                                     NSString *key) {

    NSString *ciKey = KSCIDictionaryKey(key);
    NSString *originalKey = [mapping objectForKey:ciKey];

    if (!originalKey) {
        originalKey = key;
    }
    [mapping setObject:originalKey forKey:ciKey];
    [dictionary setObject:object forKey:originalKey];
}

@interface KSCIDictionary ()

@property (nonatomic, strong) NSMutableDictionary *backing;
@property (nonatomic, strong) NSMutableDictionary *mapping;

@end

@implementation KSCIDictionary

+ (instancetype)dictionary
{
    return [[self alloc] init];
}

+ (instancetype)dictionaryWithObject:(id)object forKey:(NSString *)key
{
    return [[self alloc] initWithObjectsAndKeys:object, key, nil];
}

+ (instancetype)dictionaryWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt
{
    return [[self alloc] initWithObjects:objects forKeys:keys count:cnt];
}

+ (instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    va_list args;
    va_start(args, firstObject);

    NSMutableDictionary *ciDictionary = [NSMutableDictionary dictionary];
    id object = firstObject;
    NSString *key = va_arg(args, NSString *);
    while (object && key) {
        [ciDictionary setObject:object forKey:key];
        
        object = va_arg(args, id);
        key = va_arg(args, NSString *);
    }
    va_end(args);

    return [[self alloc] initWithDictionary:ciDictionary];
}

+ (instancetype)dictionaryWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

+ (instancetype)dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    return [[self alloc] initWithObjects:objects forKeys:keys];
}

- (instancetype)init
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];
    }
    return self;
}

- (instancetype)initWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:cnt];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:cnt];

        for (NSUInteger i = 0; i < cnt; ++i) {
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, objects[i], keys[i]);
        }
    }
    return self;
}

- (instancetype)initWithObjectsAndKeys:(id)firstObject, ...
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];
        
        va_list args;
        va_start(args, firstObject);

        id object = firstObject;
        NSString *key = va_arg(args, NSString *);
        while (object && key) {
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);

            object = va_arg(args, id);
            key = va_arg(args, NSString *);
        }
        va_end(args);
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    return [self initWithDictionary:otherDictionary copyItems:NO];
}

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];

        for (NSString *key in [otherDictionary allKeys]) {
            id object = [otherDictionary objectForKey:key];
            if (flag) {
                object = [object copy];
            }
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
        }
    }
    return self;
}

- (instancetype)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];

        NSUInteger i = 0;
        for (NSString *key in keys) {
            id object = [objects objectAtIndex:i];
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
            ++i;
        }
    }
    return self;
}

+ (instancetype)dictionaryWithContentsOfFile:(NSString *)path
{
    return [[self alloc] initWithContentsOfFile:path];
}

+ (instancetype)dictionaryWithContentsOfURL:(NSURL *)url
{
    return [[self alloc] initWithContentsOfURL:url];
}

- (instancetype)initWithContentsOfFile:(NSString *)path
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
        }
    }
    return self;
}

- (instancetype)initWithContentsOfURL:(NSURL *)url
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
        }
    }
    return self;
}

- (NSUInteger)count
{
    return [self.backing count];
}

- (instancetype)objectForKey:(NSString *)key
{
    NSString *ciKey = KSCIDictionaryKey(key);
    NSString *originalKey = [self.mapping objectForKey:ciKey];

    return [self.backing objectForKey:originalKey];
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker
{
    NSArray *ciKeys = KSCIDictionaryKeys(keys);
    NSArray *originalKeys = [self.mapping objectsForKeys:ciKeys notFoundMarker:[NSNull null]];

    return [self.backing objectsForKeys:originalKeys notFoundMarker:marker];
}

- (NSEnumerator *)keyEnumerator
{
    return [self.backing keyEnumerator];
}

- (NSEnumerator *)objectEnumerator
{
    return [self.backing objectEnumerator];
}

- (NSArray *)allKeys
{
    return [self.backing allKeys];
}

- (NSArray *)allKeysForObject:(id)object
{
    return [self.backing allKeysForObject:object];
}

- (NSArray *)allValues
{
    return [self.backing allValues];
}

- (BOOL)isEqualToCIDictionary:(KSCIDictionary *)otherDictionary
{
    if ([otherDictionary class] != [self class]) {
        return NO;
    }
    if ([self count] != [otherDictionary count]) {
        return NO;
    }

    for (NSString *originalKey in [self.backing allKeys]) {
        id object = [self objectForKey:originalKey];
        id otherObject = [otherDictionary objectForKey:originalKey];
        if (!otherObject || ![otherObject isEqual:object]) {
            return NO;
        }
    }
    return YES;
}

- (NSDictionary *)backingDictionary
{
    return self.backing;
}

#pragma mark NSObject

- (BOOL)isEqual:(id)object
{
    return [self isEqualToCIDictionary:object];
}

- (NSString *)description
{
    return [self.backing description];
}

#pragma mark NSCopying

- (instancetype)copyWithZone:(NSZone *)zone
{
    KSCIDictionary *otherDictionary = [[KSCIDictionary class] allocWithZone:zone];
    otherDictionary.backing = [self.backing mutableCopy];
    otherDictionary.mapping = [self.mapping mutableCopy];
    return otherDictionary;
}

#pragma mark NSMutableCopying

- (instancetype)mutableCopyWithZone:(NSZone *)zone
{
    KSCIMutableDictionary *otherDictionary = [[KSCIMutableDictionary class] allocWithZone:zone];
    otherDictionary.backing = [self.backing mutableCopy];
    otherDictionary.mapping = [self.mapping mutableCopy];
    return otherDictionary;
}

#pragma mark NSCoding

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.backing = [aDecoder decodeObject];
        self.mapping = [aDecoder decodeObject];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.backing];
    [aCoder encodeObject:self.mapping];
}

@end

@implementation KSCIMutableDictionary

+ (instancetype)dictionaryWithCapacity:(NSUInteger)numItems
{
    return [[self alloc] initWithCapacity:numItems];
}

- (instancetype)initWithCapacity:(NSUInteger)numItems
{
    if ((self = [super init])) {
        self.dictionary = [NSMutableDictionary dictionaryWithCapacity:numItems];
        self.backing = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    return self;
}

- (void)removeObjectForKey:(NSString *)key
{
    NSString *ciKey = KSCIDictionaryKey(key);
    NSString *originalKey = [self.mapping objectForKey:ciKey];
    [self.backing removeObjectForKey:originalKey];
    [self.mapping removeObjectForKey:ciKey];
}

- (void)setObject:(id)object forKey:(NSString *)key
{
    KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    for (NSString *key in [otherDictionary allKeys]) {
        id object = [otherDictionary objectForKey:key];
        KSCIDictionarySetObjectAndMapping(self.backing, self.mapping, object, key);
    }
}

- (void)removeAllObjects
{
    [self.backing removeAllObjects];
    [self.mapping removeAllObjects];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    NSArray *ciKeys = KSCIDictionaryKeys(keyArray);
    NSArray *originalKeys = [self.mapping objectsForKeys:ciKeys notFoundMarker:[NSNull null]];
    [self.backing removeObjectsForKeys:originalKeys];
    [self.mapping removeObjectsForKeys:ciKeys];
}

- (void)setDictionary:(NSDictionary *)otherDictionary
{
    [self removeAllObjects];
    [self addEntriesFromDictionary:otherDictionary];
}

- (NSMutableDictionary *)backingMutableDictionary
{
    return self.backing;
}

@end
