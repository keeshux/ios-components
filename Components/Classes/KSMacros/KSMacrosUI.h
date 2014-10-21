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

#ifndef KSMacrosUI_h
#define KSMacrosUI_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "ARCHelper.h"

static inline BOOL KSUIIsPad()
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

static inline BOOL KSUIIsPhone5()
{
    return (fabs((double)[UIScreen mainScreen].bounds.size.height - (double)568) < DBL_EPSILON);
}

static inline BOOL KSUIIsRetina()
{
    return ([[UIScreen mainScreen] scale] > 1.9);
}

static inline UIColor *KSUIColorFromRGB(const NSUInteger rgb)
{
    const CGFloat r = ((rgb >> 16) & 0xFF) / 255.0;
    const CGFloat g = ((rgb >> 8) & 0xFF) / 255.0;
    const CGFloat b = (rgb & 0xFF) / 255.0;
    
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

#define KSUISF(format, ...)     [NSString stringWithFormat:format, __VA_ARGS__]

static inline NSString *KSUIString(NSString *key)
{
    return NSLocalizedString(key, nil);
}

static inline NSString *KSUITableString(NSString *table, NSString *key)
{
    return NSLocalizedStringFromTable(key, table, nil);
}

#endif
