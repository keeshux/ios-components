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

#import "KSMacrosDates.h"

typedef struct {
    NSInteger day;
    NSInteger month;
} KSDatesMonthDay;

#pragma mark - Year

NSInteger KSDatesYear(NSDate *date) {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitYear
                                                                   fromDate:date];
    
    return components.year;
}

NSMutableArray *KSDatesYears(const NSInteger from, const NSInteger to, const NSInteger step) {
    NSInteger year = from;
    NSInteger lastYear = to;
    
    if (step < 0) {
        year = to;
        lastYear = from;
    }
    
    // include last
    lastYear += step;
    
    NSMutableArray *years = [NSMutableArray array];
    while (year != lastYear) {
        [years addObject:[NSNumber numberWithInteger:year]];
        year += step;
    }
    return years;
}

NSDate *KSDatesDatePlusYears(NSDate *date, const NSInteger years) {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = years;
    NSDate *offsetDate = [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:date options:0];
    [components release];
    
    return offsetDate;
}

#pragma mark - Month

NSInteger KSDatesMonth(NSDate *date) {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitMonth
                                                                   fromDate:date];
    
    return components.month;
}

#pragma mark - ISO

NSString *KSDatesISOString(NSDate *date) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [formatter stringFromDate:date];
    [formatter release];
    return string;
}

NSDate *KSDatesISODate(NSString *string) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

NSDate *KSDatesISODateTime(NSString *string) {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:string];
    [formatter release];
    return date;
}

#pragma mark - Date

NSDate *KSDatesDateFromComponents(NSUInteger year, NSUInteger month, NSUInteger day)
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    return [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] dateFromComponents:components];
}

BOOL KSDatesIsPastDay(NSDate *date) {
    //    return ([date compare:[NSDate date]] == NSOrderedAscending);
    
    if (!date) {
        return NO;
    }
    
    // giorni dalla data parametro ad oggi
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay
                                                                   fromDate:[NSDate date]
                                                                     toDate:date
                                                                    options:0];
    
    // oggi o futura (0 o più giorni da oggi)
    const BOOL presenteOFutura = (components.day >= 0);
    
    // più comprensibile
    return !presenteOFutura;
}

NSInteger KSDatesDistanceInDays(NSDate *from, NSDate *to) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    const NSUInteger units = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *fromComponents = [calendar components:units fromDate:from];
    NSDateComponents *toComponents = [calendar components:units fromDate:to];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitDay
                                               fromDate:[calendar dateFromComponents:fromComponents]
                                                 toDate:[calendar dateFromComponents:toComponents]
                                                options:0];
    
    return components.day;
}

NSDate *KSDatesDatePlusDays(NSDate *date, NSInteger days) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = days;
    
    NSDate *plus = [calendar dateByAddingComponents:components toDate:date options:0];
    [components release];
    
    return plus;
}

NSUInteger KSDatesAge(NSDate *birthDate) {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitYear fromDate:birthDate toDate:[NSDate date] options:0];
    return components.year;
}