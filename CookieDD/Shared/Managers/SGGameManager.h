//
//  SGGameManager.h
//  CookieDD
//
//  Created by Luke McDonald on 10/17/13.
//  Copyright (c) 2013 Seven Gun Games. All rights reserved.
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
#import "CDCookieSpriteNode.h"
#import "CDPlateSpriteNode.h"
#import "CDClearBlockSprite.h"
#import "CDIngredientSpriteNode.h"
#import "CDBlockerSpriteNode.h"
#import "CDMainGameLabelNode.h"
#import "CDMainGamePopupView.h"
#import "CDIcecreamSpriteNode.h"
#import "CDButtonSpriteNode.h"
#import "CDPretzelSpriteNode.h"
#import "CDBombSpriteNode.h"
#import "SGPopupNode.h"

typedef enum GoalTypes
{
    GoalTypes_INGREDIENT,
    GoalTypes_TOTALSCORE,
    GoalTypes_STARCOUNT,
    GoalTypes_TYPECLEAR
    
}   GoalTypes;

typedef enum GoalLimiters
{
    GoalLimiters_DEFAULT,
    GoalLimiters_TIME_LIMIT,
    GoalLimiters_MOVE_LIMIT,
    GoalLimiters_MARATHON
    
} GoalLimiters;

static const uint32_t defaultCategory           =   0x00000000;

static const uint32_t cookiesCategory           =   0x1 << 1;

static const uint32_t boardCategory             =   0x1 << 1;

static const uint32_t leftSlideCategory         =   0x1 << 2;

static const uint32_t rightslideCategory        =   0x1 << 3;

static const uint32_t hollowBlockerCategory     =   0x1 << 5;

static const uint32_t blockerCategory           =   0x1 << 6;

static const uint32_t ingredientCategory        =   0x1 << 7;


static const uint32_t clearBlockCategoryOne     =   0x1 << 8;

static const uint32_t clearBlockCategoryTwo     =   0x1 << 9;

static const uint32_t clearBlockCategoryThree   =   0x1 << 10;

static const uint32_t clearBlockCategoryFour    =   0x1 << 11;

static const uint32_t clearBlockCategoryFive    =   0x1 << 12;

static const uint32_t clearBlockCategorySix     =   0x1 << 13;

static const uint32_t clearBlockCategorySeven   =   0x1 << 14;

static const uint32_t clearBlockCategoryEight   =   0x1 << 15;

static const uint32_t clearBlockCategoryNine    =   0x1 << 16;


typedef void (^DeletionCompletionHandler)(BOOL didDelete);

typedef void (^RecycleCookiesCompletionHandler)(BOOL didDelete);

@protocol SGGameManagerDelegate;

@interface SGGameManager : NSObject <CDButtonSpriteNodeDelegate>

@property (strong, nonatomic) NSString *planetName;
@property (strong, nonatomic) NSString* what_planet_am_I_on;
@property (assign, nonatomic) int what_level_am_I_at;
@property (strong, nonatomic) NSArray *backgroundImageOffsetArray;

@property (strong, nonatomic) NSMutableArray* theVisiblePieces; // only made of visible pieces
@property (strong, nonatomic) NSMutableArray* theReservePieces; // all reserve pieces
@property (strong, nonatomic) NSMutableArray* theBackground; // the background pieces
@property (strong, nonatomic) NSMutableArray* theGameGrid; // only made of visible pieces in order , Empty spots type = EMPTY_PIECE
@property (strong, nonatomic) NSMutableArray* powerUpVictims; // deletion
@property (assign, nonatomic) int numActivePowerUps;

@property (assign, nonatomic) int numRows;
@property (assign, nonatomic) int numColumns;

@property (assign, nonatomic) float cookieWidth;
@property (assign, nonatomic) float cookieHeight;

@property (assign, nonatomic) int columnWidth;
@property (assign, nonatomic) int RowHeight;

@property (strong, nonatomic) SKNode *gameBoard;

@property (assign, nonatomic) BOOL isTakingInput;

@property (assign, nonatomic) BOOL gameIsOver;
@property (assign, nonatomic, readonly) BOOL gameInProgress;

@property (strong, nonatomic) NSArray* initialBoardItemsArray; // for loading the plist stuff

@property (strong, nonatomic) NSArray* theGameBoardBackgroundTiles;

@property (weak, nonatomic) id <SGGameManagerDelegate> delegate;

@property (strong, nonatomic) NSNumber *worldType;
@property (strong, nonatomic) NSNumber *levelType;

// score, score values, and the current multiplier
@property (assign, nonatomic) int score;
@property (assign, nonatomic) int score_bronze;
@property (assign, nonatomic) int score_silver;
@property (assign, nonatomic) int score_gold;
@property (assign, nonatomic) int score_multiplier;
@property (assign, nonatomic) int score_Per_cookie;
@property (assign, nonatomic) int score_Per_super;
@property (assign, nonatomic) int score_Per_wrapped;
@property (assign, nonatomic) int score_Per_smore;
@property (assign, nonatomic) int score_Per_plate;
@property (assign, nonatomic) int score_Per_powerupVictim;
@property (assign, nonatomic) int score_Per_ingredient;
@property (assign, nonatomic) int score_Per_icecream;

@property (assign, nonatomic) GoalTypes mainGoalType;
@property (assign, nonatomic) int mainGoalValue;
@property (strong, nonatomic) NSMutableArray *mainGoalItems; // for clear type

@property (assign, nonatomic) GoalTypes secondGoalType;
@property (assign, nonatomic) int secondGoalValue;
@property (strong, nonatomic) NSMutableArray *secondGoalItems; // for clear type


@property (assign, nonatomic) GoalLimiters goalLimiter;
@property (assign, nonatomic) int limiterValue;

@property (strong, nonatomic) NSArray *availableBoosters;


@property (strong, nonatomic) SKNode* timerNode;
@property (assign, nonatomic) int playerIdleSeconds;
@property (strong, nonatomic) NSMutableArray *spawnablePieces;
@property (strong, nonatomic) NSArray* spawnableCookies;
@property (strong, nonatomic) NSArray* spawnableIngredients;
@property (assign, nonatomic) int spawnablePot;

@property (strong, nonatomic) NSString *levelName;

// milkstream
@property (strong, nonatomic) SKSpriteNode* milkstream;
@property (strong, nonatomic) SKSpriteNode* wrappedMilkstream;
@property (strong, nonatomic) SKAction* milkstreamAction;

// Slot Machine
@property (assign, nonatomic) int numActiveSlotMachines;
@property (assign, nonatomic) BOOL slotRollSoundIsPlaying;
@property (assign, nonatomic) SGAudioPlayer *slotMachineRollPlayer;

// Particles //

// Cookie Deletion
@property (strong, nonatomic) SKEmitterNode *shockwaveParticle;
@property (strong, nonatomic) SKEmitterNode *milkSplatParticle;
@property (strong, nonatomic) SKEmitterNode *cookieGibletsParticle01;
@property (strong, nonatomic) SKEmitterNode *cookieGibletsParticle02;
@property (strong, nonatomic) SKEmitterNode *cookieGibletsParticle03;
@property (strong, nonatomic) SKEmitterNode *milkDropsParticle;

// Supers
@property (strong, nonatomic) SKEmitterNode *superShockwaveParticle;
@property (strong, nonatomic) SKEmitterNode *superBoomParticle;

@property (strong, nonatomic) SKEmitterNode *smokeParticle;
@property (strong, nonatomic) SKEmitterNode *nukeCloudFireParticle;
@property (strong, nonatomic) SKEmitterNode *nukeCollumnFireParticle;
@property (strong, nonatomic) SKEmitterNode *nukeShockwaveParticle;
@property (strong, nonatomic) SKEmitterNode *ashParticle;

//BOMB
@property (strong, nonatomic) SKAction *bombSpark;
@property (strong, nonatomic) SKAction *bombSplode;
@property (strong, nonatomic) SKTexture *bombTexture;
@property (strong, nonatomic) SKTexture *bombShineTexture;
@property (strong, nonatomic) NSMutableArray *allBombs;

//@property (strong, nonatomic) SKTexture *cookieOneTexture;
//@property (strong, nonatomic) SKTexture *cookieTwoTexture;
//@property (strong, nonatomic) SKTexture *cookieThreeTexture;
//@property (strong, nonatomic) SKTexture *cookieFourTexture;
//@property (strong, nonatomic) SKTexture *cookieFiveTexture;
//@property (strong, nonatomic) SKTexture *cookieSixTexture;
//@property (strong, nonatomic) SKTexture *ingredientTexture;
//@property (strong, nonatomic) SKTexture *bombTexture;


//Power up properties
@property (strong, nonatomic) NSMutableArray *SuperCookies;
@property (strong, nonatomic) NSMutableArray *WrappedCookies;

// initial stuff for retrying
@property (assign, nonatomic) int initial_limiterValue;

@property (strong, nonatomic) NSMutableArray* initial_mainGoalItems; // for clear type

@property (strong, nonatomic) NSMutableArray* initial_secondGoalItems; // for clear type

#pragma mark - Initialization.

+ (SGGameManager *)gameManager;

-(void)ReadyToPlay;
-(void)ShowGoals;
-(void)Remove_Scene;
-(void)Retry;
-(void)UseExtra_amount:(int)amount;

-(void)Pause;
-(void)Resume;

#pragma mark - Board Creation.

- (void)initBoardWithScene:(SKScene *)scene
             withGameBoard:(SKNode *)gameBoard;


- (void)createInitialBoardItems:(NSArray *)boardArray;

- (void)setSpawnableItemsWithArray:(NSArray*)spawnableItems;

-(void)setGoalType:(GoalTypes)goalType
        WithValue:(int)goalValue
        WithBronze:(int)bronzeValue
        WithSilver:(int)silverValue
        WithGold:(int)goldValue
        WithItems:(NSArray*)items
        SecondaryGoalType:(GoalTypes)secondGoalType
        SecondaryGoalValue:(int)secondGoalValue
        SecondaryGoalItems:(NSArray*)secondGoalItems;


-(void)setLimiterValueTo:(GoalLimiters)limiterType
               WithValue:(int)limiterValue;

#pragma mark - Swap.

- (NSArray*)SetTheGameGrid;

- (BOOL)checkSwap:(CDGameBoardSpriteNode *)gameBoardPiece
      secondPiece:(CDGameBoardSpriteNode *)secondGameBoardPiece;

-(void)PlaySwitchAnimation:(CDGameBoardSpriteNode*)cookie;

-(void)PlaySwitchBackAnimation:(CDGameBoardSpriteNode*)cookie;

#pragma mark - sound effects
-(void)Play_swipe_sound;

#pragma mark - Helper Methods

- (SKTextureAtlas *)textureAtlasNamed:(NSString *)fileName;

- (SKScene*)CurrentScene;

- (void)createSuperBurstForCookie:(CDCookieSpriteNode *)cookie Color:(UIColor *)color;

#pragma mark - PowerUp Application Methods

-(void)PowerGlove:(CDCookieSpriteNode*)cookie;

-(void)SuperSizeThatCookie:(CDCookieSpriteNode*)cookie;

-(void)Wrap_that_cookie:(CDCookieSpriteNode *)cookie;

-(void)Smore_that_cookie:(CDCookieSpriteNode*)cookie;

-(void)SlotThatCookie:(CDCookieSpriteNode*)cookie;

-(void)StopThatSlotCookie:(CDCookieSpriteNode*)slotCookie;

-(void)SmashThatCookie:(CDCookieSpriteNode*)victim;

-(BOOL)RadiateThatCookie:(CDCookieSpriteNode*)cookie;

-(void)Drop_The_Nuke;

-(void)Spatula;

#pragma mark - Power Up effects

-(void)Super_Horizontal:(CDCookieSpriteNode*)theSuper;

-(void)Super_Vertical:(CDCookieSpriteNode*)theSuper;

-(void)SingleWrapper:(CDGameBoardSpriteNode*)piece;

-(void)HurtIcecream:(CDIcecreamSpriteNode*)piece Multiplier:(int)multiplier;

-(void)HurtCookiedough:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier;

-(void)HurtPretzel:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier;

-(void)HurtBomb:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier;

-(void)LockBreak:(CDGameBoardSpriteNode*)piece;

-(void)Area_Effect:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier;

-(void)Put_a_milk_splash:(CGPoint)point Size:(CGSize)size;

-(void)Add_to_Score:(int)amount Piece:(CDGameBoardSpriteNode*)piece;

-(void)Milkstream:(SKSpriteNode *)milkStream Position:(CGPoint)pos WidthScale:(float)widthScale Angle:(float)angle Zpos:(int)zPos Duration:(float)duration;

-(void)Powerup_deletion;

#pragma mark - device orientation

-(void)To_Landscape;

-(void)To_Portrait;

#pragma mark Dev Cheats
- (void)autoWinWithStarCount:(int)starCount;
- (void)autoLose;

@end

@protocol SGGameManagerDelegate <NSObject>

@optional
- (void)cookieDidDeleteWithScore:(int)score WithCookie:(CDCookieSpriteNode *)cookie;
- (void)cookieDidDeleteWithMoveCount:(int)moveCount WithCookie:(CDCookieSpriteNode *)cookie;
- (void)ingredientsAreGone;
- (void)gameManager:(SGGameManager *)manager didEndGameWithWinOrLoose:(BOOL)didWin;



@end