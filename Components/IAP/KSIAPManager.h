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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

typedef enum {
    KSIAPProductMetadataKindConsumable = 1,
    KSIAPProductMetadataKindNonConsumable
} KSIAPProductMetadataKind;

KSIAPProductMetadataKind KSIAPProductMetadataKindFromString(NSString *string);
NSString *KSIAPProductMetadataKindToString(const KSIAPProductMetadataKind kind);

#pragma mark -

@interface KSIAPProductMetadata : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, assign) KSIAPProductMetadataKind kind;

@end

@interface KSIAPPurchase : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *purchaseHash;

@end

#pragma mark -

extern NSString *const KSIAPManagerDidFetchProductsListNotification;
extern NSString *const KSIAPManagerDidStartPurchasingProductNotification;
extern NSString *const KSIAPManagerDidPurchaseProductNotification;
extern NSString *const KSIAPManagerDidFailProductNotification;
extern NSString *const KSIAPManagerDidRestoreCompletedNotification;
extern NSString *const KSIAPManagerDidFailToRestoreCompletedNotification;

extern NSString *const KSIAPManagerProductKey;
extern NSString *const KSIAPManagerProductIdentifierKey;
extern NSString *const KSIAPManagerPurchaseKey;
extern NSString *const KSIAPManagerIsRestoredKey;
extern NSString *const KSIAPManagerErrorKey;

typedef enum {
    KSIAPManagerPurchaseResultRequested,
    KSIAPManagerPurchaseResultPurchased,
    KSIAPManagerPurchaseResultErrorCannotPay,
    KSIAPManagerPurchaseResultErrorNoProducts,
    KSIAPManagerPurchaseResultErrorUnknownProduct
} KSIAPManagerPurchaseResult;

@interface KSIAPManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (nonatomic, strong) NSString *metadataPath; // set on app delegate initialize!!!

+ (KSIAPManager *)sharedInstance;

- (void)fetchProductsList;
- (BOOL)isPurchasedProductIdentifier:(NSString *)productIdentifier;
- (NSSet *)purchasedProductIdentifiers;
- (KSIAPPurchase *)purchaseWithProductIdentifier:(NSString *)productIdentifier;

- (KSIAPManagerPurchaseResult)purchaseProductWithIdentifier:(NSString *)productIdentifier;
- (KSIAPManagerPurchaseResult)restoreCompletedPurchases;

@end
