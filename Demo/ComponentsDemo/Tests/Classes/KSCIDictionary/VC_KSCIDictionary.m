//
//  VC_KSCIDictionary.m
//  ComponentsDemo
//
//  Created by Davide De Rosa on 6/20/12.
//  Copyright (c) 2012 algoritmico. All rights reserved.
//

#import "VC_KSCIDictionary.h"
#import "KSCIDictionary.h"

@interface VC_KSCIDictionary ()

@end

@implementation VC_KSCIDictionary

- (void) testDictionary1:(KSCIDictionary *)dictionary
{
    NSLog(@"test 1");
    NSLog(@"dictionary = %@", dictionary);
    NSLog(@"\tONE -> %@", [dictionary objectForKey:@"ONE"]);
    NSLog(@"\toNe -> %@", [dictionary objectForKey:@"oNe"]);
    NSLog(@"\tone -> %@", [dictionary objectForKey:@"one"]);
    NSLog(@"\tOnE -> %@", [dictionary objectForKey:@"OnE"]);
    NSLog(@"\n");
}

- (void) testDictionary2:(KSCIDictionary *)dictionary
{
    NSLog(@"test 2");
    NSLog(@"dictionary = %@", dictionary);
    NSLog(@"\tanOthER -> %@", [dictionary objectForKey:@"anOthER"]);
    NSLog(@"\tanother -> %@", [dictionary objectForKey:@"another"]);
    NSLog(@"\tANOTHER -> %@", [dictionary objectForKey:@"ANOTHER"]);
    NSLog(@"\t<oNE, aNothER> -> %@", [dictionary objectsForKeys:[NSArray arrayWithObjects:@"oNE", @"aNothER", nil]
                                                 notFoundMarker:[NSNull null]]);
    NSLog(@"\n");
}

- (void) testDictionary3:(KSCIDictionary *)dictionary
{
    NSLog(@"test 3");
    NSLog(@"dictionary = %@", dictionary);
    NSLog(@"\tOne -> %@", [dictionary objectForKey:@"One"]);
    NSLog(@"\ttwO -> %@", [dictionary objectForKey:@"twO"]);
    NSLog(@"\tthREE -> %@", [dictionary objectForKey:@"thREE"]);
    NSLog(@"\n");
}

- (void) testDictionary4:(KSCIDictionary *)dictionary
{
    NSLog(@"test 4");
    NSLog(@"dictionary = %@", dictionary);
    NSLog(@"\tProPeRTY1 -> %@", [dictionary objectForKey:@"ProPeRTY1"]);
    NSLog(@"\tPROPERTY2 -> %@", [dictionary objectForKey:@"PROPERTY2"]);
    NSLog(@"\tproperty3 -> %@", [dictionary objectForKey:@"property3"]);
    NSLog(@"\n");
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    id object = @"object #1";
    id key = @"ONe";
    id objects[] = { object };
    id keys[] = { key };

    KSCIMutableDictionary *dictionary;

    dictionary = [KSCIMutableDictionary dictionary];
    [self testDictionary1:dictionary];
    dictionary = [KSCIMutableDictionary dictionaryWithObject:object forKey:key];
    [self testDictionary1:dictionary];
    dictionary = [KSCIMutableDictionary dictionaryWithObjects:objects forKeys:keys count:1];
    [self testDictionary1:dictionary];
    dictionary = [KSCIMutableDictionary dictionaryWithObjectsAndKeys:object, key, nil];
    [self testDictionary1:dictionary];
    dictionary = [KSCIMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithObject:object forKey:key]];
    [self testDictionary1:dictionary];
    dictionary = [KSCIMutableDictionary dictionaryWithObjects:[NSArray arrayWithObject:object] forKeys:[NSArray arrayWithObject:key]];
    [self testDictionary1:dictionary];

    id anotherObject = @"another object";
    id anotherKey = @"AnOthEr";

    NSLog(@"setObject:forKey:\n\n");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self testDictionary1:dictionary];
    [self testDictionary2:dictionary];
    NSLog(@"removeObjectForKey:\n\n");
    [dictionary removeObjectForKey:anotherKey];
    [self testDictionary1:dictionary];
    [self testDictionary2:dictionary];
    NSLog(@"setObject:forKey:\n\n");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self testDictionary1:dictionary];
    [self testDictionary2:dictionary];
    NSLog(@"removeAllObjects\n\n");
    [dictionary removeAllObjects];
    [self testDictionary1:dictionary];
    [self testDictionary2:dictionary];
    NSLog(@"setObject:forKey:\n\n");
    [dictionary setObject:anotherObject forKey:anotherKey];
    [self testDictionary1:dictionary];
    [self testDictionary2:dictionary];

    NSDictionary *other = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"one", @"2", @"tWO", @"3", @"ThREe", nil];

    NSLog(@"addEntriesFromDictionary:\n\n");
    [dictionary addEntriesFromDictionary:other];
    [self testDictionary3:dictionary];
    NSLog(@"setDictionary:\n\n");
    [dictionary setDictionary:other];
    [self testDictionary3:dictionary];

    NSString *file = [[NSBundle mainBundle] pathForResource:@"KSCIDictionaryTest" ofType:@"plist"];

    NSLog(@"dictionaryWithContentsOfFile:\n\n");
    dictionary = [KSCIDictionary dictionaryWithContentsOfFile:file];
    [self testDictionary4:dictionary];

    NSURL *url = [NSURL fileURLWithPath:file];
    
    NSLog(@"dictionaryWithContentsOfURL:\n\n");
    dictionary = [KSCIDictionary dictionaryWithContentsOfURL:url];
    [self testDictionary4:dictionary];

    NSLog(@"copy = %@", [[dictionary copy] autorelease]);
    NSLog(@"mutableCopy = %@", [[dictionary mutableCopy] autorelease]);

    NSDictionary *serialized = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:dictionary]];
    NSLog(@"serialized = %@", serialized);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
