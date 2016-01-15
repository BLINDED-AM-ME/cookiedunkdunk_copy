//
//  CDCommonHelpers.h
//  CookieDD
//
//  Created by Luke McDonald on 7/2/13.
//  Copyright (c) 2013 SevenGun. All rights reserved.
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


// These are all the item types that can
// exist on the main game board.
typedef enum ItemType {

    EMPTY_ITEM,
    CLEAR_BLOCK,
    COOKIE_RANDOM,
    COOKIE_RED,
    COOKIE_ORANGE,
    COOKIE_YELLOW,
    COOKIE_GREEN,
    COOKIE_BLUE,
    COOKIE_PURPLE,
    COOKIE_CHIP,
    INGREDIENT_RANDOM,
    INGREDIENT_EGG,
    INGREDIENT_SUGAR,
    INGREDIENT_CHIPS,
    INGREDIENT_BANANA,
    INGREDIENT_FLOUR,
    POWERUP_SUPER_RANDOM,
    POWERUP_SUPER_RED,
    POWERUP_SUPER_ORANGE,
    POWERUP_SUPER_YELLOW,
    POWERUP_SUPER_GREEN,
    POWERUP_SUPER_BLUE,
    POWERUP_SUPER_PURPLE,
    POWERUP_SUPER_CHIP,
    POWERUP_WRAPPED_RANDOM,
    POWERUP_WRAPPED_RED,
    POWERUP_WRAPPED_ORANGE,
    POWERUP_WRAPPED_YELLOW,
    POWERUP_WRAPPED_GREEN,
    POWERUP_WRAPPED_BLUE,
    POWERUP_WRAPPED_PURPLE,
    POWERUP_WRAPPED_CHIP,
    POWERUP_SMORE,
    BOOSTER_SLOTMACHINE,
    BOOSTER_RADSPRINKLE,
    BOOSTER_LIGHTNING,
    BOOSTER_NUKE,
    POWERUP_SUPERGLOVE,
    POWERUP_WRAPPER,
    BOOSTER_SPATULA,
    BLOCKER_ICECREAM,
    BLOCKER_COOKIEDOUGH,
    BLOCKER_PRETZEL,
    BOMB
    
} ItemType;

typedef enum StarType
{
    NO_STAR,
    BRONZE_STAR,
    SILVER_STAR,
    GOLD_STAR
    
} StarType;

typedef enum : u_int32_t
{
    defaultCollissionCategory   = 0,
    cupCategory                 = 1,
    cookieCategory              = 2,
    sceneCategory               = 3,
    floorCategory               = 4,
    wallCategory                = 5,
    milkMonsterCategory         = 6,
    cookerCookieJarCategory     = 7,
    cookerTrashCanCategory      = 8,
    cookerPanCategory           = 9,
    boxCategory                 = 10
} APAColliderType;

typedef NS_ENUM(int, loadingScreenOrientation)
{
    landscapeOrientation,
    landscapeLeftOrientation,
    landscapeRightOrientation,
    portraitOrientation,
    allButUpsideDownOrientation
};

typedef NS_ENUM(int, mainButtonIndex)
{
    soundButtonIndex,
    settingsButtonIndex,
    helpButtonIndex,
    volumeButtonIndex,
    achievementButtonIndex,
    gameCenterButtonIndex,
    backButtonIndex,
    shopButtonIndex,
    accountButtonIndex,
    facebookButtonIndex,
    twitterButtonIndex,
    googleButtonIndex
};

typedef NS_ENUM(int, gameDifficultyLevel)
{
    gameDifficultyLevelUndefined,
    gameDifficultyLevelEasy,
    gameDifficultyLevelMedium,
    gameDifficultyLevelHard,
    gameDifficultyLevelCrazy
};

//typedef NS_ENUM(int, superImageID)
//{
//    defaultSuperID,
//    milkyWaieSuperID,
//    dunkopolisSuperID
//};

//typedef enum : u_int32_t
//{
//    defaultSuperID      = 0,
//    milkyWaieSuperID    = 1,
//    dunkopolisSuperID   = 2
//} superImageID;

#ifndef CookieDD_CDCommonHelpers_h
#define CookieDD_CDCommonHelpers_h
#import <SpriteKit/SpriteKit.h>
#import "SGAudioManager.h"
#import "SGGameCenterManager.h"
#import "CDPlayerObject.h"
#import "CDIAPManager.h"
#import "LMICloudManager.h"
#import "WebserviceManager.h"
#import "SGAppDelegate.h"
#import "SGSocialManager.h"
#import "CDParticleEmitter.h"
#import "CDMainButtonViewController.h"
#import "BLINDED_Math.h"
#import <StoreKit/StoreKit.h>

#ifdef DEBUG
//#define DebugLog( s, ... )
#define DebugLog( s, ... ) NSLog( @"<%p %@:(%d)> %@", self, [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DebugLog( s, ... )

#endif

#define kScreenWidth [[UIScreen mainScreen] applicationFrame].size.width
#define kScreenHeight [[UIScreen mainScreen] applicationFrame].size.height

#define DegreesToRadians(angle) ((angle) / 180.0 * M_PI)
#define RadiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )
#define IS_IPHONE_4 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON )
#define IS_IPAD ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
#define IS_RETINA ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)

// System version preprocessor macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

// iOS versions
#define IOS_7_0     @"7.0"
#define IOS_7_1     @"7.1"
#define IOS_7_1_1   @"7.1.1"
#define IOS_7_1_2   @"7.1.2"
#define IOS_8_0     @"8.0"

#define IsoMapsEnabled YES

// TODO: Product Push
#define DevModeActivated 1

#define LifeUnlockDelay 1200

#define numLevelsPerPlanet 30

// TODO: Product Push
#define numUnlockablePlanets 4  // Limit to number of planets.


// Cookie Themes
#define CookieThemeStandard @"Default"
#define CookieThemeChef @"Chef"
#define CookieThemeSuperHero @"SuperHero"
#define CookieThemeSoldier @"Soldier"
#define CookieThemeOriental @"Oriental"
#define CookieThemeMedieval @"Medieval"
#define CookieThemeEgypt @"Egypt"
#define CookieThemePirate @"Pirate"
#define CookieThemeWestern @"Western"
#define CookieThemeFarmer @"Farmer"
#define CookieThemeUndead @"Undead"

// Planet Names
#define PlanetMilkywaieMountain @"milkywaie_mountain"
#define PlanetDunkopolis @"dunkopolis"

// User Defaults
#define IsFirstTimeDefault @"isFirstTime"
#define HasSeenMapIntroTutorial @"hasSeenMapIntroTutorial"
#define MusicButtonStateDefault @"musicButtonState"
#define VolumeButtonStateDefault @"volumeButtonState"
#define CookieCookerHighScoreDefault @"cookieCookerHighScore"
#define CookieDropHighScoreDefault @"cookieDropHighScore"
#define CowAbductionHighScoreDefault @"CowAbductionHighScore"
#define CardMatchHighScoreDefault @"CardMatchHighScore"
#define DailyPrizesAwardedDefault @"dailyPrizesAwarded"
#define CurrentLevelDefault @"currentLevel"
#define CurrentLivesDefault @"currentLives"
#define LifeUnlockDateDefault @"lifeUnlockDates"
#define AwardLockoutTimeDefault @"awardLockoutTime"
#define CookieDropAwardGemDefault @"cookieDropAwardGem"
#define CookieCookerAwardGemDefault @"cookieCookerAwardGem"
#define CowAbductionAwardGemDefault @"cowAbductionAwardGem"
//#define LevelAwardGemDefault @"levelAwardGem"
#define AllowVideoIntroToPlayDefault @"allowVideoToPlay"
#define CookieCostumeArrayDefault @"cookieCostumeArray"
#define FreeCookieCostumeDictionaryDefault @"freeCostumeDictionary"
#define WatchedIntroVideoDefault @"watchedIntroVideo"
#define WatchedDunkopolisIntroVideoDefault @"watchedDunkopolisIntroVideo"
#define WatchedAbductionJunctionIntroVideoDefault @"watchedAbductionJunctionIntroVideo"
#define PurchasedCostumesArrayDefault @"PurchasedCostumesArray"

// Fonts
#define kFontDamnNoisyKids          @"DamnNoisyKids"
#define kFontSlapstickComic_Bold    @"SFSlapstickComic-Bold"
#define kFontDS_DIGI                @"DS-DIGI-Normal"

////////////////////////////
//// Abduction Minigame ////
////////////////////////////
// Directions
#define Abduction_Direction_FrontRight @"frontRight"
#define Abduction_Direction_FrontLeft @"frontLeft"
#define Abduction_Direction_BackRight @"backRight"
#define Abduction_Direction_BackLeft @"backLeft"
#define Abduction_Direction_Right @"right"
#define Abduction_Direction_Left @"left"

// Blocker Types
#define Blocker_HayLeft @"hayBlockerLeft"
#define Blocker_HayRight @"hayBlockerRight"
#define Blocker_Rock @"rockBlocker"
#define Blocker_BarnLeft @"barnBlockerLeft"
#define Blocker_BarnRight @"barnBlockerRight"
#define Blocker_FenceLeft @"fenceBlockerLeft"
#define Blocker_FenceRight @"fenceBlockerRight"

// Difficulty
#define Difficulty_Easy @"easyDifficulty"
#define Difficulty_Medium @"mediumDifficulty"
#define Difficulty_Hard @"hardDifficulty"
#define Difficulty_Crazy @"crazyDifficulty"



static const uint32_t abductionDefaultCollissionCategory = 1 << 0;
static const uint32_t cowCollisionCategory = 1 << 1;
static const uint32_t UFOCollisionCategory = 1 << 2;
static const uint32_t abductionBeamCollisionCategory = 1 << 3;
static const uint32_t blockerCollisionCategory = 1 << 4;
static const uint32_t fartCollisionCategory = 1 << 5;
static const uint32_t ufoObjectCollisionCategory = 1 << 6;

#endif
