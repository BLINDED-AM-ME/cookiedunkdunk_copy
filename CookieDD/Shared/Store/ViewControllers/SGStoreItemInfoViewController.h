//
//  SGStoreItemInfoViewController.h
//  CookieDD
//
//  Created by Josh on 1/15/14.
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

#import <UIKit/UIKit.h>
#import "SGGiftFriendViewController.h"
#import "SGStrokeLabel.h"
#import <StoreKit/StoreKit.h>

typedef enum StoreItemPurchaseType
{
    StoreItemPurchaseType_Default,
    StoreItemPurchaseType_Coins,
    StoreItemPurchaseType_Jewels,
    StoreItemPurchaseType_InAppPurchase,
    StoreItemPurchaseType_AcceptGift

}   StoreItemPurchaseType;

typedef enum StoreItemProductType
{
    StoreItemProductType_Default,
    StoreItemProductType_BombPowerup,
    StoreItemProductType_LighteningBooster,
    StoreItemProductType_SlotMachineBooster,
    StoreItemProductType_SmorePowerup,
    StoreItemProductType_SpatulaBooster,
    StoreItemProductType_RadioActiveSprinklePowerup,
    StoreItemProductType_SuperPowerup,
    StoreItemProductType_WrapperPowerup,
    StoreItemProductType_ExtraTime,
    StoreItemProductType_ExtraMoves,

//    StoreItemProductType_ExtraLives3,
    StoreItemProductType_ExtraLives5,
    StoreItemProductType_ExtraCoinsForTimePeriod,
    StoreItemProductType_ExtraCoinsForWorld,
    StoreItemProductType_CoinPack1000,
    StoreItemProductType_CoinPack2500,
    StoreItemProductType_CoinPack5000,
    StoreItemProductType_CoinPack10000,
    StoreItemProductType_NukeBooster,
    StoreItemProductType_SuperChip,
    StoreItemProductType_SuperDustinDoubleMint,
    StoreItemProductType_SuperGerry,
    StoreItemProductType_SuperLukeLocoLemon,
    StoreItemProductType_SuperMikeMcSprinkles,
    StoreItemProductType_SuperSuperJJJams,
    StoreItemProductType_SuperReginald,
    StoreItemProductType_SuperCookiePack

}   StoreItemProductType;


typedef void (^AnimationCompletionHandler)(BOOL finishedAnimation);

@protocol SGStoreItemInfoViewControllerDelegate;

@interface SGStoreItemInfoViewController : UIViewController <UIGestureRecognizerDelegate>

//@property (weak, nonatomic) IBOutlet UILabel *buyNowLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *buyNowLabel;
@property (weak, nonatomic) IBOutlet UIImageView *raysImageView;
@property (weak, nonatomic) IBOutlet UIImageView *smallRayImageView;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *gemsButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *coinsButtonTextLabel;
@property (weak, nonatomic) IBOutlet SGStrokeLabel *cancelButtonTextLabel;

//@property (strong, nonatomic) UIViewController *parentPresentingViewController;
@property (weak, nonatomic) IBOutlet UIView *faddedBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *itemPopupView;
@property (weak, nonatomic) IBOutlet UILabel *itemInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemPriceLabel;
//@property (weak, nonatomic) IBOutlet SGStrokeLabel *itemInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *itemIconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UIButton *jewelButton;
@property (weak, nonatomic) IBOutlet UIButton *coinButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;

@property (strong, nonatomic) SKProduct *product;
@property (weak, nonatomic) id <SGStoreItemInfoViewControllerDelegate> delegate;
@property (assign, nonatomic) StoreItemPurchaseType storeItemPurchaseType;
@property (assign, nonatomic) StoreItemProductType storeItemProductType;
@property (assign, nonatomic) GiftType giftType;
@property (assign, nonatomic) int productCoinValue;
@property (assign, nonatomic) int productJewelValue;

- (void)animateIn;
- (void)animateOut;
- (void)animateInFromFrame:(CGRect)sourceFrame;
- (IBAction)purchaseWithJewels:(id)sender;
- (IBAction)purchaseWithCoins:(id)sender;
- (IBAction)cancelPurchase:(id)sender;
- (IBAction)showGiftFriendView:(id)sender;

@end

@protocol SGStoreItemInfoViewControllerDelegate <NSObject>

@optional
- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller didPurchaseProduct:(SKProduct *)product;

- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller didPurchaseProductWithProductType:(StoreItemProductType)productType
                       purchaseType:(StoreItemPurchaseType)purchaseType
                          costValue:(int)costValue;

- (void)storeItemInfoViewController:(SGStoreItemInfoViewController *)controller didSelectGiftItemWithGiftValue:(int)giftValue
                           giftType:(GiftType)giftType
                   productCoinValue:(int)productCoinValue
                  productJewelValue:(int)productJewelValue;

- (void)storeItemInfoViewControllerCannotMakePurchase:(SGStoreItemInfoViewController *)controller;

- (void)storeItemInfoViewControllerDidAcceptGift:(SGStoreItemInfoViewController *)controller;
@end
