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

#import "KSKeychain.h"
#import "NSString+Random.h"
#import "NSString+Digest.h"

#import "KSIAPManager.h"

KSIAPProductMetadataKind KSIAPProductMetadataKindFromString(NSString *string) {
    if ([string isEqualToString:@"Consumable"]) {
        return KSIAPProductMetadataKindConsumable;
    } else if ([string isEqualToString:@"Non-Consumable"]) {
        return KSIAPProductMetadataKindNonConsumable;
    }
    return 0;
}

NSString *KSIAPProductMetadataKindToString(const KSIAPProductMetadataKind kind) {
    switch (kind) {
        case KSIAPProductMetadataKindConsumable:
            return @"Consumable";
            
        case KSIAPProductMetadataKindNonConsumable:
            return @"Non-Consumable";
    }
    return nil;
}

//

@implementation KSIAPProductMetadata

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.productIdentifier = [aDecoder decodeObjectForKey:@"productIdentifier"];
        self.kind = [aDecoder decodeIntegerForKey:@"kind"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_productIdentifier forKey:@"productIdentifier"];
    [aCoder encodeInteger:_kind forKey:@"kind"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ productIdentifier=%@, kind=%@",
            [super description], _productIdentifier, KSIAPProductMetadataKindToString(_kind)];
}

@end

@implementation KSIAPPurchase

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super init])) {
        self.productIdentifier = [aDecoder decodeObjectForKey:@"productIdentifier"];
        self.quantity = [aDecoder decodeIntegerForKey:@"quantity"];
        self.hash = [aDecoder decodeObjectForKey:@"hash"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_productIdentifier forKey:@"productIdentifier"];
    [aCoder encodeInteger:_quantity forKey:@"quantity"];
    [aCoder encodeObject:_hash forKey:@"hash"];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ productIdentifier=%@, quantity=%d",
            [super description], _productIdentifier, _quantity];
}

@end

//

NSString *const KSIAPManagerDidFetchProductsListNotification        = @"KSIAPManagerDidFetchProductsListNotification";
NSString *const KSIAPManagerDidStartPurchasingProductNotification   = @"KSIAPManagerDidStartPurchasingProductNotification";
NSString *const KSIAPManagerDidPurchaseProductNotification          = @"KSIAPManagerDidPurchaseProductNotification";
NSString *const KSIAPManagerDidFailProductNotification              = @"KSIAPManagerDidFailProductNotification";
NSString *const KSIAPManagerDidRestoreCompletedNotification         = @"KSIAPManagerDidRestoreCompletedNotification";
NSString *const KSIAPManagerDidFailToRestoreCompletedNotification   = @"KSIAPManagerDidFailToRestoreCompletedNotification";

static NSString *const KSIAPManagerSaltKey              = @"KSIAPManager";
static NSString *const KSIAPManagerConfigurationPlist   = @"KSIAPManager";
static NSString *const KSIAPManagerPurchasesFile        = @"KSIAPManager.db";

static const NSUInteger KSIAPManagerSaltKeyLength       = 32;

@interface KSIAPManager ()

@property (nonatomic, strong) NSString *keychainSalt;
@property (nonatomic, strong) NSString *purchasesPath;
@property (nonatomic, strong) NSDictionary *productsMetadata; // identifier -> KSIAPProductMetadata (plist)
@property (nonatomic, strong) NSMutableDictionary *purchases; // identifier -> KSIAPPurchase (keychain)
@property (nonatomic, strong) NSDictionary *availableProducts; // identifier -> SKProduct (remote service)

@property (nonatomic, strong) SKProductsRequest *ongoingProductsRequest;

- (NSString *)generateSalt;
- (NSString *)hashForPurchase:(KSIAPPurchase *)purchase;

- (NSDictionary *)loadProductsMetadata;
- (NSDictionary *)loadPurchases;
- (KSIAPPurchase *)savePurchaseWithProductIdentifier:(NSString *)productIdentifier quantity:(NSInteger)quantity;
- (void)fetchProductsList;

- (void)transactionPurchasing:(SKPaymentTransaction *)transaction;
- (void)transactionSucceeded:(SKPaymentTransaction *)transaction;
- (void)transactionRestored:(SKPaymentTransaction *)transaction;
- (void)transactionFailed:(SKPaymentTransaction *)transaction;
- (void)completeTransaction:(SKPaymentTransaction *)transaction;

//- (void)applicationDidBecomeActive:(NSNotification *)notification;

@end

@implementation KSIAPManager

+ (void)load
{
    [self performSelectorOnMainThread:@selector(sharedInstance) withObject:nil waitUntilDone:NO];
}

+ (KSIAPManager *)sharedInstance
{
    static KSIAPManager *instance = nil;
    if (!instance) {
        instance = [[KSIAPManager alloc] init];
    }
    return instance;
}

- (id)init
{
    if ((self = [super init])) {
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];

        self.keychainSalt = [self generateSalt];
//        NSLog(@"keychain salt is %@", _keychainSalt);
        
        // load products metadata from configuration file
        self.metadataPath = [[NSBundle bundleForClass:[self class]] pathForResource:KSIAPManagerConfigurationPlist ofType:@"plist"];
        
        // load already purchased products
        self.purchasesPath = [documentsDirectory stringByAppendingPathComponent:KSIAPManagerPurchasesFile];
        self.purchases = [[[self loadPurchases] mutableCopy] autorelease];
        
        // do this early
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

//        [[NSNotificationCenter defaultCenter] addObserver:self
//                                                 selector:@selector(applicationDidBecomeActive:)
//                                                     name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];

    self.keychainSalt = nil;
    self.purchasesPath = nil;
    self.productsMetadata = nil;
    self.purchases = nil;
    self.availableProducts = nil;
    self.ongoingProductsRequest = nil;

    [super ah_dealloc];
}

- (void)setMetadataPath:(NSString *)metadataPath
{
    [_metadataPath autorelease];
    _metadataPath = [metadataPath copy];

    if ([[NSFileManager defaultManager] fileExistsAtPath:_metadataPath]) {
        self.productsMetadata = [self loadProductsMetadata];
    } else {
        self.productsMetadata = nil;
    }
}

#pragma mark - Hashing

- (NSString *)generateSalt
{
    NSString *salt = [KSKeychain stringForKey:KSIAPManagerSaltKey];

    // no existing salt from keychain, generate a new one
    if (!salt) {
        NSLog(@"no salt found in keychain, generating a new one");

        // start from random string
        NSMutableString *newSalt = [[[NSString randomStringWithLength:KSIAPManagerSaltKeyLength] mutableCopy] autorelease];

        // append unique identifier
        UIDevice *device = [UIDevice currentDevice];
        NSString *udid = nil;
        if ([device respondsToSelector:@selector(identifierForVendor)]) { // >= 6.0
            udid = [device.identifierForVendor UUIDString];
//        } else {
//            udid = [device uniqueIdentifier];
//        } else if ([device respondsToSelector:@selector(uniqueIdentifier)]) { // < 6.0 (removed from SDK)
//            udid = [device performSelector:@selector(uniqueIdentifier)];
        } else {
            udid = @"";
        }
        [newSalt appendFormat:@".%@", udid];

        // save to keychain
        [KSKeychain setString:newSalt forKey:KSIAPManagerSaltKey];

        salt = newSalt;
    }

    return salt;
}

- (NSString *)hashForPurchase:(KSIAPPurchase *)purchase
{
    NSString *key = [NSString stringWithFormat:@"%@.%@", _keychainSalt, purchase.productIdentifier];
    
    return [key digestBySHA1];
}

#pragma mark - Store

- (NSDictionary *)loadProductsMetadata
{
    NSMutableDictionary *metadata = [[NSMutableDictionary alloc] init];
    NSDictionary *plist = [[NSDictionary alloc] initWithContentsOfFile:_metadataPath];

    for (NSString *kindString in [plist allKeys]) {
        NSArray *kindProductIdentifiers = [plist objectForKey:kindString];
        
        // a metadata entry for each identifier
        for (NSString *productIdentifier in kindProductIdentifiers) {
            KSIAPProductMetadata *pm = [[KSIAPProductMetadata alloc] init];
            pm.productIdentifier = productIdentifier;
            pm.kind = KSIAPProductMetadataKindFromString(kindString);

            [metadata setObject:pm forKey:productIdentifier];
            [pm release];
        }
    }

    NSLog(@"products metadata from configuration file: %@", metadata);
    [plist release];

    return [metadata autorelease];
}

- (NSDictionary *)loadPurchases
{
    NSMutableDictionary *purchases = [[NSKeyedUnarchiver unarchiveObjectWithFile:_purchasesPath] mutableCopy];
    if (!purchases) {
        purchases = [[NSMutableDictionary alloc] init];
    }
    NSLog(@"purchases history: %@", purchases);
    
    // integrity check
    NSMutableArray *invalidIdentifiers = [[NSMutableArray alloc] init];
    for (KSIAPPurchase *purchase in [purchases allValues]) {
//        NSLog(@"\thash: %@, expected: %@", purchase.hash, [self hashForPurchase:purchase]);

        // compare stored hash with expected
        if (![purchase.hash isEqualToString:[self hashForPurchase:purchase]]) {
            [invalidIdentifiers addObject:purchase.productIdentifier];
            NSLog(@"\tintegrity check failed on: %@", purchase);
        }
    }

    // remove invalid entries
    if ([invalidIdentifiers count] > 0) {
        [purchases removeObjectsForKeys:invalidIdentifiers];

        // update stored file
        [NSKeyedArchiver archiveRootObject:purchases toFile:_purchasesPath];
    }
    [invalidIdentifiers release];

    return [purchases autorelease];
}

- (KSIAPPurchase *)savePurchaseWithProductIdentifier:(NSString *)productIdentifier quantity:(NSInteger)quantity
{
    // remember purchased product
    KSIAPPurchase *purchase = [_purchases objectForKey:productIdentifier];
    if (!purchase) {
        purchase = [[[KSIAPPurchase alloc] init] autorelease];
        purchase.productIdentifier = productIdentifier;
        purchase.quantity = quantity;
        purchase.hash = [self hashForPurchase:purchase];
    } else {
        purchase.quantity += quantity;
    }
    [_purchases setObject:purchase forKey:productIdentifier];

    // persist purchases
    [NSKeyedArchiver archiveRootObject:_purchases toFile:_purchasesPath];

    return purchase;
}

- (void)fetchProductsList
{
    // XXX: when to download products?
    NSSet *productIdentifiers = [[NSSet alloc] initWithArray:[_productsMetadata allKeys]];
    
    // refresh products list
    self.ongoingProductsRequest = [[[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers] autorelease];
    _ongoingProductsRequest.delegate = self;
    [_ongoingProductsRequest start];
    
    [productIdentifiers release];
}

- (BOOL)isPurchasedProductIdentifier:(NSString *)productIdentifier
{
    return [[_purchases allKeys] containsObject:productIdentifier];
}

- (NSArray *)purchasedProductIdentifiers
{
    return [_purchases allKeys];
}

- (KSIAPPurchase *)purchaseWithProductIdentifier:(NSString *)productIdentifier
{
    return [_purchases objectForKey:productIdentifier];
}

#pragma mark - Requests

- (KSIAPManagerPurchaseResult)purchaseProductWithIdentifier:(NSString *)productIdentifier
{
//    // FIXME: test purchase
//    [self savePurchaseWithProductIdentifier:productIdentifier quantity:1];
//    return;
    
    // already purchased (if non-consumable)
    KSIAPProductMetadata *metadata = [_productsMetadata objectForKey:productIdentifier];
    if ((metadata.kind == KSIAPProductMetadataKindNonConsumable) &&
        [self isPurchasedProductIdentifier:productIdentifier]) {

        NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:productIdentifier, @"productIdentifier", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidPurchaseProductNotification
                                                            object:nil
                                                          userInfo:userInfo];
        [userInfo release];

        return KSIAPManagerPurchaseResultPurchased;
    }
    
    // cannot make payments
    if (![SKPaymentQueue canMakePayments]) {
        return KSIAPManagerPurchaseResultErrorCannotPay;
    }
    
    // products not yet retrieved
    if ([_availableProducts count] == 0) {

        // refetch if nothing ongoing
        if (!_ongoingProductsRequest) {
            [self fetchProductsList];
        }

        return KSIAPManagerPurchaseResultErrorNoProducts;
    }
    
    // unknown product
    if (![_availableProducts objectForKey:productIdentifier]) {
        return KSIAPManagerPurchaseResultErrorUnknownProduct;
    }
    
    SKProduct *product = [_availableProducts objectForKey:productIdentifier];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    
    // enqueue payment
    [[SKPaymentQueue defaultQueue] addPayment:payment];

    return KSIAPManagerPurchaseResultRequested;
}

- (KSIAPManagerPurchaseResult)restoreCompletedPurchases
{
    // cannot make payments
    if (![SKPaymentQueue canMakePayments]) {
        return KSIAPManagerPurchaseResultErrorCannotPay;
    }

    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];

    return KSIAPManagerPurchaseResultRequested;
}

#pragma mark - Completion

- (void)transactionPurchasing:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.payment.productIdentifier;

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:productIdentifier, @"productIdentifier", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidStartPurchasingProductNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];
}

- (void)transactionSucceeded:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.payment.productIdentifier;
    const NSUInteger quantity = transaction.payment.quantity;
    KSIAPPurchase *purchase = [self savePurchaseWithProductIdentifier:productIdentifier quantity:quantity];
    SKProduct *product = [_availableProducts objectForKey:productIdentifier];

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:product, @"product",
                              purchase, @"purchase", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidPurchaseProductNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];
    
    [self completeTransaction:transaction];
}

- (void)transactionRestored:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.originalTransaction.payment.productIdentifier;
    const NSUInteger quantity = transaction.originalTransaction.payment.quantity;
    KSIAPPurchase *purchase = [self savePurchaseWithProductIdentifier:productIdentifier quantity:quantity];
    SKProduct *product = [_availableProducts objectForKey:productIdentifier];

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:product, @"product",
                              purchase, @"purchase", [NSNumber numberWithBool:YES], @"isRestored", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidPurchaseProductNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];

    [self completeTransaction:transaction];
}

- (void)transactionFailed:(SKPaymentTransaction *)transaction
{
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSError *error = transaction.error;

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:productIdentifier, @"productIdentifier", error, @"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidFailProductNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];

    [self completeTransaction:transaction];
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    NSMutableDictionary *products = [[NSMutableDictionary alloc] initWithCapacity:[response.products count]];
    for (SKProduct *product in response.products) {
        [products setObject:product forKey:product.productIdentifier];

        NSLog(@"product: %@, title: '%@', price: %@", product.productIdentifier, product.localizedTitle, product.price);
    }
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"invalid product: %@", invalidIdentifier);
    }

    self.availableProducts = products;
    [products release];

    // finish request
    self.ongoingProductsRequest = nil;
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions) {
        switch (transaction.transactionState) {
            case SKPaymentTransactionStatePurchasing: {
                [self transactionPurchasing:transaction];
                break;
            }
            case SKPaymentTransactionStatePurchased: {
                [self transactionSucceeded:transaction];
                break;
            }
            case SKPaymentTransactionStateRestored: {
                [self transactionRestored:transaction];
                break;
            }
            case SKPaymentTransactionStateFailed: {
                [self transactionFailed:transaction];
                break;
            }
            default: {
                break;
            }
        }

        NSLog(@"transaction: %@ (state = %d)", transaction.payment.productIdentifier, transaction.transactionState);
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"restored completed transactions");

    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidRestoreCompletedNotification
                                                        object:nil
                                                      userInfo:nil];
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    NSLog(@"failed to restore completed transactions: %@", error);

    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:error, @"error", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:KSIAPManagerDidFailToRestoreCompletedNotification
                                                        object:nil
                                                      userInfo:userInfo];
    [userInfo release];
}

//#pragma mark - UIApplication
//
//- (void)applicationDidBecomeActive:(NSNotification *)notification
//{
//    [self fetchProductsList];
//}

@end
