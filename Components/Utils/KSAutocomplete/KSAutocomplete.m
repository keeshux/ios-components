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
@property (nonatomic, strong) NSArray *list;
@property (nonatomic, strong) NSArray *filteredList;
@property (nonatomic, strong) NSString *lastRemoteSearch;
@property (nonatomic, strong) NSString *lastLocalSearch;

- (NSArray *)filteredListWithList:(NSArray *)initialList searchPattern:(NSString *)searchPattern;

@end

@implementation KSAutocomplete

- (instancetype)initWithFilterBlock:(BOOL (^)(id, NSString *))filterBlock
{
    if ((self = [super init])) {
        self.filterBlock = filterBlock;
    }
    return self;
}

- (void)setList:(NSArray *)list
{
    _list = list;
#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"list count = %d", [_list count]);
#endif

    // start with full list
    self.filteredList = _list;
}

- (void)setFilteredList:(NSArray *)filteredList
{
    // fallback
    if (self.enableFallback && ([filteredList count] == 0)) {
        filteredList = self.fallbackList;
    }

    _filteredList = filteredList;
#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"filteredList count = %d (fallback=%d)", [_filteredList count], self.enableFallback);
#endif
}

- (KSAutocompleteResult)searchWithPattern:(NSString *)searchPattern
{
    const NSUInteger length = [searchPattern length];
    if (length < self.minLength) {
        return KSAutocompleteResultOK;
    }

    KSAutocompleteResult result = 0;

    // normalize to lowercase
    searchPattern = [searchPattern lowercaseString];

    // get prefix
    NSString *searchPrefix = [searchPattern substringToIndex:self.minLength];

#ifdef KS_AUTOCOMPLETE_VERBOSE
    NSLog(@"searchPattern: %@", searchPattern);
    NSLog(@"searchPrefix: %@", searchPrefix);
#endif

    // request remote data if not a subset of previous remote search
//    if ((length == minLength) && (!lastRemoteSearch || ![searchPattern hasPrefix:lastRemoteSearch])) {
//        self.lastRemoteSearch = [searchPattern lowercaseString];
    if (!self.lastRemoteSearch || ![searchPrefix isEqualToString:self.lastRemoteSearch]) {
        self.lastRemoteSearch = searchPrefix;
        
        result = KSAutocompleteResultRemote;
    }
    // filter local search
    else {
        
        // local subset, progressive filter
        if (!self.lastLocalSearch || [searchPattern hasPrefix:self.lastLocalSearch]) {
            self.filteredList = [self filteredListWithList:self.filteredList searchPattern:searchPattern];
        }
        // local superset, filter initial list
        else {
            self.filteredList = [self filteredListWithList:self.list searchPattern:searchPattern];
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
    if (self.lastLocalSearch && (self.lastLocalSearch.length >= self.minLength) && ![self.lastLocalSearch hasPrefix:originalSearchPattern]) {
        return NO;
    }

    self.list = remoteList;
    self.filteredList = [self filteredListWithList:self.list searchPattern:self.lastLocalSearch];

    return YES;
}

- (NSString *)lastSearch
{
    return self.lastLocalSearch;
}

#pragma mark - Private

- (NSArray *)filteredListWithList:(NSArray *)initialList searchPattern:(NSString *)searchPattern
{
    NSMutableArray *built = [NSMutableArray array];
    for (id object in initialList) {
        if (self.filterBlock(object, searchPattern) || [self.fallbackList containsObject:object]) {
            [built addObject:object];
        }
    }
    return built;
}

@end
