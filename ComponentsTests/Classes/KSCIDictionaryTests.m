//
//  KSCIDictionaryTests.m
//  KSCIDictionaryTests
//
//  Created by Davide De Rosa on 6/21/12.
//  Copyright (c) 2012 Davide De Rosa. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "KSCIDictionary.h"

#warning FIXME: this is currently broken, tests will fail here and there

static inline NSArray *casedKeysFromKey(NSString *key) {
    NSMutableArray *keys = [NSMutableArray array];

    const NSUInteger keyLength = [key length];
    const NSUInteger keyCombinations = exp2(keyLength);

    for (NSUInteger mask = 0; mask < keyCombinations; ++mask) {
        NSMutableString *casedKey = [NSMutableString string];
        for (NSUInteger i = 0; i < keyLength; ++i) {
            const unichar ch = [key characterAtIndex:i];
            
            if (mask & (1 << i)) {
                [casedKey appendFormat:@"%c", tolower(ch)];
            } else {
                [casedKey appendFormat:@"%c", toupper(ch)];
            }
        }
        [keys addObject:casedKey];
    }

    return keys;
}

@interface KSCIDictionaryTests : XCTestCase

@end

@implementation KSCIDictionaryTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)assertDictionary:(KSCIDictionary *)dictionary object:(id)object forKey:(NSString *)key
{
    NSLog(@"dictionary = %@", dictionary);
    
    for (NSString *casedKey in casedKeysFromKey(key)) {
        NSLog(@"[dictionary objectForKey:@\"%@\"] = (%@ isEqual:%@)", casedKey, [dictionary objectForKey:casedKey], object);

        if (object) {
            XCTAssertTrue([[dictionary objectForKey:casedKey] isEqual:object], @"Key not found, expected object");
        } else {
            XCTAssertTrue(![dictionary objectForKey:casedKey], @"Key found, expected nil");
        }
    }
}

- (void)testCreation
{
    id object = @"object #1";
    id key = @"ONe";
//    id objects[] = { object };
//    id keys[] = { key };
    
    KSCIMutableDictionary *dictionary;
    
    dictionary = [KSCIMutableDictionary dictionary];
    XCTAssertTrue([dictionary count] == 0, @"Dictionary is not empty");

    dictionary = [KSCIMutableDictionary dictionaryWithObject:object forKey:key];
    [self assertDictionary:dictionary object:object forKey:key];
    XCTAssertTrue([dictionary count] == 1, @"Dictionary count is not 1");

//    dictionary = [KSCIMutableDictionary dictionaryWithObjects:objects forKeys:keys count:1];
//    [self assertDictionary:dictionary object:object forKey:key];
//    XCTAssertTrue([dictionary count] == 1, @"Dictionary count is not 1");

    dictionary = [KSCIMutableDictionary dictionaryWithObjectsAndKeys:object, key, nil];
    [self assertDictionary:dictionary object:object forKey:key];
    XCTAssertTrue([dictionary count] == 1, @"Dictionary count is not 1");

    dictionary = [KSCIMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObject:object forKey:key]];
    [self assertDictionary:dictionary object:object forKey:key];
    XCTAssertTrue([dictionary count] == 1, @"Dictionary count is not 1");

    dictionary = [KSCIMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:object] forKeys:[NSArray arrayWithObject:key]];
    [self assertDictionary:dictionary object:object forKey:key];
    XCTAssertTrue([dictionary count] == 1, @"Dictionary count is not 1");
}

- (void)testSetting
{
    id object = @"object";
    id key = @"mINe";
    id anotherObject = @"another object";
    id anotherKey = @"yOuRS";

    KSCIMutableDictionary *dictionary = [KSCIMutableDictionary dictionaryWithObject:object forKey:key];

    NSLog(@"set anotherKey");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self assertDictionary:dictionary object:object forKey:key];
    [self assertDictionary:dictionary object:anotherObject forKey:anotherKey];

    NSLog(@"remove anotherKey");
    [dictionary removeObjectForKey:anotherKey];
    [self assertDictionary:dictionary object:object forKey:key];
    [self assertDictionary:dictionary object:nil forKey:anotherKey];

    NSLog(@"set anotherKey");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self assertDictionary:dictionary object:object forKey:key];
    [self assertDictionary:dictionary object:anotherObject forKey:anotherKey];

    NSLog(@"removeAllObjects");
    [dictionary removeAllObjects];
    [self assertDictionary:dictionary object:nil forKey:key];
    [self assertDictionary:dictionary object:nil forKey:anotherKey];

    NSLog(@"set anotherKey");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self assertDictionary:dictionary object:nil forKey:key];
    [self assertDictionary:dictionary object:anotherObject forKey:anotherKey];

    NSString *key1 = @"miNE";
    NSString *key2 = @"YouRs";
    NSArray *objects = [dictionary objectsForKeys:[NSArray arrayWithObjects:key1, key2, nil]
                                   notFoundMarker:[NSNull null]];
    NSArray *expectedObjects = [NSArray arrayWithObjects:[NSNull null], anotherObject, nil];
    NSLog(@"<%@, %@> = %@", key1, key2, objects);
    XCTAssertTrue([objects isEqualToArray:expectedObjects], @"Keys not found");
}

- (void)testAdding
{
    id object = @"replaced";
    id key = @"tWo";
    id anotherObject = @"persistent";
    id anotherKey = @"kePT";
    
    KSCIMutableDictionary *dictionary = [KSCIMutableDictionary dictionaryWithObjectsAndKeys:object, key, anotherObject, anotherKey, nil];
    NSDictionary *other = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"one", @"2", @"tWO", @"3", @"ThREe", nil];

    NSLog(@"dictionary = %@", dictionary);

    [dictionary addEntriesFromDictionary:other];
    NSLog(@"added other = %@", dictionary);
    [self assertDictionary:dictionary object:@"1" forKey:@"one"];
    [self assertDictionary:dictionary object:@"2" forKey:@"two"];
    [self assertDictionary:dictionary object:@"3" forKey:@"three"];
    [self assertDictionary:dictionary object:@"persistent" forKey:@"kept"];

    [dictionary setDictionary:other];
    NSLog(@"set other = %@", dictionary);
    [self assertDictionary:dictionary object:@"1" forKey:@"one"];
    [self assertDictionary:dictionary object:@"2" forKey:@"two"];
    [self assertDictionary:dictionary object:@"3" forKey:@"three"];
    [self assertDictionary:dictionary object:nil forKey:@"kept"];
}

- (void)testFileAndURL
{
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"KSCIDictionaryTests" ofType:@"plist"];
    NSLog(@"file = %@", file);
    NSURL *url = [NSURL fileURLWithPath:file];
    NSLog(@"url = %@", url);

    NSArray *dictionaries = [NSArray arrayWithObjects:[KSCIDictionary dictionaryWithContentsOfFile:file],
                             [KSCIDictionary dictionaryWithContentsOfURL:url], nil];

    for (KSCIDictionary *dict in dictionaries) {
        [self assertDictionary:dict object:@"100" forKey:@"prop1"];
        [self assertDictionary:dict object:[NSNumber numberWithInteger:200] forKey:@"prop2"];
        [self assertDictionary:dict object:@"300" forKey:@"prop3"];
    }
}

- (void)testCopyAndCoding
{
    NSString *file = [[NSBundle bundleForClass:[self class]] pathForResource:@"KSCIDictionaryTests" ofType:@"plist"];
    NSLog(@"file = %@", file);
    KSCIDictionary *dictionary = [KSCIDictionary dictionaryWithContentsOfFile:file];

    NSLog(@"dictionary = %@", dictionary);
    KSCIDictionary *copied = [[dictionary copy] autorelease];
    NSLog(@"copied = %@", copied);
    KSCIDictionary *serialized = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:dictionary]];
    NSLog(@"serialized = %@", serialized);
    
    XCTAssertTrue([dictionary isEqual:copied], @"Copied dictionary is different");
    XCTAssertTrue([dictionary isEqualToCIDictionary:copied], @"Copied dictionary is different");
    XCTAssertTrue([dictionary isEqual:serialized], @"Serialized dictionary is different");
    XCTAssertTrue([dictionary isEqualToCIDictionary:serialized], @"Serialized dictionary is different");

    KSCIDictionary *different = [KSCIDictionary dictionaryWithObject:@"test" forKey:@"one"];
    XCTAssertTrue(![dictionary isEqual:different], @"Different dictionary is equal");
    XCTAssertTrue(![dictionary isEqualToCIDictionary:different], @"Different dictionary is equal");
    
    KSCIMutableDictionary *lowercase = [KSCIMutableDictionary dictionary];
    for (NSString *key in [dictionary allKeys]) {
        [lowercase setObject:[dictionary objectForKey:key] forKey:[key lowercaseString]];
    }
    NSLog(@"dictionary = %@", dictionary);
    NSLog(@"lowercase = %@", lowercase);

    // mutable
    NSLog(@"[lowercase class] = %@", [lowercase class]);
    XCTAssertTrue(![dictionary isEqual:lowercase], @"Mutable lowercase dictionary is equal");
    XCTAssertTrue(![dictionary isEqualToCIDictionary:lowercase], @"Mutable lowercase dictionary is equal");

    // immutable
    KSCIDictionary *immutableLowercase = [[lowercase copy] autorelease];
    NSLog(@"[immutableLowercase class] = %@", [immutableLowercase class]);
    XCTAssertTrue([dictionary isEqual:immutableLowercase], @"Immutable lowercase dictionary is different");
    XCTAssertTrue([dictionary isEqualToCIDictionary:immutableLowercase], @"Immutable lowercase dictionary is different");
}

@end
