/*
 * KSIAPManager.h
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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "ARCHelper.h"

typedef enum {
    KSIAPProductMetadataKindConsumable = 1,
    KSIAPProductMetadataKindNonConsumable
} KSIAPProductMetadataKind;

KSIAPProductMetadataKind KSIAPProductMetadataKindFromString(NSString *string);
NSString *KSIAPProductMetadataKindToString(const KSIAPProductMetadataKind kind);

//

@interface KSIAPProductMetadata : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, assign) KSIAPProductMetadataKind kind;

@end

@interface KSIAPPurchase : NSObject <NSCoding>

@property (nonatomic, copy) NSString *productIdentifier;
@property (nonatomic, assign) NSInteger quantity;
@property (nonatomic, copy) NSString *hash;

@end

//

extern NSString *const KSIAPManagerDidFetchProductsListNotification;
extern NSString *const KSIAPManagerDidStartPurchasingProductNotification;
extern NSString *const KSIAPManagerDidPurchaseProductNotification;
extern NSString *const KSIAPManagerDidFailProductNotification;
extern NSString *const KSIAPManagerDidRestoreCompletedNotification;
extern NSString *const KSIAPManagerDidFailToRestoreCompletedNotification;

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
