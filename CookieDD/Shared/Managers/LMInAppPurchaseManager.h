//
//  LMInAppPurchaseManager.h
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

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#define kINAPP_Product_ID @"com.7gungames.cookiedunkdunk.life"

@protocol LMInAppPurchaseManagerDelegate;

@interface LMInAppPurchaseManager : NSObject <SKStoreProductViewControllerDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver>

@property (strong, nonatomic) SKProductsRequest *productRequest;

@property (strong, nonatomic) NSMutableArray *validProductsInStore;

@property (weak, nonatomic) id <LMInAppPurchaseManagerDelegate> delegate;

#pragma mark - Initialization

+ (LMInAppPurchaseManager *)inappPurchaseManager;

#pragma mark - Store Product Request

-(void)getAvailableProductsWithSet:(NSSet *)productIdentifiers;

- (BOOL)canMakePurchase;

- (void)purchaseProduct:(SKProduct*)product;

- (NSMutableArray *)filteredProducts:(NSMutableArray *)productsToBeFiltered;

- (void)restoreInAppPurchases;
@end

@protocol LMInAppPurchaseManagerDelegate <NSObject>

@optional
- (void)iapManager:(LMInAppPurchaseManager *)iapManager didLoadStoreProducts:(NSArray *)products;
- (void)iapManager:(LMInAppPurchaseManager *)iapManager isProcessingTransAction:(SKPaymentTransaction *)transAction;
- (void)iapManagerDidPresentInAppPurchaseAlert:(LMInAppPurchaseManager *)iapManager;
- (void)iapManager:(LMInAppPurchaseManager *)iapManager failedPurchaseProductWithError:(NSError *)error;
- (void)iapManager:(LMInAppPurchaseManager *)iapManager didPurchaseProductWithProductIdentifier:(NSString *)productIdentifier;
- (void)iapManager:(LMInAppPurchaseManager *)iapManager didRestoreProductWithProductIdentifier:(NSString *)productIdentifier;
@end