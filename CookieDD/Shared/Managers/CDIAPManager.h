//
//  CDIAPManager.h
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

#import <Foundation/Foundation.h>
#import "LMInAppPurchaseManager.h"

// In-app Purchase Identifiers!!!

static NSString *IAPIdentifier_BombPowerup                  = @"com.7gungames.CookieDunkDunk.BombPowerup";
static NSString *IAPIdentifier_LightningBooster             = @"com.7gungames.CookieDunkDunk.LightningBooster";
static NSString *IAPIdentifier_SlotMachineBooster           = @"com.7gungames.CookieDunkDunk.SlotMachine_Booster";
static NSString *IAPIdentifier_SmorePowerup                 = @"com.7gungames.CookieDunkDunk.Smore_Powerup";
static NSString *IAPIdentifier_SpatulaBooster               = @"com.7gungames.CookieDunkDunk.Spatula_Booster";
static NSString *IAPIdentifier_RadioactiveSprinklePowerup   = @"com.7gungames.CookieDunkDunk.RadioactiveSprinklePowerup";
static NSString *IAPIdentifier_SuperPowerup                 = @"com.7gungames.CookieDunkDunk.Super_Powerup";
static NSString *IAPIdentifier_WrapperPowerup               = @"com.7gungames.CookieDunkDunk.Wrapper_Powerup";
static NSString *IAPIdentifier_ExtraTime                    =  @"com.7gungames.CookieDunkDunk.ExtraTime";
static NSString *IAPIdentifier_ExtraMoves                   =  @"com.7gungames.CookieDunkDunk.ExtraMoves";
//static NSString *IAPIdentifier_ExtraLives3                  =  @"com.7gungames.CookieDunkDunk.ExtraLives";
static NSString *IAPIdentifier_ExtraLives5                  =  @"com.7gungames.CookieDunkDunk.FiveLives";
static NSString *IAPIdentifier_ExtraCoinsForTimePeriod      =  @"com.7gungames.CookieDunkDunk.ExtraCoinsForTimePeriod";
static NSString *IAPIdentifier_ExtraCoinsForWorld           =  @"com.7gungames.CookieDunkDunk.ExtraCoinsForWorld";

static NSString *IAPIdentifier_CoinPack1000     =  @"com.7gungames.CookieDunkDunk.CoinPack";
static NSString *IAPIdentifier_CoinPack2000     =  @"com.7gungames.CookieDunkDunk.CoinPack2500";
static NSString *IAPIdentifier_CoinPack5000     =  @"com.7gungames.CookieDunkDunk.CoinPack5000";
static NSString *IAPIdentifier_CoinPack10000    =  @"com.7gungames.CookieDunkDunk.CoinPack10000";
static NSString *IAPIdentifier_NukeBooster      =  @"com.7gungames.CookieDunkDunk.NukerBooster";

// to be determined.
static NSString *IAPIdentifier_FortuneCookiePowerup =  @"com.7gungames.CookieDunkDunk.FortuneCookiePowerup";

// cookiepack identifiers
// Supers
static NSString *IAPIdentifiers_SuperChip               = @"com.7gungames.CookieDunkDunk.SuperChips";
static NSString *IAPIdentifiers_SuperGerry              = @"com.7gungames.CookieDunkDunk.SuperGerry";
static NSString *IAPIdentifiers_SuperDustinDoubleMint   = @"com.7gungames.CookieDunkDunk.SuperDustinDoubleMint";
static NSString *IAPIdentifiers_SuperHeroJJJams         = @"com.7gungames.CookieDunkDunk.SuperJ.J.Jams";
static NSString *IAPIdentifiers_SuperLukeLocoLemon      = @"com.7gungames.CookieDunkDunk.SuperLukeLocoLemon";
static NSString *IAPIdentifiers_SuperMikeMcSprinkles    = @"com.7gungames.CookieDunkDunk.SuperMikeMcSprinkles";
static NSString *IAPIdentifiers_SuperReginald           = @"com.7gungames.CookieDunkDunk.SuperReginald";
static NSString *IAPIdentifiers_SuperCookiePack         = @"com.7gungames.CookieDunkDunk.SuperCookiePack";

// Chefs
static NSString *IAPIdentifiers_ChefDustinDoubleMint            = @"com.7gungames.CookieDunkDunk.ChefDustin";
static NSString *IAPIdentifiers_ChefGerry                       = @"com.7gungames.CookieDunkDunk.ChefGerry";
static NSString *IAPIdentifiers_ChefJJJams                      = @"7gungames.CookieDunkDunk.ChefJJJams";
static NSString *IAPIdentifiers_ChefLukeLocoLemon               = @"com.7gungames.CookieDunkDunk.ChefLukeLocoLemon";
static NSString *IAPIdentifiers_ChefMikeMcSprinkles             = @"com.7gungames.CookieDunkDunk.ChefMikeMcSprinkles";
static NSString *IAPIdentifiers_ChefReginald                    = @"com.7gungames.CookieDunkDunk.ChefReginald";
static NSString *IAPIdentifiers_ChefCookiePack                  = @"com.7gungames.CookieDunkDunk.ChefCookiePack";

// Farmers
static NSString *IAPIdentifiers_FarmerChip              = @"com.7gungames.CookieDunkDunk.FarmerChip";
static NSString *IAPIdentifiers_FarmerGerryJ            = @"com.7gungames.CookieDunkDunk.FarmerGerry";
static NSString *IAPIdentifiers_FarmerJJJams            = @"com.7gungames.CookieDunkDunk.FarmerJJJams";
static NSString *IAPIdentifiers_FarmerLukeLocoLemon     = @"com.7gungames.CookieDunkDunk.FarmerLuke";
static NSString *IAPIdentifiers_FarmerMikeyMcSprinkles  = @"com.7gungames.CookieDunkDunk.FarmerMike";
static NSString *IAPIdentifiers_FarmerReginald          = @"com.7gungames.CookieDunkDunk.FarmerReginald";
static NSString *IAPIdentifiers_FarmerCookiePack        = @"com.7gungames.CookieDunkDunk.FarmerCookiePack";

// Zombies
static NSString *IAPIdentifiers_ZombieChip       = @"com.7gungames.CookieDunkDunk.ZombieChip";
static NSString *IAPIdentifiers_ZombieDustinMartianMint       = @"com.7gungames.CookieDunkDunk.ZombieDustin";
static NSString *IAPIdentifiers_ZombieJJJams       = @"com.7gungames.CookieDunkDunk.ZombieJJ";
static NSString *IAPIdentifiers_ZombieLukeLocoLemon       = @"com.7gungames.CookieDunkDunk.ZombieLuke";
static NSString *IAPIdentifiers_ZombieMikeyMcSprinkles       = @"com.7gungames.CookieDunkDunk.ZombieMikey";
static NSString *IAPIdentifiers_ZombieReginald       = @"com.7gungames.CookieDunkDunk.ZombieReginald";
static NSString *IAPIdentifiers_ZombieCookiePack       = @"com.7gungames.CookieDunkDunk.ZombieCookiePack";


// Key Values webservices expect!!!
static NSString *const KeyValueMoves                = @"moves";
static NSString *const KeyValueLives                = @"lives";
static NSString *const KeyValueCoins                = @"coins";
static NSString *const KeyValueGems                 = @"gems";
static NSString *const KeyValuePowerGlove           = @"powerGlove";
static NSString *const KeyValueWrappedCookie        = @"wrappedCookie";
static NSString *const KeyValueBomb                 = @"bomb";
static NSString *const KeyValueSmore                = @"smore";
static NSString *const KeyValueRadioactiveSprinkle  = @"radioactiveSprinkle";
static NSString *const KeyValueSpatula              = @"spatula";
static NSString *const KeyValueSlotMachine          = @"slotMachine";
static NSString *const KeyValueThunderbolt          = @"thunderbolt";
static NSString *const KeyValueNuke                 = @"nuke";

// Key Names of Cookies...

static NSString *const KeyNameDefault                   = @"Default";
static NSString *const KeyNameReginald                  = @"Reginald";
static NSString *const KeyNameChip                      = @"Chip";
static NSString *const KeyNameDustinMartianMint         = @"DustinMartianMint";
static NSString *const KeyNameLukeLocoLemon             = @"LukeLocoLemon";
static NSString *const KeyNameMikeyMcSprinkles          = @"MikeyMcSprinkles";
static NSString *const KeyNameJJJams                    = @"JJJams";
static NSString *const KeyNameGerryJ                    = @"GerryJ";
static NSString *const KeyNameMoorie                    = @"Moorie";
static NSString *const KeyNameCheri                     = @"Cheri";
static NSString *const KeyNameStar                      = @"Star";


// Key Names of Cookie Costume Themes

static NSString *const KeyThemeDefault                  = @"Default";
static NSString *const KeyThemeChef                     = @"Chef";
static NSString *const KeyThemeSuperHero                = @"SuperHero";
static NSString *const KeyThemeWestern                  = @"Western";
static NSString *const KeyThemeFarmer                   = @"Farmer";
static NSString *const KeyThemeZombie                   = @"Undead";
static NSString *const KeyThemeOriental                 = @"Oriental";
static NSString *const KeyThemePirate                   = @"Pirate";
static NSString *const KeyThemeEgypt                    = @"Egypt";
static NSString *const KeyThemeMedieval                 = @"Medieval";
static NSString *const KeyThemeSoldier                  = @"Soldier";

typedef enum CostType
{
    CostType_Default,
    CostType_None,
    CostType_Gems,
    CostType_Coins

}   CostType;

typedef enum CookieCostumeType
{
    CookieCostumeType_Default,
    CookieCostumeType_None,
    CookieCostumeType_Chef,
    CookieCostumeType_Super,
    CookieCostumeType_Western,
    CookieCostumeType_Alien,
    CookieCostumeType_Zombie,
    CookieCostumeType_Asian,
    CookieCostumeType_Pirate,
    CookieCostumeType_Egypt,
    CookieCostumeType_MediEvil,
    CookieCostumeType_Soldier
    
}   CookieCostumeType;

typedef enum ItemCostType
{
    ItemCostType_Default,
    ItemCostType_IAPIdentifier_BombPowerup,
    ItemCostType_IAPIdentifier_CoinPack1000,
    ItemCostType_IAPIdentifier_CoinPack2000,
    ItemCostType_IAPIdentifier_CoinPack5000,
    ItemCostType_IAPIdentifier_CoinPack10000,
    ItemCostType_IAPIdentifier_ExtraCoinsForTimePeriod,
    ItemCostType_IAPIdentifier_ExtraCoinsForWorld,
//    ItemCostType_IAPIdentifier_ExtraLives3,
    ItemCostType_IAPIdentifier_ExtraLives5,
    ItemCostType_IAPIdentifier_ExtraMoves,
    ItemCostType_IAPIdentifier_ExtraTime,
    ItemCostType_IAPIdentifier_LightningBooster,
    ItemCostType_IAPIdentifier_NukeBooster,
    ItemCostType_IAPIdentifier_RadioactiveSprinklePowerup,
    ItemCostType_IAPIdentifier_SlotMachineBooster,
    ItemCostType_IAPIdentifier_SmorePowerup,
    ItemCostType_IAPIdentifier_SpatulaBooster,
    ItemCostType_IAPIdentifier_SuperPowerup,
    ItemCostType_IAPIdentifier_WrapperPowerup,
    ItemCostType_IAPIdentifiers_SuperChip,
    ItemCostType_IAPIdentifiers_SuperDustinDoubleMint,
    ItemCostType_IAPIdentifiers_SuperGerry,
    ItemCostType_IAPIdentifiers_SuperLukeLocoLemon,
    ItemCostType_IAPIdentifiers_SuperMikeMcSprinkles,
    ItemCostType_IAPIdentifiers_SuperSuperJJJams,
    ItemCostType_IAPIdentifiers_SuperReginald
    
}   ItemCostType;


typedef enum MultipliersType
{
    MultipliersType_Default,
    MultipliersType_Gems,
    MultipliersType_Coins,
    
}   MultipliersType;

typedef void (^GameParamtersCompletionHandler)(NSError *error, NSDictionary *updatedGameParametersDict);

@interface CDIAPManager : LMInAppPurchaseManager

@property (strong, nonatomic) NSMutableArray *multipliersArray;

#pragma mark - Initialization

+ (CDIAPManager *)iapMananger;

- (void)requestProducts;

- (void)requestSpecificProductsWithProductIdentifiers:(NSSet *)productIdentifiers;

#pragma mark - Currency Check

- (BOOL)canPurchaeItemWithItemCosts:(int)itemCostValue currentCurrency:(int)currentCurrency;

#pragma mark - Item Costs Values

- (int)getItemCoinCostWithItemCostType:(ItemCostType)itemCostType;

- (int)getItemGemCostWithItemCostType:(ItemCostType)itemCostType;

#pragma mark - Webservice Manager Wrapper Calls

#pragma mark - Update Moves

- (void)requestToIncreaseMovesValue:(NSNumber *)movesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToDecreaseMovesValue:(NSNumber *)movesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Lives

- (void)requestToIncreaseLivesValue:(NSNumber *)livesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToDecreaseLivesValue:(NSNumber *)livesValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Coins

- (void)requestToIncreaseCoinsValue:(NSNumber *)coinsValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToDecreaseCoinsValue:(NSNumber *)coinsValue
                          costValue:(NSNumber *)costValue
                           costType:(CostType)costType
                  completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Gems

- (void)requestToIncreaseGemsValue:(NSNumber *)gemsValue
                         costValue:(NSNumber *)costValue
                          costType:(CostType)costType
                 completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToDecreaseGemsValue:(NSNumber *)gemsValue
                         costValue:(NSNumber *)costValue
                          costType:(CostType)costType
                 completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Boosters

- (void)requestToUpdateBoostersWithDecreaseRadioActiveSprinkleValue:(NSNumber *)radioactiveSprinkleValue
                                                       spatulaValue:(NSNumber *)spatulaValue
                                                   slotMachineValue:(NSNumber *)slotMachineValue
                                                   thunderboltValue:(NSNumber *)thunderboltValue
                                                          nukeValue:(NSNumber *)nukeValue
                                                          costValue:(NSNumber *)costValue
                                                           costType:(CostType)costType
                                                  completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToUpdateBoostersWithIncreaseRadioActiveSprinkleValue:(NSNumber *)radioactiveSprinkleValue
                                                       spatulaValue:(NSNumber *)spatulaValue
                                                   slotMachineValue:(NSNumber *)slotMachineValue
                                                   thunderboltValue:(NSNumber *)thunderboltValue
                                                          nukeValue:(NSNumber *)nukeValue
                                                          costValue:(NSNumber *)costValue
                                                           costType:(CostType)costType
                                                  completionHandler:(GameParamtersCompletionHandler)handler;
#pragma mark - Update Powerups

- (void)requestToUpdatePowerupsWithDecreasePowerGloveValue:(NSNumber *)powerGloveValue
                                        wrappedCookieValue:(NSNumber *)wrappedCookieValue
                                                 bombValue:(NSNumber *)bombValue
                                                smoreValue:(NSNumber *)smoreValue
                                                 costValue:(NSNumber *)costValue
                                                  costType:(CostType)costType
                                         completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToUpdatePowerupsWithIncreasePowerGloveValue:(NSNumber *)powerGloveValue
                                        wrappedCookieValue:(NSNumber *)wrappedCookieValue
                                                 bombValue:(NSNumber *)bombValue
                                                smoreValue:(NSNumber *)smoreValue
                                                 costValue:(NSNumber *)costValue
                                                  costType:(CostType)costType
                                         completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Cookie Costumes

- (void)requestToUpdateCookiePacksWithCookiePackType:(CookieCostumeType)cookieCostumeType
                                  willUnlockReginald:(BOOL)willUnlockReginald
                                      willUnlockChip:(BOOL)willUnlockChip
                         willUnlockDustinMartianMint:(BOOL)willUnlockDustinMartianMint
                             willUnlockLukeLocoLemon:(BOOL)willUnlockLukeLocoLemon
                          willUnlockMikeyMcSprinkles:(BOOL)willUnlockMikeyMcSprinkles
                                    willUnlockJJJams:(BOOL)willUnlockJJJams
                                    willUnlockGerryJ:(BOOL)willUnlockGerryJ
                                   completionHandler:(GameParamtersCompletionHandler)handler;

#pragma mark - Update Multipliers

- (void)requestToAddTimeMultiplierWithMultiplierType:(MultipliersType)multiplierType
                                           costValue:(NSNumber *)costValue
                                            costType:(CostType)costType
                                   completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToAddLevelMultiplierWithMultiplierType:(MultipliersType)multiplierType
                                            costValue:(NSNumber *)costValue
                                             costType:(CostType)costType
                                    completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToRemoveMultiplierWithId:(NSString *)multiplierId
                      completionHandler:(GameParamtersCompletionHandler)handler;

- (void)requestToDecreaseLevelMultiplier;

@end
