//
//  CDStoreItemCell.h
//  CookieDD
//
//  Created by Luke McDonald on 3/6/14.
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
#import <StoreKit/StoreKit.h>

typedef enum StoreItemCellPurchaseType
{
    StoreItemCellPurchaseType_Default,
    StoreItemCellPurchaseType_Coins,
    StoreItemCellPurchaseType_Jewels,
    StoreItemCellPurchaseType_InAppPurchase
    
}   StoreItemCellPurchaseType;

typedef enum StoreItemCellProductType
{
    StoreItemCellProductType_Default,
    StoreItemCellProductType_BombPowerup,
    StoreItemCellProductType_LighteningBooster,
    StoreItemCellProductType_SlotMachineBooster,
    StoreItemCellProductType_SmorePowerup,
    StoreItemCellProductType_SpatulaBooster,
    StoreItemCellProductType_RadioActiveSprinklePowerup,
    StoreItemCellProductType_SuperPowerup,
    StoreItemCellProductType_WrapperPowerup,
    StoreItemCellProductType_ExtraTime,
    StoreItemCellProductType_ExtraMoves,
    StoreItemCellProductType_ExtraLives3,
    StoreItemCellProductType_ExtraLives5,
    StoreItemCellProductType_ExtraCoinsForTimePeriod,
    StoreItemCellProductType_ExtraCoinsForWorld,
    StoreItemCellProductType_CoinPack1000,
    StoreItemCellProductType_CoinPack2000,
    StoreItemCellProductType_CoinPack5000,
    StoreItemCellProductType_CoinPack10000,
    StoreItemCellProductType_NukeBooster,
    
    StoreItemCellProductType_SuperChip,
    StoreItemCellProductType_SuperDustinDoubleMint,
    StoreItemCellProductType_SuperGerry,
    StoreItemCellProductType_SuperLukeLocoLemon,
    StoreItemCellProductType_SuperMikeMcSprinkles,
    StoreItemCellProductType_SuperSuperJJJams,
    StoreItemCellProductType_SuperReginald,
    StoreItemCellProductType_SuperCookiePack,
    
    StoreItemCellProductType_ChefDustinDoubleMint,
    StoreItemCellProductType_ChefChip,
    StoreItemCellProductType_ChefGerry,
    StoreItemCellProductType_ChefJJJams,
    StoreItemCellProductType_ChefLukeLocoLemon,
    StoreItemCellProductType_ChefMikeMcSprinkles,
    StoreItemCellProductType_ChefReginald,
    StoreItemCellProductType_ChefCookiePack,
    
    StoreItemCellProductType_FarmerChip,
    StoreItemCellProductType_FarmerDustinDoubleMint,
    StoreItemCellProductType_FarmerGerryJ,
    StoreItemCellProductType_FarmerJJJamz,
    StoreItemCellProductType_FarmerLukeLocoLemon,
    StoreItemCellProductType_FarmerMikeyMcSprinkles,
    StoreItemCellProductType_FarmerReginald,
    StoreItemCellProductType_FarmerCookiePack,
    
    
    StoreItemCellProductType_ZombieChip,
    StoreItemCellProductType_ZombieDustinDoubleMint,
    StoreItemCellProductType_ZombieGerryJ,
    StoreItemCellProductType_ZombieJJJamz,
    StoreItemCellProductType_ZombieLukeLocoLemon,
    StoreItemCellProductType_ZombieMikeyMcSprinkles,
    StoreItemCellProductType_ZombieReginald,
    StoreItemCellProductType_ZombieCookiePack
    
}   StoreItemCellProductType;

@interface CDStoreItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UIImageView *priceTagImageView;
@property (weak, nonatomic) IBOutlet UILabel *productPriceLabel;
@property (strong, nonatomic) NSString *productTitle;
@property (strong, nonatomic) NSString *productDescription;
@property (strong, nonatomic) NSString *productPrice;
@property (strong, nonatomic) SKProduct *product;
@property (assign, nonatomic) int productCoinValue;
@property (assign, nonatomic) int productJewelValue;
@property (assign, nonatomic) StoreItemCellPurchaseType purchaseType;
@property (assign, nonatomic) StoreItemCellProductType productType;

- (void)configureInGameCurrensySystem;

@end
