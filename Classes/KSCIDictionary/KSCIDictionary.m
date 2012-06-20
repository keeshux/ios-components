/*
 * KSCIDictionary.m
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

@interface KSCIDictionary () {
@protected
    NSMutableDictionary *_backing;
}

@property (nonatomic, retain) NSMutableDictionary *backing;

@end

@implementation KSCIDictionary

@synthesize backing = _backing;

+ (id)dictionary
{
    return [[[self alloc] init] autorelease];
}

+ (id)dictionaryWithObject:(id)object forKey:(NSString *)key
{
    return [[[self alloc] initWithObjectsAndKeys:object, key, nil] autorelease];
}

+ (id)dictionaryWithObjects:(const id [])objects forKeys:(NSString * [])keys count:(NSUInteger)cnt
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
    }
    return self;
}

- (id)initWithObjects:(const id [])objects forKeys:(NSString * [])keys count:(NSUInteger)cnt
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:cnt];

        for (NSUInteger i = 0; i < cnt; ++i) {
            [_backing setObject:objects[i] forKey:KSCIDictionaryKey(keys[i])];
        }
    }
    return self;
}

- (id)initWithObjectsAndKeys:(id)firstObject, ... NS_REQUIRES_NIL_TERMINATION
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionary];
        
        va_list args;
        va_start(args, firstObject);

        id object = firstObject;
        NSString *key = va_arg(args, NSString *);
        while (object && key) {
            [_backing setObject:object forKey:KSCIDictionaryKey(key)];

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

        for (NSString *key in [otherDictionary allKeys]) {
            id object = [otherDictionary objectForKey:key];
            if (flag) {
                [[object copy] autorelease];
            }
            [_backing setObject:object forKey:KSCIDictionaryKey(key)];
        }
    }
    return self;
}

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithObjects:objects forKeys:KSCIDictionaryKeys(keys)];
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

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            [_backing setObject:object forKey:KSCIDictionaryKey(key)];
        }
    }
    return self;
}

- (id)initWithContentsOfURL:(NSURL *)url
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    if ((self = [super init])) {
        self.backing = [NSMutableDictionary dictionaryWithCapacity:[dictionary count]];

        for (NSString *key in [dictionary allKeys]) {
            id object = [dictionary objectForKey:key];
            [_backing setObject:object forKey:KSCIDictionaryKey(key)];
        }
    }
    return self;
}

- (void)dealloc
{
    self.backing = nil;

    [super dealloc];
}

- (NSUInteger)count
{
    return [_backing count];
}

- (id)objectForKey:(NSString *)aKey
{
    return [_backing objectForKey:KSCIDictionaryKey(aKey)];
}

- (NSEnumerator *)keyEnumerator
{
    return [_backing keyEnumerator];
}

- (NSString *)description
{
    return [_backing description];
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
    }
    return self;
}

- (void)removeObjectForKey:(NSString *)aKey
{
    [_backing removeObjectForKey:KSCIDictionaryKey(aKey)];
}

- (void)setObject:(id)anObject forKey:(NSString *)aKey
{
    [_backing setObject:anObject forKey:KSCIDictionaryKey(aKey)];
}

- (void)addEntriesFromDictionary:(NSDictionary *)otherDictionary
{
    for (NSString *key in [otherDictionary allKeys]) {
        id object = [otherDictionary objectForKey:key];
        [_backing setObject:object forKey:KSCIDictionaryKey(key)];
    }
}

- (void)removeAllObjects
{
    [_backing removeAllObjects];
}

- (void)removeObjectsForKeys:(NSArray *)keyArray
{
    [_backing removeObjectsForKeys:KSCIDictionaryKeys(keyArray)];
}

- (void)setDictionary:(NSDictionary *)otherDictionary
{
    [self removeAllObjects];
    [self addEntriesFromDictionary:otherDictionary];
}

@end
