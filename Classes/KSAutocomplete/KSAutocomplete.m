//
// KSAutocomplete.m
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

#import "KSAutocomplete.h"

@interface KSAutocomplete ()

@property (nonatomic, copy) BOOL (^filterBlock)(id, NSString *);
@property (nonatomic, retain) NSArray *list;
@property (nonatomic, retain) NSArray *filteredList;
@property (nonatomic, retain) NSString *lastRemoteSearch;
@property (nonatomic, retain) NSString *lastLocalSearch;

- (NSArray *)filteredListWithList:(NSArray *)initialList searchPattern:(NSString *)searchPattern;

@end

@implementation KSAutocomplete

- (id)initWithFilterBlock:(BOOL (^)(id, NSString *))aFilterBlock
{
    if ((self = [super init])) {
        self.filterBlock = aFilterBlock;
    }
    return self;
}

- (void)dealloc
{
    self.filterBlock = nil;
    self.fallbackList = nil;
    self.list = nil;
    self.filteredList = nil;
    self.lastRemoteSearch = nil;
    self.lastLocalSearch = nil;

    [super ah_dealloc];
}

- (void)setList:(NSArray *)list
{
    [_list release];
    _list = [list ah_retain];
#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"list count = %d", [_list count]);
#endif

    // start with full list
    self.filteredList = _list;
}

- (void)setFilteredList:(NSArray *)filteredList
{
    // fallback
    if (_enableFallback && ([filteredList count] == 0)) {
        filteredList = _fallbackList;
    }

    [_filteredList release];
    _filteredList = [filteredList ah_retain];
#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"filteredList count = %d (fallback=%d)", [_filteredList count], _enableFallback);
#endif
}

- (KSAutocompleteResult)searchWithPattern:(NSString *)searchPattern
{
    const NSUInteger length = [searchPattern length];
    if (length < _minLength) {
        return KSAutocompleteResultOK;
    }

    KSAutocompleteResult result = 0;

    // normalize to lowercase
    searchPattern = [searchPattern lowercaseString];

    // get prefix
    NSString *searchPrefix = [searchPattern substringToIndex:_minLength];

#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"searchPattern: %@", searchPattern);
    NSLog(@"searchPrefix: %@", searchPrefix);
#endif

    // request remote data if not a subset of previous remote search
//    if ((length == minLength) && (!lastRemoteSearch || ![searchPattern hasPrefix:lastRemoteSearch])) {
//        self.lastRemoteSearch = [searchPattern lowercaseString];
    if (!_lastRemoteSearch || ![searchPrefix isEqualToString:_lastRemoteSearch]) {
        self.lastRemoteSearch = searchPrefix;
        
        result = KSAutocompleteResultRemote;
    }
    // filter local search
    else {
        
        // local subset, progressive filter
        if (!_lastLocalSearch || [searchPattern hasPrefix:_lastLocalSearch]) {
            self.filteredList = [self filteredListWithList:_filteredList searchPattern:searchPattern];
        }
        // local superset, filter initial list
        else {
            self.filteredList = [self filteredListWithList:_list searchPattern:searchPattern];
        }
        
        result = KSAutocompleteResultOK;
    }
    
    // save search
//    if (result != FCAutocompleteResultStop) {
    self.lastLocalSearch = [searchPattern lowercaseString];
//    }
    
    return result;
}

- (BOOL)setRemoteList:(NSArray *)remoteList originalSearchPattern:(NSString *)originalSearchPattern
{
    // normalize to lowercase
    originalSearchPattern = [originalSearchPattern lowercaseString];
    
    // cancel if no longer matches original search (if meaningful)
    if (_lastLocalSearch && (_lastLocalSearch.length >= _minLength) && ![_lastLocalSearch hasPrefix:originalSearchPattern]) {
        return NO;
    }

    self.list = remoteList;
    self.filteredList = [self filteredListWithList:_list searchPattern:_lastLocalSearch];

    return YES;
}

- (NSString *)lastSearch
{
    return _lastLocalSearch;
}

#pragma mark - Private

- (NSArray *)filteredListWithList:(NSArray *)initialList searchPattern:(NSString *)searchPattern
{
    NSMutableArray *built = [NSMutableArray array];
    for (id object in initialList) {
        if (_filterBlock(object, searchPattern) || [_fallbackList containsObject:object]) {
            [built addObject:object];
        }
    }
    return built;
}

@end
