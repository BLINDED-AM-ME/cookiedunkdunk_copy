//
//  CDStoreItemCell.m
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

#import "CDStoreItemCell.h"
#import "CDIAPManager.h"

@implementation CDStoreItemCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureInGameCurrensySystem
{
    [self checkItemType:self.productType];
 
    [self setupUI:self.purchaseType];
}

- (void)checkItemType:(StoreItemCellProductType)itemProductType
{
    int gemCosts = 0;
    
    int coinCosts = 0;
    
    switch (itemProductType)
    {
        case StoreItemCellProductType_Default:
        {
            
        }
            break;
        
        case StoreItemCellProductType_BombPowerup:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_BombPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_BombPowerup];
        }
            break;
            
        case StoreItemCellProductType_CoinPack1000:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack1000];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack1000];
        }
            break;
            
        case StoreItemCellProductType_CoinPack2000:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack2000];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack2000];
        }
            break;
            
        case StoreItemCellProductType_CoinPack5000:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack5000];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack5000];
        }
            break;
            
        case StoreItemCellProductType_CoinPack10000:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack10000];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_CoinPack10000];
        }
            break;
            
        case StoreItemCellProductType_ExtraCoinsForTimePeriod:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraCoinsForTimePeriod];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraCoinsForTimePeriod];
        }
            break;
            
        case StoreItemCellProductType_ExtraCoinsForWorld:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraCoinsForWorld];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraCoinsForWorld];
        }
            break;
            
//        case StoreItemCellProductType_ExtraLives3:
//        {
//            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraLives3];
//            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraLives3];
//        }
//            break;
            
        case StoreItemCellProductType_ExtraLives5:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraLives5];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraLives5];
        }
            break;
            
        case StoreItemCellProductType_ExtraMoves:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraMoves];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraMoves];
        }
            break;
            
        case StoreItemCellProductType_ExtraTime:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraTime];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_ExtraTime];
        }
            break;
            
        case StoreItemCellProductType_LighteningBooster:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_LightningBooster];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_LightningBooster];
        }
            break;
            
        case StoreItemCellProductType_NukeBooster:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_NukeBooster];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_NukeBooster];
        }
            break;
            
        case StoreItemCellProductType_RadioActiveSprinklePowerup:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup];
        }
            break;
            
        case StoreItemCellProductType_SlotMachineBooster:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SlotMachineBooster];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SlotMachineBooster];
        }
            break;
            
        case StoreItemCellProductType_SmorePowerup:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SmorePowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SmorePowerup];
        }
            break;
            
        case StoreItemCellProductType_SpatulaBooster:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SpatulaBooster];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SpatulaBooster];
        }
            break;
            
        case StoreItemCellProductType_SuperChip:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperCookiePack:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperDustinDoubleMint:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperGerry:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperLukeLocoLemon:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperMikeMcSprinkles:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperPowerup:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperReginald:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_SuperSuperJJJams:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_SuperPowerup];
        }
            break;
            
        case StoreItemCellProductType_WrapperPowerup:
        {
            gemCosts = [[CDIAPManager iapMananger] getItemGemCostWithItemCostType:ItemCostType_IAPIdentifier_WrapperPowerup];
            coinCosts = [[CDIAPManager iapMananger] getItemCoinCostWithItemCostType:ItemCostType_IAPIdentifier_WrapperPowerup];
        }
            break;
            
        default:
            break;
    }
    
    self.productCoinValue = coinCosts;
    
    self.productJewelValue = gemCosts;
}

- (void)setupUI:(StoreItemCellPurchaseType)purchaseType
{
    switch (purchaseType)
    {
        case StoreItemCellPurchaseType_Default:
        {
            
        }
            break;
        
        case StoreItemCellPurchaseType_Coins:
        {
            self.productPriceLabel.text = [NSString stringWithFormat:@"%i", self.productCoinValue];
        }
            break;
        
        case StoreItemCellPurchaseType_Jewels:
        {
            self.productPriceLabel.text = [NSString stringWithFormat:@"%i", self.productJewelValue];
        }
            break;
        
        case StoreItemCellPurchaseType_InAppPurchase:
        {
            
        }
            break;
        default:
            break;
    }
}

@end
