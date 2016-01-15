//
//  CDIAPManager.m
//  CookieDD
//
//  Created by Luke McDonald on 3/7/14.
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

#import "CDIAPManager.h"
#import "WebserviceManager.h"
#import "SGAppDelegate.h"

static CDIAPManager *iapManager = nil;

@interface CDIAPManager ()

@end

@implementation CDIAPManager

#pragma mark - Initialization

+ (CDIAPManager *)iapMananger
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [LMInAppPurchaseManager inappPurchaseManager];
        
        iapManager = [CDIAPManager new];
        
        iapManager.multipliersArray = [NSMutableArray new];
    });
    
    return iapManager;
}

- (void)requestProducts
{
    NSSet *productIdentifiers = [NSSet setWithObjects:IAPIdentifier_CoinPack1000,
                                 IAPIdentifier_CoinPack2000,
                                 IAPIdentifier_CoinPack5000,
                                 IAPIdentifier_CoinPack10000,
//                                 IAPIdentifier_ExtraCoinsForTimePeriod,
//                                 IAPIdentifier_ExtraCoinsForWorld,
//                                 IAPIdentifier_ExtraLives3,
                                 IAPIdentifier_ExtraLives5,
//                                 IAPIdentifier_ExtraMoves,
//                                 IAPIdentifier_ExtraTime,
                                 IAPIdentifier_NukeBooster,
                                 IAPIdentifier_LightningBooster,
                                 IAPIdentifier_SpatulaBooster,
                                 IAPIdentifier_RadioactiveSprinklePowerup,
                                 IAPIdentifier_SlotMachineBooster,
                                 IAPIdentifier_SuperPowerup,
                                 IAPIdentifier_WrapperPowerup,
                                 IAPIdentifier_SmorePowerup,
                                 
                                 IAPIdentifiers_SuperChip,
                                 IAPIdentifiers_SuperDustinDoubleMint,
                                 IAPIdentifiers_SuperGerry,
                                 IAPIdentifiers_SuperLukeLocoLemon,
                                 IAPIdentifiers_SuperMikeMcSprinkles,
                                 IAPIdentifiers_SuperReginald,
                                 IAPIdentifiers_SuperCookiePack,
                                 
                                 IAPIdentifiers_ChefDustinDoubleMint,
                                 IAPIdentifiers_ChefGerry,
                                 IAPIdentifiers_ChefJJJams,
                                 IAPIdentifiers_ChefLukeLocoLemon,
                                 IAPIdentifiers_ChefMikeMcSprinkles,
                                 IAPIdentifiers_ChefReginald,
                                 IAPIdentifiers_ChefCookiePack,
                                 
                                 IAPIdentifiers_FarmerChip,
                                 IAPIdentifiers_FarmerGerryJ,
                                 IAPIdentifiers_FarmerJJJams,
                                 IAPIdentifiers_FarmerLukeLocoLemon,
                                 IAPIdentifiers_FarmerMikeyMcSprinkles,
                                 IAPIdentifiers_FarmerReginald,
                                 IAPIdentifiers_FarmerCookiePack,
                                 
                                 IAPIdentifiers_ZombieChip,
                                 IAPIdentifiers_ZombieDustinMartianMint,
                                 IAPIdentifiers_ZombieJJJams,
                                 IAPIdentifiers_ZombieLukeLocoLemon,
                                 IAPIdentifiers_ZombieMikeyMcSprinkles,
                                 IAPIdentifiers_ZombieReginald,
                                 IAPIdentifiers_ZombieCookiePack,
                                 
                                 nil];
    
    [self getAvailableProductsWithSet:productIdentifiers];
}

- (void)requestSpecificProductsWithProductIdentifiers:(NSSet *)productIdentifiers
{
    if (productIdentifiers && [productIdentifiers count] > 0)
    {
        [self getAvailableProductsWithSet:productIdentifiers];
    }
    else
    {
        DebugLog(@"Must return NSSet of product Identifiers! Look in LMInAppPurchaseManager:requestSpecificProductsWithProductIdentifiers:");
    }
}

#pragma mark - Item Costs Values

- (int)getItemCoinCostWithItemCostType:(ItemCostType)itemCostType
{
    int itemCoinCosts = [self checkItemCostType:itemCostType costType:CostType_Coins];
    
    return itemCoinCosts;
}

- (int)getItemGemCostWithItemCostType:(ItemCostType)itemCostType
{
    int itemGemCosts = [self checkItemCostType:itemCostType costType:CostType_Gems];
    
    return itemGemCosts;
}

#pragma mark - Currency Check

- (BOOL)canPurchaeItemWithItemCosts:(int)itemCostValue currentCurrency:(int)currentCurrency
{
    BOOL canPurchase = YES;
    
    DebugLog(@"currentCurrency => %i", currentCurrency);
    
    int currencyAfterPurchase = (currentCurrency - itemCostValue);
    
    DebugLog(@"currencyAfterPurchase => %i", currencyAfterPurchase);
    
    if (currencyAfterPurchase < 0) canPurchase = NO;
    
    return canPurchase;
}

#pragma mark - Webservice Manager Wrapper Calls

#pragma mark - Update Moves

- (void)requestToIncreaseMovesValue:(NSNumber *)movesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentMovesValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueMoves]) currentMovesValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueMoves] intValue]];
    
    if (movesValue) movesValue = [NSNumber numberWithInt:([currentMovesValue intValue] + [movesValue intValue])];
    
    if (movesValue) gameParams[KeyValueMoves] = movesValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
    {
        if (handler) handler(error, gameParametersInfoDict);
    }];
}

- (void)requestToDecreaseMovesValue:(NSNumber *)movesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentMovesValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueMoves]) currentMovesValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueMoves] intValue]];
    
    if(movesValue) movesValue = [NSNumber numberWithInt:([currentMovesValue intValue] - [movesValue intValue])];
    
    if (movesValue) gameParams[KeyValueMoves] = movesValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

#pragma mark - Update Lives

- (void)requestToIncreaseLivesValue:(NSNumber *)livesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentLivesValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueLives]) currentLivesValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueLives] intValue]];
    
    if (livesValue) livesValue = [NSNumber numberWithInt:([currentLivesValue intValue] + [livesValue intValue])];
    
    if (livesValue) gameParams[KeyValueLives] = livesValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

- (void)requestToDecreaseLivesValue:(NSNumber *)livesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentLivesValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueLives]) currentLivesValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueLives] intValue]];
    
    if (livesValue) livesValue = [NSNumber numberWithInt:([currentLivesValue intValue] - [livesValue intValue])];
    
    if (livesValue) gameParams[KeyValueLives] = livesValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

#pragma mark - Update Coins

- (void)requestToIncreaseCoinsValue:(NSNumber *)coinsValue
                           costValue:(NSNumber *)costValue
                            costType:(CostType)costType
                   completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentCoinsValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueCoins]) currentCoinsValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueCoins] intValue]];
    
    if (coinsValue) coinsValue = [NSNumber numberWithInt:([currentCoinsValue intValue] + [coinsValue intValue])];
    
    if (coinsValue) gameParams[KeyValueCoins] = coinsValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

- (void)requestToDecreaseCoinsValue:(NSNumber *)coinsValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentCoinsValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueCoins]) currentCoinsValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueCoins] intValue]];
    
    if (coinsValue) coinsValue = [NSNumber numberWithInt:([currentCoinsValue intValue] - [coinsValue intValue])];
    
    if (coinsValue) gameParams[KeyValueCoins] = coinsValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

#pragma mark - Update Gems

- (void)requestToIncreaseGemsValue:(NSNumber *)gemsValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentGemsValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueGems]) currentGemsValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueGems] intValue]];
    
    if (gemsValue) gemsValue = [NSNumber numberWithInt:([currentGemsValue intValue] + [gemsValue intValue])];
    
    if (gemsValue) gameParams[KeyValueGems] = gemsValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

- (void)requestToDecreaseGemsValue:(NSNumber *)gemsValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    NSNumber *currentGemsValue = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[KeyValueGems]) currentGemsValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[KeyValueGems] intValue]];
    
    if (gemsValue) gemsValue = [NSNumber numberWithInt:([currentGemsValue intValue] - [gemsValue intValue])];
    
    if (gemsValue) gameParams[KeyValueGems] = gemsValue;
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}


#pragma mark - Update Boosters

- (void)requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:(NSNumber *)radioactiveSprinkleValue
                                                       spatulaValue:(NSNumber *)spatulaValue
                                                   slotMachineValue:(NSNumber *)slotMachineValue
                                                   thunderboltValue:(NSNumber *)thunderboltValue
                                                          nukeValue:(NSNumber *)nukeValue
                                                          costValue:(NSNumber *)costValue
                                                           costType:(CostType)costType
                                                  completionHandler:(GameParamtersCompletionHandler)handler;
{
    NSMutableDictionary *boosterDict = [NSMutableDictionary new];
    
    if ([SGAppDelegate appDelegate].accountDict[@"boosters"]) boosterDict = [[SGAppDelegate appDelegate].accountDict[@"boosters"] mutableCopy];
    
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    if (radioactiveSprinkleValue && boosterDict[KeyValueRadioactiveSprinkle]) gameParams[KeyValueRadioactiveSprinkle] = [NSNumber numberWithInt:([boosterDict[KeyValueRadioactiveSprinkle] intValue] - [radioactiveSprinkleValue intValue])];
   
    if (spatulaValue && boosterDict[KeyValueSpatula]) gameParams[KeyValueSpatula] = [NSNumber numberWithInt:([boosterDict[KeyValueSpatula] intValue] - [spatulaValue intValue])];
    
    if (slotMachineValue && boosterDict[KeyValueSlotMachine]) gameParams[KeyValueSlotMachine] = [NSNumber numberWithInt:([boosterDict[KeyValueSlotMachine] intValue] - [slotMachineValue intValue])];
    
    if (thunderboltValue && boosterDict[KeyValueThunderbolt]) gameParams[KeyValueThunderbolt] = [NSNumber numberWithInt:([boosterDict[KeyValueThunderbolt] intValue] - [thunderboltValue intValue])];

    if (nukeValue && boosterDict[KeyValueNuke]) gameParams[KeyValueNuke] = [NSNumber numberWithInt:([boosterDict[KeyValueNuke] intValue] - [nukeValue intValue])];
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

- (void)requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:(NSNumber *)radioactiveSprinkleValue
                                                       spatulaValue:(NSNumber *)spatulaValue
                                                   slotMachineValue:(NSNumber *)slotMachineValue
                                                   thunderboltValue:(NSNumber *)thunderboltValue
                                                          nukeValue:(NSNumber *)nukeValue
                                                          costValue:(NSNumber *)costValue
                                                           costType:(CostType)costType
                                                  completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *boosterDict = [NSMutableDictionary new];
    
    if ([SGAppDelegate appDelegate].accountDict[@"boosters"]) boosterDict = [[SGAppDelegate appDelegate].accountDict[@"boosters"] mutableCopy];
    
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    if (radioactiveSprinkleValue && boosterDict[KeyValueRadioactiveSprinkle]) gameParams[KeyValueRadioactiveSprinkle] = [NSNumber numberWithInt:([boosterDict[KeyValueRadioactiveSprinkle] intValue] + [radioactiveSprinkleValue intValue])];
    
    if (spatulaValue && boosterDict[KeyValueSpatula]) gameParams[KeyValueSpatula] = [NSNumber numberWithInt:([boosterDict[KeyValueSpatula] intValue] + [spatulaValue intValue])];
    
    if (slotMachineValue && boosterDict[KeyValueSlotMachine]) gameParams[KeyValueSlotMachine] = [NSNumber numberWithInt:([boosterDict[KeyValueSlotMachine] intValue] + [slotMachineValue intValue])];
    
    if (thunderboltValue && boosterDict[KeyValueThunderbolt]) gameParams[KeyValueThunderbolt] = [NSNumber numberWithInt:([boosterDict[KeyValueThunderbolt] intValue] + [thunderboltValue intValue])];
    
    if (nukeValue && boosterDict[KeyValueNuke]) gameParams[KeyValueNuke] = [NSNumber numberWithInt:([boosterDict[KeyValueNuke] intValue] + [nukeValue intValue])];
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

#pragma mark - Update Powerups

- (void)requestToUpdatePowerupsWithDecreasePowerGloveValue:(NSNumber *)powerGloveValue
                       wrappedCookieValue:(NSNumber *)wrappedCookieValue
                                bombValue:(NSNumber *)bombValue
                               smoreValue:(NSNumber *)smoreValue
                                costValue:(NSNumber *)costValue
                                 costType:(CostType)costType
                        completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *powerupsDict = [NSMutableDictionary new];
    
    if ([SGAppDelegate appDelegate].accountDict[@"powerups"]) powerupsDict = [[SGAppDelegate appDelegate].accountDict[@"powerups"] mutableCopy];
    
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    if (powerGloveValue && powerupsDict[KeyValuePowerGlove]) gameParams[KeyValuePowerGlove] = [NSNumber numberWithInt:([powerupsDict[KeyValuePowerGlove] intValue] - [powerGloveValue intValue])];
    
    if (wrappedCookieValue && powerupsDict[KeyValueWrappedCookie]) gameParams[KeyValueWrappedCookie] = [NSNumber numberWithInt:([powerupsDict[KeyValueWrappedCookie] intValue] - [wrappedCookieValue intValue])];
    
    if (bombValue && powerupsDict[KeyValueBomb]) gameParams[KeyValueBomb] = [NSNumber numberWithInt:([powerupsDict[KeyValueBomb] intValue] - [bombValue intValue])];
    
    if (smoreValue && powerupsDict[KeyValueSmore]) gameParams[KeyValueSmore] = [NSNumber numberWithInt:([powerupsDict[KeyValueSmore] intValue] - [smoreValue intValue])];
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

- (void)requestToUpdatePowerupsWithIncreasePowerGloveValue:(NSNumber *)powerGloveValue
                                wrappedCookieValue:(NSNumber *)wrappedCookieValue
                                         bombValue:(NSNumber *)bombValue
                                        smoreValue:(NSNumber *)smoreValue
                                         costValue:(NSNumber *)costValue
                                          costType:(CostType)costType
                                 completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableDictionary *powerupsDict = [NSMutableDictionary new];
    
    if ([SGAppDelegate appDelegate].accountDict[@"powerups"]) powerupsDict = [[SGAppDelegate appDelegate].accountDict[@"powerups"] mutableCopy];
    
    NSMutableDictionary *gameParams = [NSMutableDictionary new];
    
    if (powerGloveValue && powerupsDict[KeyValuePowerGlove]) gameParams[KeyValuePowerGlove] = [NSNumber numberWithInt:([powerupsDict[KeyValuePowerGlove] intValue] + [powerGloveValue intValue])];
    
    if (wrappedCookieValue && powerupsDict[KeyValueWrappedCookie]) gameParams[KeyValueWrappedCookie] = [NSNumber numberWithInt:([powerupsDict[KeyValueWrappedCookie] intValue] + [wrappedCookieValue intValue])];
    
    if (bombValue && powerupsDict[KeyValueBomb]) gameParams[KeyValueBomb] = [NSNumber numberWithInt:([powerupsDict[KeyValueBomb] intValue] + [bombValue intValue])];
    
    if (smoreValue && powerupsDict[KeyValueSmore]) gameParams[KeyValueSmore] = [NSNumber numberWithInt:([powerupsDict[KeyValueSmore] intValue] + [smoreValue intValue])];
    
    NSString *costTypeString = [self checkCostType:costType];
    
    NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
    
    if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
    
    if (costValue && costTypeString) gameParams[costTypeString] = costValue;
    
    [[WebserviceManager sharedManager] requestToUpdateGameParametersWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               gameParamsDict:gameParams
                                                            completionHandler:^
     (NSError *error, NSDictionary *gameParametersInfoDict)
     {
         if (handler) handler(error, gameParametersInfoDict);
     }];
}

#pragma mark - Update Cookie Costumes

- (void)requestToUpdateCookiePacksWithCookiePackType:(CookieCostumeType)cookieCostumeType
                                  willUnlockReginald:(BOOL)willUnlockReginald
                                      willUnlockChip:(BOOL)willUnlockChip
                         willUnlockDustinMartianMint:(BOOL)willUnlockDustinMartianMint
                             willUnlockLukeLocoLemon:(BOOL)willUnlockLukeLocoLemon
                          willUnlockMikeyMcSprinkles:(BOOL)willUnlockMikeyMcSprinkles
                                    willUnlockJJJams:(BOOL)willUnlockJJJams
                                    willUnlockGerryJ:(BOOL)willUnlockGerryJ
                                   completionHandler:(GameParamtersCompletionHandler)handler
{
    NSMutableArray *cookiesArray = [NSMutableArray new];
    
    NSString *cookieCostumeTypeString = [self checkCookieCostumeType:cookieCostumeType];
    
    NSPredicate *cookieThemePredicate = nil;
    
    if ([SGAppDelegate appDelegate].accountDict[@"cookieCostumes"])
    {
        NSMutableArray *cookieCostumesArray = [[SGAppDelegate appDelegate].accountDict[@"cookieCostumes"] mutableCopy];
        
        if ([cookieCostumesArray isKindOfClass:[NSMutableArray class]])
        {
            if (cookieCostumeTypeString)
            {
                cookieThemePredicate = [NSPredicate predicateWithFormat:@"theme MATCHES[cd] %@", cookieCostumeTypeString];
                
                NSArray *themedCookieCostumesArray = [cookieCostumesArray filteredArrayUsingPredicate:cookieThemePredicate];
                
                if ([themedCookieCostumesArray count] > 0)
                {
                    NSPredicate *cookieNamePredicate = nil;
                    /*
                     // Key Values currentSelectedCookieID, isSelected, isUnlocked, newlySelectedCookieId
                     
                     [updateCookieCostumes addObject:@{
                     @"currentSelectedCookieId": @"53534b30d43fe94d134f5abb",
                     @"isSelected": [NSNumber numberWithBool:YES],
                     @"isUnlocked": [NSNumber numberWithBool:YES],
                     @"newlySelectedCookieId": @"53534b30d43fe94d134f5ac2"}];
                     */
                
                    // Reginald Unlock...
                    if (willUnlockReginald)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameReginald];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                   
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
                    
                    
                    // Chip Unlock...
                    if (willUnlockChip)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameChip];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                    
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
                   
                    
                    // Dustin Unlock...
                    if (willUnlockDustinMartianMint)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameDustinMartianMint];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
              
                    // Luke Unlock...
                    if (willUnlockLukeLocoLemon)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameLukeLocoLemon];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
                   
                    // Mike Unlock...
                    if (willUnlockMikeyMcSprinkles)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameMikeyMcSprinkles];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                    
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
                   
                    
                    // JJJams Unlock...
                    if (willUnlockJJJams)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameJJJams];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = @"This is a string. There are many like it, but this one is mine!";;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                    
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
            
                    // GerryJ Unlock...
                    if (willUnlockGerryJ)
                    {
                        cookieNamePredicate = [NSPredicate predicateWithFormat:@"name MATCHES[cd] %@", KeyNameGerryJ];
                        
                        NSArray *filterArray = [themedCookieCostumesArray filteredArrayUsingPredicate:cookieNamePredicate];
                        
                        if ([filterArray count] > 0)
                        {
                            NSMutableDictionary *cookieInfoDict = filterArray[0];
                            
                            if ([cookieInfoDict isKindOfClass:[NSMutableDictionary class]])
                            {
                                NSString *cookieCostumeId = nil;
                                
                                if (cookieInfoDict[@"_id"])
                                {
                                    cookieCostumeId = cookieInfoDict[@"_id"];
                                
                                    NSMutableDictionary *updatedCookieCostumeDict = [NSMutableDictionary new];
                                    
                                    //updatedCookieCostumeDict[@"newlySelectedCookieId"] = cookieCostumeId;
                                    updatedCookieCostumeDict[@"_id"] = cookieCostumeId;
                                    
                                    updatedCookieCostumeDict[@"isUnlocked"] = [NSNumber numberWithBool:YES];
                                    
                                    [cookiesArray addObject:updatedCookieCostumeDict];
                                }
                            }
                        }
                    }
                    
                    // end check for themed cookies
                }
                
            }
        }
    }
    
    // Hit Webservice for Cookie Costume Unlocks
    [[WebserviceManager sharedManager] requestToUpdateCookieCostumesWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                     deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                               cookieCostumes:cookiesArray
                                                            completionHandler:^
     (NSError *error, NSDictionary *cookieCostumesInfo)
    {
        if (handler) handler(error, cookieCostumesInfo);
    }];
}

#pragma mark - Update Multipliers

- (void)requestToAddTimeMultiplierWithMultiplierType:(MultipliersType)multiplierType
                                           costValue:(NSNumber *)costValue
                                            costType:(CostType)costType
                                   completionHandler:(GameParamtersCompletionHandler)handler
{
    if ([_multipliersArray count] == 0)
    {
        NSString *multiplierTypeString = [self checkMultiplierType:multiplierType];
        
        int startTime = [[NSDate date] timeIntervalSince1970];
        
        NSString *startTimeString = [NSString stringWithFormat:@"%i", startTime];
        
        NSDate *endDate = [NSDate dateWithTimeIntervalSinceNow:2400];
        
        __block int endTime = [endDate timeIntervalSinceDate:[NSDate date]];
        
        NSString *endTimeString = [NSString stringWithFormat:@"%i", endTime];
        
        NSString *costTypeString = [self checkCostType:costType];
        
        NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
        
        if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
        
        switch (costType) {
            case CostType_Default:
            {
                
            }
                break;
            
            case CostType_Coins:
            {
                [[WebserviceManager sharedManager] requestToCreateMultiplierWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                             deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                                           multiplierType:multiplierTypeString
                                                                                startTime:startTimeString
                                                                                  endTime:endTimeString
                                                                                   levels:nil
                                                                                 gemCosts:nil
                                                                                coinCosts:costValue
                                                                        completionHandler:^
                     (NSError *error, NSDictionary *multiplierInfoDict)
                     {
                         if (!error && multiplierInfoDict)
                         {
                             if (handler) handler(error, multiplierInfoDict);
                             
                             DebugLog(@"multiplierInfoDict: %@", multiplierInfoDict);
                             
                             if (multiplierInfoDict[@"parameters"])
                             {
                                 NSDictionary *parametersDict = multiplierInfoDict[@"parameters"];
                                 
                                 if (parametersDict[@"multiplier"])
                                 {
                                     NSDictionary *multiplierDict = parametersDict[@"multiplier"];
                                     
                                     [_multipliersArray addObject:multiplierDict];
                                     
                                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(endTime * NSEC_PER_SEC));
                                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                         
                                         if ([_multipliersArray count] > 0)
                                         {
                                             NSDictionary *multiInfoDict = (NSDictionary *)[_multipliersArray firstObject];
                                             
                                             NSString *multiplierId = nil;
                                             
                                             if (multiInfoDict[@"_id"])
                                             {
                                                 multiplierId = multiInfoDict[@"_id"];
                                                 [self requestToRemoveMultiplierWithId:multiplierId completionHandler:nil];
                                             }
                                         }
                                     });
                                 }
                             }
                         }
                     }];
            }
                break;
                
            case CostType_Gems:
            {
                    [[WebserviceManager sharedManager] requestToCreateMultiplierWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                                 deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                                           multiplierType:multiplierTypeString
                                                                                startTime:startTimeString
                                                                                  endTime:endTimeString
                                                                                   levels:nil
                                                                                 gemCosts:costValue
                                                                                coinCosts:nil
                                                                        completionHandler:^
                     (NSError *error, NSDictionary *multiplierInfoDict)
                     {
                         if (!error && multiplierInfoDict)
                         {
                             if (handler) handler(error, multiplierInfoDict);
                             
                             DebugLog(@"multiplierInfoDict: %@", multiplierInfoDict);
                             
                             if (multiplierInfoDict[@"parameters"])
                             {
                                 NSDictionary *parametersDict = multiplierInfoDict[@"parameters"];
                                 
                                 if (parametersDict[@"multiplier"])
                                 {
                                     NSDictionary *multiplierDict = parametersDict[@"multiplier"];
                                     
                                     [_multipliersArray addObject:multiplierDict];
                                     
                                     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(endTime * NSEC_PER_SEC));
                                     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                                         
                                         if ([_multipliersArray count] > 0)
                                         {
                                             NSDictionary *multiInfoDict = (NSDictionary *)[_multipliersArray firstObject];
                                             
                                             NSString *multiplierId = nil;
                                             
                                             if (multiInfoDict[@"_id"])
                                             {
                                                 multiplierId = multiInfoDict[@"_id"];
                                                 [self requestToRemoveMultiplierWithId:multiplierId completionHandler:nil];
                                             }
                                         }
                                     });
                                 }
                             }
                         }
                     }];
            }
                break;
            
                
            default:
                break;
        }
   
    }
}

- (void)requestToAddLevelMultiplierWithMultiplierType:(MultipliersType)multiplierType
                                            costValue:(NSNumber *)costValue
                                             costType:(CostType)costType
                                    completionHandler:(GameParamtersCompletionHandler)handler
{
    if ([_multipliersArray count] == 0)
    {
        NSString *multiplierTypeString = [self checkMultiplierType:multiplierType];
        
        NSString *levelsAmount = @"3";
        
        NSString *costTypeString = [self checkCostType:costType];
        
        NSNumber *deductedCostValue = [NSNumber numberWithInt:[[SGAppDelegate appDelegate].accountDict[costTypeString] intValue]];
        
        if (costValue && costTypeString) costValue = [NSNumber numberWithInt:([deductedCostValue intValue] - [costValue intValue])];
        
        switch (costType) {
            case CostType_Default:
            {
                
            }
                break;
            
            case CostType_Gems:
            {
                    [[WebserviceManager sharedManager] requestToCreateMultiplierWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                                 deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                                           multiplierType:multiplierTypeString
                                                                                startTime:nil
                                                                                  endTime:nil
                                                                                   levels:levelsAmount
                                                                                 gemCosts:costValue
                                                                                coinCosts:nil
                                                                        completionHandler:^
                     (NSError *error, NSDictionary *multiplierInfoDict)
                     {
                         if (!error && multiplierInfoDict)
                         {
                             if (handler) handler(error, multiplierInfoDict);
                             
                             DebugLog(@"multiplierInfoDict: %@", multiplierInfoDict);
                             
                             if (multiplierInfoDict[@"parameters"])
                             {
                                 NSDictionary *parametersDict = multiplierInfoDict[@"parameters"];
                                 
                                 if (parametersDict[@"multiplier"])
                                 {
                                     NSDictionary *multiplierDict = parametersDict[@"multiplier"];
                                     
                                     [_multipliersArray addObject:multiplierDict];
                                 }
                             }
                         }
                     }];
            }
                break;
                
            case CostType_Coins:
            {
                    [[WebserviceManager sharedManager] requestToCreateMultiplierWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                                 deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                                           multiplierType:multiplierTypeString
                                                                                startTime:nil
                                                                                  endTime:nil
                                                                                   levels:levelsAmount
                                                                                 gemCosts:nil
                                                                                coinCosts:costValue
                                                                        completionHandler:^
                     (NSError *error, NSDictionary *multiplierInfoDict)
                     {
                         if (!error && multiplierInfoDict)
                         {
                             if (handler) handler(error, multiplierInfoDict);
                             
                             DebugLog(@"multiplierInfoDict: %@", multiplierInfoDict);
                             
                             if (multiplierInfoDict[@"parameters"])
                             {
                                 NSDictionary *parametersDict = multiplierInfoDict[@"parameters"];
                                 
                                 if (parametersDict[@"multiplier"])
                                 {
                                     NSDictionary *multiplierDict = parametersDict[@"multiplier"];
                                     
                                     [_multipliersArray addObject:multiplierDict];
                                 }
                             }
                         }
                     }];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)requestToRemoveMultiplierWithId:(NSString *)multiplierId
                      completionHandler:(GameParamtersCompletionHandler)handler
{
    [[WebserviceManager sharedManager] requestToRemoveMultiplierWithEmail:[[SGAppDelegate appDelegate] fetchPlayerEmail]
                                                                 deviceId:[[SGAppDelegate appDelegate] fetchPlayerDeviceID]
                                                             multiplierId:multiplierId
                                                        completionHandler:^
     (NSError *error, NSDictionary *multiplierInfoDict)
    {
        if (!error && multiplierInfoDict)
        {
            [_multipliersArray removeAllObjects];
            
            if (handler) handler(error, multiplierInfoDict);
        }
    }];
}

- (void)requestToDecreaseLevelMultiplier;
{
    if ([SGAppDelegate appDelegate].accountDict[@"multipliers"])
    {
        NSMutableArray *multipliers = [[SGAppDelegate appDelegate].accountDict[@"multipliers"] mutableCopy];
        
        if ([multipliers count] > 0)
        {
            NSMutableDictionary *multiplierInfoDict = [[multipliers firstObject] mutableCopy];
            
            if ([multiplierInfoDict isKindOfClass:[NSMutableDictionary class]])
            {
                if (multiplierInfoDict[@"levels"])
                {
                    int currentMultiplierLevel = [multiplierInfoDict[@"levels"] intValue];
                   
                    if (currentMultiplierLevel > 0)
                    {
                        currentMultiplierLevel -= 1;
                        
                        multiplierInfoDict[@"levels"] = [NSNumber numberWithInt:currentMultiplierLevel];
                        
                        [SGAppDelegate appDelegate].accountDict[@"multipliers"] = multipliers;
                        
                        if (currentMultiplierLevel == 0)
                        {
                            if (multiplierInfoDict[@"_id"])
                            {
                                NSString *multiplierId = multiplierInfoDict[@"_id"];
                                
                                [self requestToRemoveMultiplierWithId:multiplierId completionHandler:nil];
                            }
                        }
                    }
                }
            }
        }
    }
}

#pragma mark - Additional Helper Methods

- (NSString *)checkCostType:(CostType)costType
{
    NSString *costTypeString = nil;
    
    switch (costType)
    {
        case CostType_Default:
        {
            
        }
            break;
            
        case CostType_None:
        {
            
        }
            break;
        
        case CostType_Coins:
        {
            costTypeString = KeyValueCoins;
        }
            break;
        
        case CostType_Gems:
        {
            costTypeString = KeyValueGems;
        }
            break;
            
        default:
            break;
    }
    
    return costTypeString;
}

- (NSString *)checkMultiplierType:(MultipliersType)type
{
    NSString *multiplierTypeString = nil;
    
    switch (type) {
        case MultipliersType_Default:
        {
            
        }
            break;
        
        case MultipliersType_Coins:
        {
            multiplierTypeString = KeyValueCoins;
        }
            break;
            
        case MultipliersType_Gems:
        {
            multiplierTypeString = KeyValueGems;
        }
            break;
            
        default:
            break;
    }
    
    return multiplierTypeString;
}

- (NSString *)checkCookieCostumeType:(CookieCostumeType)cookieCostumeType
{
    NSString *cookiePackTypeString = nil;

    switch (cookieCostumeType)
    {
        case CookieCostumeType_Default:
        {
            
        }
            break;
        
        case CookieCostumeType_None:
        {
            
        }
            break;
            
        case CookieCostumeType_Chef:
        {
            cookiePackTypeString = @"Chef";
        }
            break;
        
        case CookieCostumeType_Super:
        {
            cookiePackTypeString = @"SuperHero";
        }
            break;
            
        case CookieCostumeType_Western:
        {
            cookiePackTypeString = @"Western";
        }
            break;
            
        case CookieCostumeType_Alien:
        {
            cookiePackTypeString = @"Farmer";
        }
            break;
            
        case CookieCostumeType_Zombie:
        {
            cookiePackTypeString = @"Undead";
        }
            break;
            
        case CookieCostumeType_Asian:
        {
            cookiePackTypeString = @"Oriental";
        }
            break;
            
        case CookieCostumeType_Pirate:
        {
            cookiePackTypeString = @"Pirate";
        }
            break;
        
        case CookieCostumeType_Egypt:
        {
            cookiePackTypeString = @"Egypt";
        }
            break;
            
        case CookieCostumeType_MediEvil:
        {
            cookiePackTypeString = @"Medieval";
        }
            break;
        
        case CookieCostumeType_Soldier:
        {
            cookiePackTypeString = @"Soldier";
        }
            break;
            
        default:
            break;
    }
    
    return cookiePackTypeString;
}

- (int)checkItemCostType:(ItemCostType)itemCostType costType:(CostType)costType
{
    int coinItemCosts = 0;
    int gemItemCosts = 0;
    
    switch (itemCostType)
    {
        case ItemCostType_Default:
        {
            
        }
            break;
        
        case ItemCostType_IAPIdentifier_BombPowerup:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_CoinPack1000:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_CoinPack2000:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_CoinPack5000:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_CoinPack10000:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_ExtraCoinsForTimePeriod:
        {
            coinItemCosts = 200;
            gemItemCosts = 1000;
        }
            break;
        
        case ItemCostType_IAPIdentifier_ExtraCoinsForWorld:
        {
            coinItemCosts = 200;
            gemItemCosts = 1000;
        }
            break;
            
//        case ItemCostType_IAPIdentifier_ExtraLives3:
//        {
//            coinItemCosts = 1000;
//            gemItemCosts = 2;
//        }
//            break;
            
        case ItemCostType_IAPIdentifier_ExtraLives5:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifier_ExtraMoves:
        {
            coinItemCosts = 1000;
            gemItemCosts = 2;
        }
            break;
            
        case ItemCostType_IAPIdentifier_ExtraTime:
        {
            coinItemCosts = 200;
            gemItemCosts = 1000;
        }
            break;
            
        case ItemCostType_IAPIdentifier_LightningBooster:
        {
            coinItemCosts = 500;
            gemItemCosts = 1;
        }
            break;
            
        case ItemCostType_IAPIdentifier_NukeBooster:
        {
            coinItemCosts = 99998;
            gemItemCosts = 99998;
        }
            break;
            
        case ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup:
        {
            coinItemCosts = 1500;
            gemItemCosts = 3;
        }
            break;
            
        case ItemCostType_IAPIdentifier_SlotMachineBooster:
        {
            coinItemCosts = 1000;
            gemItemCosts = 2;
        }
            break;
            
        case ItemCostType_IAPIdentifier_SmorePowerup:
        {
            coinItemCosts = 1000;
            gemItemCosts = 2;
        }
            break;
            
        case ItemCostType_IAPIdentifier_SpatulaBooster:
        {
            coinItemCosts = 500;
            gemItemCosts = 1;
        }
            break;
        
        case ItemCostType_IAPIdentifier_SuperPowerup:
        {
            coinItemCosts = 1000;
            gemItemCosts = 2;
        }
            break;
            
        case ItemCostType_IAPIdentifier_WrapperPowerup:
        {
            coinItemCosts = 1000;
            gemItemCosts = 2;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperChip:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperDustinDoubleMint:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperGerry:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperLukeLocoLemon:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperMikeMcSprinkles:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperReginald:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        case ItemCostType_IAPIdentifiers_SuperSuperJJJams:
        {
            coinItemCosts = 99999;
            gemItemCosts = 99999;
        }
            break;
            
        default:
            break;
    }
    
    switch (costType)
    {
        case CostType_Default:
        {
            return 0;
        }
            break;
        
        case CostType_None:
        {
            return 0;
        }
            break;
            
        case CostType_Coins:
        {
            return coinItemCosts;
        }
            break;
            
        case CostType_Gems:
        {
            return gemItemCosts;
        }
            break;
        default:
            break;
    }
}

@end
