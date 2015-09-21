//
// Copyright (c) 2014, Davide De Rosa
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

#pragma mark - Year

NSInteger KSDatesYear(NSDate *date);

static inline NSInteger KSDatesCurrentYear() {
    return KSDatesYear([NSDate date]);
}

NSMutableArray *KSDatesYears(const NSInteger from, const NSInteger to, const NSInteger step);

static inline NSMutableArray *KSDatesYearsFromYear(const NSUInteger count, const NSUInteger from, const NSInteger step) {
    return KSDatesYears(from, from + count, step);
}

static inline NSMutableArray *KSDatesYearsToYear(const NSUInteger count, const NSUInteger to, const NSInteger step) {
    return KSDatesYears(to - count, to, step);
}

static inline NSMutableArray *KSDatesYearsFromCurrentYear(const NSUInteger count, const NSInteger step) {
    return KSDatesYearsFromYear(count, KSDatesCurrentYear(), step);
}

static inline NSMutableArray *KSDatesYearsToCurrentYear(const NSUInteger count, const NSInteger step) {
    return KSDatesYearsToYear(count, KSDatesCurrentYear(), step);
}

static inline NSMutableArray *KSDatesYearsFromYearToCurrentYear(const NSInteger from, const NSInteger step) {
    const NSInteger to = KSDatesCurrentYear();
    
    return KSDatesYears(from, to, step);
}

static inline NSMutableArray *KSDatesYearsFromCurrentYearToYear(const NSInteger to, const NSInteger step) {
    const NSInteger from = KSDatesCurrentYear();
    
    return KSDatesYears(from, to, step);
}

NSDate *KSDatesDatePlusYears(NSDate *date, const NSInteger years);

#pragma mark - Month

NSInteger KSDatesMonth(NSDate *date);

static inline NSInteger KSDatesCurrentMonth() {
    return KSDatesMonth([NSDate date]);
}

static inline NSArray *KSDatesMonthStrings() {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    return [formatter monthSymbols];
}

static inline NSString *KSDatesMonthString(const NSUInteger month) {
    return [KSDatesMonthStrings() objectAtIndex:month];
}

#pragma mark - Day

NSDate *KSDatesDateFromComponents(NSUInteger year, NSUInteger month, NSUInteger day);

static inline NSInteger KSDatesDay(NSDate *date) {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                   fromDate:date];
    
    return components.day;
}

#pragma mark - ISO

NSString *KSDatesISOString(NSDate *date);

NSDate *KSDatesISODate(NSString *string);

NSDate *KSDatesISODateTime(NSString *string);

#pragma mark - Date

BOOL KSDatesIsPastDay(NSDate *date);

NSInteger KSDatesDistanceInDays(NSDate *from, NSDate *to);

NSDate *KSDatesDatePlusDays(NSDate *date, NSInteger days);

NSUInteger KSDatesAge(NSDate *birthDate);
