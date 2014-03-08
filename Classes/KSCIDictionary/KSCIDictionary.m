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

@interface KSCIDictionary () {
@protected
    NSMutableDictionary *_backing;
    NSMutableDictionary *_mapping;
}

@property (nonatomic, strong) NSMutableDictionary *backing;
@property (nonatomic, strong) NSMutableDictionary *mapping;

@end

@implementation KSCIDictionary

@synthesize backing = _backing;
@synthesize mapping = _mapping;

+ (id)dictionary
{
    return [[[self alloc] init] autorelease];
}

+ (id)dictionaryWithObject:(id)object forKey:(NSString *)key
{
    return [[[self alloc] initWithObjectsAndKeys:object, key, nil] autorelease];
}

+ (id)dictionaryWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt
{
    return [[[self alloc] initWithObjects:objects forKeys:keys count:cnt] autorelease];
}

+ (id)dictionaryWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
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

    return [[[self alloc] initWithDictionary:ciDictionary] autorelease];
}

+ (id)dictionaryWithDictionary:(NSDictionary *)dict
{
    return [[[self alloc] initWithDictionary:dict] autorelease];
}

+ (id)dictionaryWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    return [[[self alloc] initWithObjects:objects forKeys:keys] autorelease];
}

- (id)init
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)initWithObjects:(const id [])objects forKeys:(__unsafe_unretained NSString * [])keys count:(NSUInteger)cnt
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:cnt];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:cnt];

        for (NSUInteger i = 0; i < cnt; ++i) {
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, objects[i], keys[i]);
        }
    }
    return self;
}

- (id)initWithObjectsAndKeys:(id)firstObject, ...
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];
        
        va_list args;
        va_start(args, firstObject);

        id object = firstObject;
        NSString *key = va_arg(args, NSString *);
        while (object && key) {
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);

            object = va_arg(args, id);
            key = va_arg(args, NSString *);
        }
        va_end(args);
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary
{
    return [self initWithDictionary:otherDictionary copyItems:NO];
}

- (id)initWithDictionary:(NSDictionary *)otherDictionary copyItems:(BOOL)flag
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];

        for (NSString *key in [otherDictionary allKeys]) {
            id object = [otherDictionary objectForKey:key];
            if (flag) {
                [[object copy] autorelease];
            }
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);
        }
    }
    return self;
}

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        self.mapping = [NSMutableDictionary dictionary];

        NSUInteger i = 0;
        for (NSString *key in keys) {
            id object = [objects objectAtIndex:i];
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);
            ++i;
        }
    }
    return self;
}

+ (id)dictionaryWithContentsOfFile:(NSString *)path
{
    return [[[self alloc] initWithContentsOfFile:path] autorelease];
}

+ (id)dictionaryWithContentsOfURL:(NSURL *)url
{
    return [[[self alloc] initWithContentsOfURL:url] autorelease];
}

- (id)initWithContentsOfFile:(NSString *)path
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:path];
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);
        }
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)url
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];
        self.mapping = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);
        }
    }
    return self;
}

- (void)dealloc
{
    self.backing = nil;
    self.mapping = nil;

    [super ah_dealloc];
}

- (NSUInteger)count
{
    return [_backing count];
}

- (id)objectForKey:(NSString *)aKey
{
    NSString *ciKey = KSCIDictionaryKey(aKey);
    NSString *originalKey = [_mapping objectForKey:ciKey];

    return [_backing objectForKey:originalKey];
}

- (NSArray *)objectsForKeys:(NSArray *)keys notFoundMarker:(id)marker
{
    NSArray *ciKeys = KSCIDictionaryKeys(keys);
    NSArray *originalKeys = [_mapping objectsForKeys:ciKeys notFoundMarker:[NSNull null]];

    return [_backing objectsForKeys:originalKeys notFoundMarker:marker];
}

- (NSEnumerator *)keyEnumerator
{
    return [_backing keyEnumerator];
}

- (NSEnumerator *)objectEnumerator
{
    return [_backing objectEnumerator];
}

- (NSArray *)allKeys
{
    return [_backing allKeys];
}

- (NSArray *)allKeysForObject:(id)anObject
{
    return [_backing allKeysForObject:anObject];
}

- (NSArray *)allValues
{
    return [_backing allValues];
}

- (BOOL)isEqualToCIDictionary:(KSCIDictionary *)otherDictionary
{
    if ([otherDictionary class] != [self class]) {
        return NO;
    }
    if ([self count] != [otherDictionary count]) {
        return NO;
    }

    for (NSString *originalKey in [_backing allKeys]) {
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
    return _backing;
}

#pragma mark - NSObject

- (BOOL)isEqual:(id)object
{
    return [self isEqualToCIDictionary:object];
}

- (NSString *)description
{
    return [_backing description];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    KSCIDictionary *otherDictionary = [[KSCIDictionary class] allocWithZone:zone];
    otherDictionary.backing = [[_backing mutableCopy] autorelease];
    otherDictionary.mapping = [[_mapping mutableCopy] autorelease];
    return otherDictionary;
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone
{
    KSCIMutableDictionary *otherDictionary = [[KSCIMutableDictionary class] allocWithZone:zone];
    otherDictionary.backing = [[_backing mutableCopy] autorelease];
    otherDictionary.mapping = [[_mapping mutableCopy] autorelease];
    return otherDictionary;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.backing = [aDecoder decodeObject];
        self.mapping = [aDecoder decodeObject];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_backing];
    [aCoder encodeObject:_mapping];
}

@end

@implementation KSCIMutableDictionary

+ (id)dictionaryWithCapacity:(NSUInteger)numItems
{
    return [[[self alloc] initWithCapacity:numItems] autorelease];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    if ((self = [super init])) {
        self.dictionary = [NSMutableDictionary dictionaryWithCapacity:numItems];
        self.backing = [NSMutableDictionary dictionaryWithCapacity:numItems];
    }
    return self;
}

- (void)removeObjectForKey:(NSString *)aKey
{
    NSString *ciKey = KSCIDictionaryKey(aKey);
    NSString *originalKey = [_mapping objectForKey:ciKey];
    [_backing removeObjectForKey:originalKey];
    [_mapping removeObjectForKey:ciKey];
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    KSCIDictionarySetObjectAndMapping(_backing, _mapping, anObject, aKey);
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    for (NSString *key in [otherDictionary allKeys]) {
        id object = [otherDictionary objectForKey:key];
        KSCIDictionarySetObjectAndMapping(_backing, _mapping, object, key);
    }
}

- (void)removeAllObjects
{
    [_backing removeAllObjects];
    [_mapping removeAllObjects];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    NSArray *ciKeys = KSCIDictionaryKeys(keyArray);
    NSArray *originalKeys = [_mapping objectsForKeys:ciKeys notFoundMarker:[NSNull null]];
    [_backing removeObjectsForKeys:originalKeys];
    [_mapping removeObjectsForKeys:ciKeys];
}

- (void)setDictionary:(NSDictionary *)otherDictionary
{
    [self removeAllObjects];
    [self addEntriesFromDictionary:otherDictionary];
}

- (NSMutableDictionary *)backingMutableDictionary
{
    return _backing;
}

@end
