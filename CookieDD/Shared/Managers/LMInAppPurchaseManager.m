//
//  LMInAppPurchaseManager.m
//  CookieDD
//
//  Created by Luke McDonald on 2/26/14.
//  Copyright (c) 2014 Seven Gun Games. All rights reserved.
//

/*
 
 Credits:
 
 President/CEO - Duane Schor
 
 Art Director - Neisha Bergman
 Artists - Ecieño Carmona
 Eric Eining
 Mike Swarts
 Erik Aamland
 Duane Schor
 
 Lead Programmer - Luke McDonald
 Programmers - Josh McGee
 Gary Johnston
 Dustin Whirle
 Jeremy Pagley
 Rodney Jenkins
 
 Server Programmer - Josh Pagley
 
 Lead Sound Designer - Ramsees Mechan
 Sound Designers - Richard Würth
 D’Andre Amos
 
 Voice Actors - Adrian Knapp
 Duane Schor
 Luke McDonald
 Neisha Bergman
 
 Lead Web Designer - Brittany Steed
 Web Designers - Yannik Bloscheck
 Lisa Menerick
 Andrew Gianikas
 
 Graphic Designer - Freddy Garcia
 
 Tech Support - Jonathan Marr-Cox
 
 Story - Audra Hudson
 Duane Schor
 
 Marketing Director - Rodney Jenkins
 Marketer - CJ Anderson
 
 Business Development Manager - Adam Hunt
 
 Quality Assurance - Vinny Spaulding
 
 Level Editing - Abner Velez
 
 
 Special Thanks - Jon Kurtz
 Benjamin Stahlhood II
 Andrew Nunley
 Steven Edsall
 And to all our friends and family that have supported us along the way!
 
 */

#import "LMInAppPurchaseManager.h"
#import "CDIAPManager.h"
#import "SGAppDelegate.h"

static LMInAppPurchaseManager *inappPurchaseManager = nil;

@implementation LMInAppPurchaseManager

#pragma mark - Initialization

+ (LMInAppPurchaseManager *)inappPurchaseManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        inappPurchaseManager = [LMInAppPurchaseManager new];
//        [inappPurchaseManager getAvailableProducts];
    });
    
    return inappPurchaseManager;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Store Product Request

-(void)getAvailableProductsWithSet:(NSSet *)productIdentifiers
{
    self.validProductsInStore = [NSMutableArray new];
 
    _productRequest = [[SKProductsRequest alloc]
                      initWithProductIdentifiers:productIdentifiers];
    
    _productRequest.delegate = self;
    
    [_productRequest start];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(inAppAlertAppeared)
//                                                 name:UIApplicationWillResignActiveNotification
//                                               object:nil];
    
}

- (BOOL)canMakePurchase
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseProduct:(SKProduct*)product
{
    if ([self canMakePurchase])
    {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Purchases are disabled in your device" message:nil delegate:
                                  self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)restoreInAppPurchases
{
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark StoreKit Delegate

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
            {
//                DebugLog(@"Purchasing Product From Store!");
                [self processingTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStatePurchased:
            {
                [self completeTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateRestored:
            {
                [self restoreTransaction:transaction];
            }
                break;
                
            case SKPaymentTransactionStateFailed:
            {
                [self failedTransaction:transaction];
            }
                break;
                
                
            default:
                break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error
{
    
}

- (void)inAppAlertAppeared
{
    if ([self.delegate respondsToSelector:@selector(iapManagerDidPresentInAppPurchaseAlert:)])
    {
        [self.delegate iapManagerDidPresentInAppPurchaseAlert:self];
    }
}

- (void)processingTransaction:(SKPaymentTransaction *)transaction
{
    if ([self.delegate respondsToSelector:@selector(iapManager:isProcessingTransAction:)])
    {
        [self.delegate iapManager:self isProcessingTransAction:transaction];
    }
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction
{
//    DebugLog(@"completeTransaction...");
    
    if ([self.delegate respondsToSelector:@selector(iapManager:didPurchaseProductWithProductIdentifier:)])
    {
        [self.delegate iapManager:self didPurchaseProductWithProductIdentifier:transaction.payment.productIdentifier];
    }
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction
{
//    DebugLog(@"restoreTransaction...");
    
    if ([self.delegate respondsToSelector:@selector(iapManager:didRestoreProductWithProductIdentifier:)])
    {
        [self.delegate iapManager:self didRestoreProductWithProductIdentifier:transaction.payment.productIdentifier];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction
{
    
//    DebugLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
//        DebugLog(@"Transaction error: %@", transaction.error.localizedDescription);
        if ([self.delegate respondsToSelector:@selector(iapManager:failedPurchaseProductWithError:)])
        {
            [self.delegate iapManager:self failedPurchaseProductWithError:transaction.error];
        }
    }

    if ([self.delegate respondsToSelector:@selector(iapManager:failedPurchaseProductWithError:)])
    {
        [self.delegate iapManager:self failedPurchaseProductWithError:nil];
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}


- (void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    NSUInteger count = [response.products count];
    
    if (count > 0)
    {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{

            _validProductsInStore = [response.products mutableCopy];
            _validProductsInStore = [weakSelf filteredProducts:_validProductsInStore];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([weakSelf.delegate respondsToSelector:@selector(iapManager:didLoadStoreProducts:)])
                {
                    [weakSelf.delegate iapManager:weakSelf didLoadStoreProducts:_validProductsInStore];
                }
            });
        });
    }
}

#pragma mark - Filter Products

- (NSMutableArray *)filteredProducts:(NSMutableArray *)productsToBeFiltered
{
    if ([productsToBeFiltered count] > 0)
    {
        NSMutableArray *discardedProductsArray = [NSMutableArray new];
        
        NSArray *tempProductsArray = [NSArray arrayWithArray:productsToBeFiltered];
        
        @synchronized(tempProductsArray)
        {
            for (SKProduct *product in tempProductsArray)
            {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier])
                {
                    BOOL productIsPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:product.productIdentifier];
                    
                    if (productIsPurchased)
                    {
                        [discardedProductsArray addObject:product];
                    }
                }
            }
        }
    
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@", IAPIdentifiers_SuperChip, IAPIdentifiers_SuperReginald, IAPIdentifiers_SuperLukeLocoLemon, IAPIdentifiers_SuperMikeMcSprinkles, IAPIdentifiers_SuperDustinDoubleMint, IAPIdentifiers_SuperHeroJJJams, IAPIdentifiers_SuperGerry];
        
        NSArray *filteredProducts = [discardedProductsArray filteredArrayUsingPredicate:predicate];
        
        if ([filteredProducts count] > 0)
        {
            NSPredicate *predicate2 = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@", IAPIdentifiers_SuperCookiePack];
            
            NSArray *filteredProducts2 = [productsToBeFiltered filteredArrayUsingPredicate:predicate2];
            
            if ([filteredProducts2 count] > 0)
            {
                [discardedProductsArray addObjectsFromArray:filteredProducts2];
            }
        }
        else
        {
            NSPredicate *predicate3 = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@", IAPIdentifiers_SuperCookiePack];
            
            NSArray *filteredProducts3 = [discardedProductsArray filteredArrayUsingPredicate:predicate3];
            
            if ([filteredProducts3 count] > 0)
            {
                NSPredicate *predicate4 = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@", IAPIdentifiers_SuperChip, IAPIdentifiers_SuperReginald, IAPIdentifiers_SuperLukeLocoLemon, IAPIdentifiers_SuperMikeMcSprinkles, IAPIdentifiers_SuperDustinDoubleMint, IAPIdentifiers_SuperHeroJJJams, IAPIdentifiers_SuperGerry];
                
                NSArray *filteredProducts4 = [productsToBeFiltered filteredArrayUsingPredicate:predicate4];
                
                if ([filteredProducts4 count] > 0)
                {
                    [discardedProductsArray addObjectsFromArray:filteredProducts4];
                }
            }
        }
        
        if ([SGAppDelegate appDelegate].accountDict[@"multipliers"])
        {
            NSArray *multipliers = [SGAppDelegate appDelegate].accountDict[@"multipliers"];
            
            if ([multipliers count] > 0)
            {
                NSPredicate *multipliersPredicate = [NSPredicate predicateWithFormat:@"productIdentifier MATCHES[cd] %@ OR productIdentifier MATCHES[cd] %@", IAPIdentifier_ExtraCoinsForTimePeriod, IAPIdentifier_ExtraCoinsForWorld];
                
                NSArray *filteredMultipliersArray = [productsToBeFiltered filteredArrayUsingPredicate:multipliersPredicate];
                
                if ([filteredMultipliersArray count] > 0)
                {
                    [discardedProductsArray addObjectsFromArray:filteredMultipliersArray];
                }
            }
        }
            
        [productsToBeFiltered removeObjectsInArray:discardedProductsArray];

    }

    return productsToBeFiltered;
}

@end
