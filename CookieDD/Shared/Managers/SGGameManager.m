//
//  SGGameManager.m
//  CookieDD
//
//  Created by Dustin Whirle on 3/1/14.
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

#import "SGGameManager.h"
#import "CDParticleEmitter.h"
#import "SGFileManager.h"
#import "SGPlayerPreferencesManager.h"
#import "CDMainGameGoalPopup.h"
#import "CDAwardPopupViewController.h"
#import "BLINDED_Math.h"
#import "CDCookieAnimationManager.h"
#import "SGCookieDunkDunkScene.h"
#import "CDCookieDoughManager.h"


static SGGameManager *gameManager = nil;


@interface SGGameManager () <CDMainGamePopupViewDelegate, CDAwardPopupViewControllerDelegate>

@property (weak, nonatomic) SGCookieDunkDunkScene* scene;

@property (strong, nonatomic) NSArray* possible_combo;

@property (strong, nonatomic) NSMutableArray* inserted_reserve_pieces; // this is so the new falling pieces dont overlap. Used in Drop_the_Pieces_Above_this_One()

@property (assign, nonatomic) int numFallingPieces;

@property (strong, nonatomic) NSMutableArray* allCombos; // after swapping

@property (strong, nonatomic) NSMutableArray* allPlates;
//@property (strong, nonatomic) NSMutableArray* allPlatesSounds;
//@property (strong, nonatomic) NSMutableArray* allPlatesCrackingSounds;

@property (strong, nonatomic) NSMutableArray* allEmptySpaces;

@property (strong, nonatomic) NSArray *cookieTextures; // their textures
@property (strong, nonatomic) NSArray *ingredientTextures;

@property (assign, nonatomic) BOOL was_a_powerup_triggered; // used in Check swap
@property (assign, nonatomic) BOOL didCookieCrumble; // used in Check swap

@property (strong, nonatomic) NSArray *masterTexturesArray;
@property (strong, nonatomic) NSArray *masterItemTypesArray;
@property (strong, nonatomic) NSMutableArray* ingredientDropIcons;//cdd-ingredient-indicator@2x
@property (assign, nonatomic) BOOL showIngredientDropIcons;

@property (strong, nonatomic) NSString* deviceModel;

@property (strong, nonatomic) AVAudioPlayer *soundPlayer;

//@property (assign, nonatomic) BOOL isPlaying_cdd_milky_wave_distorted;
@property (assign, nonatomic) BOOL isPlaying_cdd_milky_vortex;
@property (assign, nonatomic) BOOL isPlaying_CookieWrap;
@property (assign, nonatomic) BOOL isPlaying_PowerCrunch;

@property (strong, nonatomic) NSArray *wrappedCookieTextures;
@property (strong, nonatomic) NSArray *slotmachineSlides;
//@property (strong, nonatomic) SKAction* slotDing;
@property (strong, nonatomic) NSArray *pretzelTextures;
@property (strong, nonatomic) SKTexture *smoreTexture;
@property (strong, nonatomic) SKTexture *radioactiveSprinkleTexture;

// PowerGlove
@property (strong, nonatomic) SKSpriteNode* thePowerGlove;
@property (strong, nonatomic) SKSpriteNode* thePowerGlove_CropMask;
@property (strong, nonatomic) SKSpriteNode* thePowerGlove_background;
@property (strong, nonatomic) SKSpriteNode* thePowerGlove_shockWave;
//@property (strong, nonatomic) SKAction* thePowerGlove_sound;

// spatula
@property (strong, nonatomic) SKSpriteNode* theSpatula;
@property (strong, nonatomic) SKSpriteNode* theSpatula_Portal_in;
@property (strong, nonatomic) SKSpriteNode* theSpatula_Portal_out;
//@property (strong, nonatomic) SKAction* theSpatula_sound;

// the Portal
@property (strong, nonatomic) SKSpriteNode* thePortal;
@property (strong, nonatomic) SKSpriteNode* thePortal_rays;
@property (strong, nonatomic) SKEmitterNode* portalSparkles;


// Lightning
@property (strong, nonatomic) SKCropNode* LightningCropNode;
@property (strong, nonatomic) SKSpriteNode* LightningCropMask;
@property (strong, nonatomic) SKSpriteNode* Lightning;
@property (strong, nonatomic) SKSpriteNode* LightningBackFlashes;
@property (strong, nonatomic) SKEmitterNode* Lightning_Sparks;
@property (strong, nonatomic) SKSpriteNode* LightningCookieBack;
@property (strong, nonatomic) SKSpriteNode* LightningCookieFront;

@property (strong, nonatomic) SKAction* LightningAction;
@property (strong, nonatomic) SKAction* LightningBackFlashingAction;
@property (strong, nonatomic) SKAction* LightningCookieFrontAction;

// plateTextures
@property (strong, nonatomic) NSArray* plateTextures;
@property (strong, nonatomic) SKEmitterNode* glassParticle;
// locked piece spritenode
@property (strong, nonatomic) SKSpriteNode* lockSprite;
@property (strong, nonatomic) SKEmitterNode* lockBreak_1;
@property (strong, nonatomic) SKEmitterNode* lockBreak_2;
@property (strong, nonatomic) SKEmitterNode* lockBreak_3;

// icream
@property (strong, nonatomic) NSArray* icreamTextures;
@property (assign, nonatomic) int numberOfIcreams;

// nuke
@property (assign, nonatomic) BOOL isNukeAfterMath;
@property (strong, nonatomic) SKSpriteNode* nuke_Node;
@property (strong, nonatomic) SKSpriteNode* nuke_falling_Node;
@property (strong, nonatomic) SKAction* nuke_animation;
@property (strong, nonatomic) SKSpriteNode* nuke_shockwave;
@property (assign, nonatomic) CGSize nuke_size;
//@property (strong, nonatomic) SKAction* nuke_Sound;

// Meteorite
@property (strong, nonatomic) SKEmitterNode* meteorite_fireball;
@property (strong, nonatomic) SKSpriteNode* meteorite_cookie;
@property (strong, nonatomic) SKEmitterNode* meteorite_AshPoof;
//@property (strong, nonatomic) SKAction* meteorite_Shooting_sound;
//@property (strong, nonatomic) SKAction* meteorite_impact_sound;


// Sound effects
@property (assign, nonatomic) int whichSwipeSound;
//@property (strong, nonatomic) NSArray* SwipeSounds;
//@property (strong, nonatomic) NSArray *crunchSoundsArray;
@property (strong, nonatomic) NSArray *splatSoundsArray;
@property (strong, nonatomic) SKAction *wrapSound;

//@property (strong, nonatomic) SKAction* PowerCrunch;

@property (strong, nonatomic) CDMainGamePopupView *gamePopupView;
@property (strong, nonatomic) CDMainGameGoalPopup *goalPopupView;


// cookie dough
@property (strong, nonatomic) CDCookieDoughManager* cookieDoughLord;

// Cherry Bombs
@property (assign, nonatomic) int cherryBombMinHealth;
@property (assign, nonatomic) int cherryBombMaxHealth;


@end

@implementation SGGameManager


#pragma mark - Initialization

+ (SGGameManager *)gameManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        gameManager = [SGGameManager new];
        
        [gameManager HardReset];
        
            
        if(IS_IPHONE_4 || IS_IPHONE_5){
            
            gameManager.deviceModel = @"@2x";
            
        }else
            if(IS_IPAD){
                
                gameManager.deviceModel = @"@2x~ipad";
            }
        
        gameManager.what_planet_am_I_on = @"milkywaie_mountain";
        
        gameManager.cookieTextures = [NSMutableArray new];
        
        gameManager.ingredientTextures = [NSMutableArray new];
        
        gameManager.wrappedCookieTextures = [NSMutableArray new];
        
        gameManager.icreamTextures = [NSArray new];
        
        gameManager.gamePopupView = [[[NSBundle mainBundle] loadNibNamed:@"CDMainGamePopupView" owner:self options:nil] objectAtIndex:0];
        gameManager.gamePopupView.delegate = gameManager;
        
        gameManager.goalPopupView = [[[NSBundle mainBundle] loadNibNamed:@"CDMainGameGoalPopup_iphone" owner:self options:nil] objectAtIndex:0];
        [gameManager.goalPopupView setup];
        
        gameManager.cookieDoughLord = [CDCookieDoughManager new];
        [gameManager.cookieDoughLord DoughSetup];
        
    });
    
    return gameManager;
}


-(void)Remove_Scene
{
    if(_scene == nil)
        return;
    
    [self HardReset];
    
    [[CDCookieAnimationManager animationManager] CleanOutSuperStuff];
    
    [_scene removeAllActions];
    [_scene removeAllChildren];
    [_scene removeFromParent];
    
    [_gamePopupView removeFromSuperview];
    
    _scene = nil;
    
    DebugLog(@"Scene removed");
    
}

-(void)Pause{

    if(_scene != nil){
        [_scene removeAllActions];
        
        if(_goalLimiter  == GoalLimiters_TIME_LIMIT){
            
            if(_timerNode){
                [_timerNode removeAllActions];
                [_timerNode removeFromParent];
            }
        }
        
        DebugLog(@" Manager was paused");
    }
}

-(void)Resume{
    
    if(_scene != nil){
        
        for(CDGameBoardSpriteNode* piece in _theVisiblePieces){
            
            piece.position = CGPointMake((piece.column * _columnWidth) +_columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        }
        //topPiece.position = CGPointMake((topPiece.column * _columnWidth) +_columnWidth, (topPiece.row * _RowHeight)+ _RowHeight);
        
        [self StartSceneActions];
        
        if(_goalLimiter  == GoalLimiters_TIME_LIMIT && self.gameInProgress){
            
            [self Make_A_Timer_Node];
            
        }
        DebugLog(@" Manager was resumed");
    }
}

- (void)dealloc
{
    //  [self.timer invalidate];
}

- (void)HardReset{
    
    // score values
    self.score_Per_cookie = 20;
    self.score_Per_super = 60;
    self.score_Per_wrapped = 120;
    self.score_Per_smore = 200;
    self.score_Per_plate = 1000;
    self.score_Per_powerupVictim = 60;
    self.score_Per_ingredient = 1000;
    self.score_Per_icecream = 20;
    self.numActivePowerUps = 0;

    
    self.allCombos = [NSMutableArray new];
    
    self.theGameGrid = [NSMutableArray new];
    
    self.theReservePieces = [NSMutableArray new];
    
    self.theVisiblePieces = [NSMutableArray new];
    
    self.inserted_reserve_pieces = [NSMutableArray new];
    
    self.isTakingInput = NO;
    
    self.was_a_powerup_triggered = NO;
    
    self.SuperCookies = [NSMutableArray new];
    
    self.WrappedCookies = [NSMutableArray new];
    
    self.allBombs = [NSMutableArray new];
    
    self.powerUpVictims = [NSMutableArray new];
    
    self.allPlates = [NSMutableArray new];
    
    self.numberOfIcreams = 0;
    
    self.score = 0;
    
    self.score_multiplier = 1;
    
    self.playerIdleSeconds = 20;
    
    self.possible_combo = [NSMutableArray new];
    
    self.ingredientDropIcons = [NSMutableArray new];
    
    self.showIngredientDropIcons = NO;
    
    self.allEmptySpaces = [NSMutableArray new];
    
    _soundPlayer = [[AVAudioPlayer alloc] init];
    
    self.isNukeAfterMath = NO;
    
    // Reset liquid level in milkCup
    [_scene.milkCup setLiquidLevelTo:0.0];
    
    [self.cookieDoughLord Reset];
    
    self.didCookieCrumble = NO;
    
    self.numActiveSlotMachines = 0;
    
    self.slotRollSoundIsPlaying = NO;
    
    self.slotMachineRollPlayer = nil;
    
    self.gameIsOver = NO;
    
    _gameInProgress = NO;

    if(self.gameBoard)
        [self.gameBoard removeAllChildren];
}

-(void)ReadyToPlay
{
    _gameInProgress = YES;
    
    [_goalPopupView removeFromSuperview];
    _gamePopupView.parentalViewController = gameManager.scene.parentController;
    
    if([self Check_For_No_Possible_Combos]) // YES there are / NO there aren't
        [self Give_Control_Back_to_User];
    else
        [self Spatula];
    
    if(_goalLimiter  == GoalLimiters_TIME_LIMIT){
        
        [self Make_A_Timer_Node];
        
    }

    
}

-(void)ShowGoals{
    
    _isTakingInput = NO;
    
    [_goalPopupView ShowGoals];
    
    _goalPopupView.frame = _scene.frame;
    
    [_scene.view insertSubview:_goalPopupView atIndex:0];
}

-(void)Retry{
    
    _scene.throwAwayButton.boosterName = nil;
    _scene.ApplyPowerupOnCookie = EMPTY_ITEM;
    
    [_scene.boosterSelectedObject removeFromParent];
//    [_scene handleThrowAwayButton];
    
    _isTakingInput = NO;
    _scene.scorelabelNode.text = [NSString stringWithFormat:@"Score: %i", 0];
    
    // Run the animation.

    [_scene removeAllActions];
    
    [_gamePopupView displayPopupAnimated:NO Completion:nil];
    [_gamePopupView hidePopupAnimated:YES Completion:nil];
    
    [_gamePopupView removeFromSuperview];
    
    // The commented out stuff was not working for me, so I switched it for performSelector - Gary J.
    
//    [_gameBoard runAction:[SKAction sequence:@[[SKAction waitForDuration:0.5],
//                                           [SKAction runBlock:^{
//        [self Retry_phaseOne];
//    
//    }]]]];
    
    [self performSelector:@selector(Retry_phaseOne) withObject:nil afterDelay:.5];
    
//    [_gameBoard runAction:[SKAction sequence:@[[SKAction waitForDuration:2],
//                                           [SKAction runBlock:^{
//        [self Retry_phaseTwo];
//    
//        [self UpdateHUD];
//        
//    }]]]];
    
    [self performSelector:@selector(Retry_phaseTwo) withObject:nil afterDelay:2];
    [self performSelector:@selector(UpdateHUD) withObject:nil afterDelay:2];
//    [_gameBoard runAction:[SKAction sequence:@[[SKAction waitForDuration:3.0f],
//                                           [SKAction runBlock:^{
//        
//        [self ShowGoals];
//        
//        [self StartSceneActions];
//
//    }]]]];
    
    [self performSelector:@selector(ShowGoals) withObject:nil afterDelay:3];
    [self performSelector:@selector(StartSceneActions) withObject:nil afterDelay:3];
    
}

-(void)Retry_phaseOne{

    //clear plates
    for (int i=0; i<_allPlates.count; i++) {
        CDPlateSpriteNode* plate = [_allPlates objectAtIndex:i];
        [plate removeFromParent];
    }
    
    [_allPlates removeAllObjects];
    
    [self LosingDeletion];
    
}

-(void)Retry_phaseTwo{
    
    _limiterValue = _initial_limiterValue;
    
    _mainGoalItems = [NSMutableArray new];
    for(int i=0; i<_initial_mainGoalItems.count; i++){
        int value = [_initial_mainGoalItems[i] intValue];
        [_mainGoalItems addObject:[NSNumber numberWithInt:value]];
        
    }
    
    _secondGoalItems = [NSMutableArray new];
    for(int i=0; i<_initial_secondGoalItems.count; i++){
        int value = [_initial_secondGoalItems[i] intValue];
        [_secondGoalItems addObject:[NSNumber numberWithInt:value]];
        
    }
    
    for(CDGameBoardSpriteNode* icon in _ingredientDropIcons)
    {
        [icon removeFromParent];
    }
    
    [self HardReset];
    
    [_gameBoard removeAllActions];
    [_gameBoard removeAllChildren];
    
    ItemType tileTypeID;
    
    CGPoint top = [_scene convertPoint:CGPointMake(0, _scene.size.height + _RowHeight) toNode:_gameBoard];
    
    float yCoord = top.y;
    
    SKAction *sound_glassBreak = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassBreak" FileType:@"caf"];}];
    SKAction *sound_glassCracking = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassCracking02" FileType:@"caf"];}];
    
    
    // Go through each row.
    for (int row=0; row<_initialBoardItemsArray.count; row++)
    {
        //(NSArray *rowsArray in boardArray)
        
        NSArray* rowArray = [_initialBoardItemsArray objectAtIndex:row];
        
        float xCoord =  _columnWidth;
        
        // Set each tile in this row.
        
        for (int column=0; column<rowArray.count; column++)
        {
            // (NSDictionary *tileDict in rowsArray)
            
            NSDictionary* tileDict = [rowArray objectAtIndex:column]; // plateLevel
            
            // plate
            {
                int plateHealth =  [tileDict[@"plateLevel"] intValue];
                if(plateHealth > 0)
                {
                    
                    CDPlateSpriteNode* newPlate = [self New_Plate_with_health:plateHealth];
                    newPlate.column = column;
                    newPlate.row = row;
                    newPlate.position = CGPointMake(xCoord, (_RowHeight * row) + _RowHeight);
                    newPlate.zPosition = 25;
                    newPlate.size = CGSizeMake(_columnWidth, _columnWidth);
                    [_gameBoard addChild:newPlate];
                    [_allPlates addObject:newPlate];
                    
                    
                    if (sound_glassBreak) {
                        /*
                         NSError *error = nil;
                        
                        SGAudioPlayer* newsound = [[SGAudioPlayer alloc] initWithContentsOfURL:url_glassBreak error:&error];
                        [newsound prepareToPlay];
                        newsound.baseVolume = 0.25f;
                        newsound.currentTime = 0.25f;
                         */
                        newPlate.glassBreakSound = sound_glassBreak;
                        
                    }
                    
                    if(plateHealth > 1){
                        
                        if(sound_glassCracking){
                          /*  NSError *error_cracking = nil;
                            
                            SGAudioPlayer* newCrackSound = [[SGAudioPlayer alloc] initWithContentsOfURL:url_glassCracking error:&error_cracking];
                            [newCrackSound prepareToPlay];
                            newCrackSound.baseVolume = 0.75f;
                            newPlate.glassCrackSound = newCrackSound;
                            [_allSoundEffects addObject:newCrackSound];
                           
                           */
                            
                            newPlate.glassCrackSound = sound_glassCracking;
                        }
                    }

                }
                
            }
            
            // Get the typeID from the itemType string.
            if ([_masterItemTypesArray indexOfObject:tileDict[@"itemType"]] != NSNotFound)
            {
                tileTypeID = (ItemType) [_masterItemTypesArray indexOfObject:tileDict[@"itemType"]];
            }
            else  // If it isn't recognized, then set it to a random cookie.
            {
                
                DebugLog(@"Error: Could not find typeID for itemType '%@'.  I'm setting it to a random cookie instead.", tileDict[@"itemType"]);
                
                tileTypeID = COOKIE_RANDOM;
            }
            
            // Figure out what the item is, and create it accordingly.
            CDGameBoardSpriteNode* newPiece = nil;
            
            
            if ([tileDict[@"itemType"] rangeOfString:@"COOKIE_"].location != NSNotFound) {
                
                CDCookieSpriteNode *cookie = [self NewCookieWithType:tileTypeID];
                
                cookie.position = CGPointMake(xCoord, yCoord);
                
                cookie.zPosition = 2;
                cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"INGREDIENT_"].location != NSNotFound)
            {
                
                if ([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                    
                    tileTypeID = INGREDIENT_RANDOM;
                    
                }else
                    if ([tileDict[@"itemType"] rangeOfString:@"EGG"].location != NSNotFound){
                        tileTypeID = INGREDIENT_EGG;
                    }
                    else
                        if ([tileDict[@"itemType"] rangeOfString:@"SUGAR"].location != NSNotFound){
                            tileTypeID = INGREDIENT_SUGAR;
                        }
                        else
                            if ([tileDict[@"itemType"] rangeOfString:@"CHIPS"].location != NSNotFound){
                                tileTypeID = INGREDIENT_CHIPS;
                            }
                            else
                                if ([tileDict[@"itemType"] rangeOfString:@"BANANA"].location != NSNotFound){
                                    tileTypeID = INGREDIENT_BANANA;
                                }
                                else
                                    if ([tileDict[@"itemType"] rangeOfString:@"FLOUR"].location != NSNotFound){
                                        tileTypeID = INGREDIENT_FLOUR;
                                    }
                
                CDIngredientSpriteNode *ingredient = [self NewIngredientWithType:tileTypeID];
                
                ingredient.position = CGPointMake(xCoord, yCoord);
                
                ingredient.zPosition = 2;
                ingredient.size = CGSizeMake(_cookieWidth, _cookieHeight);
                ingredient.row = row;
                ingredient.column = column;
                
                newPiece = ingredient;
                
                [_theVisiblePieces addObject:ingredient];
                
                [_gameBoard addChild:ingredient];
                
                
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"POWERUP_"].location != NSNotFound)
            {
                
                // POWERUP_SUPER_CHIP
                
                int nextCourseOfAction = 0;  //0=super 1=wrapped 2=smore
                
                if ([tileDict[@"itemType"] rangeOfString:@"SUPER_"].location != NSNotFound){
                    nextCourseOfAction = 0;
                }else
                    if([tileDict[@"itemType"] rangeOfString:@"WRAPPED_"].location != NSNotFound){
                        nextCourseOfAction = 1;
                    }else
                        if([tileDict[@"itemType"] rangeOfString:@"SMORE"].location != NSNotFound){
                            nextCourseOfAction = 2;
                        }
                
                if(nextCourseOfAction < 2){
                    
                    if ([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                        
                        tileTypeID = COOKIE_RANDOM;
                    }else
                        if ([tileDict[@"itemType"] rangeOfString:@"RED"].location != NSNotFound){
                            
                            tileTypeID = COOKIE_RED;
                        }
                        else
                            if ([tileDict[@"itemType"] rangeOfString:@"ORANGE"].location != NSNotFound){
                                
                                tileTypeID = COOKIE_ORANGE;
                            }
                            else
                                if ([tileDict[@"itemType"] rangeOfString:@"YELLOW"].location != NSNotFound){
                                    
                                    tileTypeID = COOKIE_YELLOW;
                                }
                                else
                                    if ([tileDict[@"itemType"] rangeOfString:@"GREEN"].location != NSNotFound){
                                        
                                        tileTypeID = COOKIE_GREEN;
                                    }
                                    else
                                        if ([tileDict[@"itemType"] rangeOfString:@"BLUE"].location != NSNotFound){
                                            
                                            tileTypeID = COOKIE_BLUE;
                                        }
                                        else
                                            if ([tileDict[@"itemType"] rangeOfString:@"PURPLE"].location != NSNotFound){
                                                
                                                tileTypeID = COOKIE_PURPLE;
                                            }
                                            else
                                                if ([tileDict[@"itemType"] rangeOfString:@"CHIP"].location != NSNotFound){
                                                    
                                                    tileTypeID = COOKIE_CHIP;
                                                }
                }
                
                CDCookieSpriteNode *cookie;
                
                cookie.row = row;
                cookie.column = column;
                
                cookie.position = CGPointMake(xCoord, yCoord);
                cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
                cookie.zPosition = 2;
                
                if(nextCourseOfAction == 0){
                    
                    cookie = [self NewCookieWithType:tileTypeID];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self SuperSizeThatCookie:cookie];
                    
                }else if(nextCourseOfAction == 1){
                    cookie = [self NewCookieWithType:tileTypeID];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self Wrap_that_cookie:cookie];
                    
                }else if(nextCourseOfAction == 2){
                    cookie = [self NewCookieWithType:COOKIE_RANDOM];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self Smore_that_cookie:cookie];
                }
                
                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
                
                
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"BOOSTER_"].location != NSNotFound)
            {
                
                CDCookieSpriteNode *cookie = [self NewCookieWithType:COOKIE_RANDOM];
                
                if ([tileDict[@"itemType"] rangeOfString:@"SLOTMACHINE"].location != NSNotFound){
                    
                   // cookie.typeID = BOOSTER_SLOTMACHINE;
                    
                    [self SlotThatCookie:cookie];
                    
                }else
                    if ([tileDict[@"itemType"] rangeOfString:@"RADSPRINKLE"].location != NSNotFound){
                        
                       // cookie.typeID = BOOSTER_RADSPRINKLE;
                        
                        [self RadiateThatCookie:cookie];
                    }
                
                
                cookie.position = CGPointMake(xCoord, yCoord);
                
                cookie.zPosition = 2;
                cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
                
                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
                
                
                
            }
            else if([tileDict[@"itemType"] rangeOfString:@"CLEAR"].location != NSNotFound)
            {
                
                CDClearBlockSprite *clearBlockSprite = [CDClearBlockSprite spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(_cookieWidth, _cookieHeight)];
                
                clearBlockSprite.typeID = CLEAR_BLOCK;
                
                clearBlockSprite.position = CGPointMake(xCoord, yCoord);
                clearBlockSprite.size = CGSizeMake(_columnWidth, _RowHeight);
                clearBlockSprite.zPosition = 2;
                
                clearBlockSprite.row = row;
                clearBlockSprite.column = column;
                
                newPiece = clearBlockSprite;
                
                [_theVisiblePieces addObject:clearBlockSprite];
                
                [_gameBoard addChild:clearBlockSprite];
                
            }else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_ICECREAM"].location != NSNotFound)
            {
                
                // BLOCKER_ICECREAM
                CDIcecreamSpriteNode* IceScreamSprite = [CDIcecreamSpriteNode new];
                
                IceScreamSprite.typeID = BLOCKER_ICECREAM;
                
                int health = [tileDict[@"icreamLevel"] intValue];
                
                if(health >= 5)
                    health = 5;
                
                if(health == 1){
                    
                    IceScreamSprite.texture = _icreamTextures[0];
                    
                }else{
                    
                    IceScreamSprite.texture = _icreamTextures[health];
                    
                }
                
                IceScreamSprite.size = CGSizeMake(_cookieWidth, _cookieHeight);
                
                IceScreamSprite.health = health;
                
                IceScreamSprite.position = CGPointMake(xCoord, yCoord);
                
                IceScreamSprite.zPosition = 4;
                
                IceScreamSprite.row = row;
                IceScreamSprite.column = column;
                
                IceScreamSprite.isVulnerable = NO;
                IceScreamSprite.shouldMilkSplash = NO;
                
                newPiece = IceScreamSprite;
                
                _numberOfIcreams++;
                
                [_theVisiblePieces addObject:IceScreamSprite];
                
                [_gameBoard addChild:IceScreamSprite];
                
            }
            else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_COOKIEDOUGH"].location != NSNotFound)
            {
                
                CDGameBoardSpriteNode* cookie_dough = [CDGameBoardSpriteNode spriteNodeWithTexture:_cookieDoughLord.doughTexture size:CGSizeMake(_columnWidth, _RowHeight)];
                
                cookie_dough.typeID = BLOCKER_COOKIEDOUGH;
                
                cookie_dough.position = CGPointMake(xCoord, yCoord);
                
                cookie_dough.zPosition = 2;
                
                cookie_dough.row = row;
                cookie_dough.column = column;
                
                cookie_dough.isVulnerable = NO;
                cookie_dough.shouldMilkSplash = YES;
                
                newPiece = cookie_dough;
                
                [_cookieDoughLord.myDoughyChildren addObject:cookie_dough];
                
                [_theVisiblePieces addObject:cookie_dough];
                
                [_gameBoard addChild:cookie_dough];
                
                
            }else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_PRETZEL"].location != NSNotFound)
            {
                
                CDPretzelSpriteNode* pretzel = [CDPretzelSpriteNode spriteNodeWithTexture:_pretzelTextures[0] size:CGSizeMake(_cookieWidth, _cookieHeight)];
                
                pretzel.typeID = BLOCKER_PRETZEL;
                
                pretzel.position = CGPointMake(xCoord, yCoord);
                
                pretzel.zPosition = 2;
                
                pretzel.row = row;
                pretzel.column = column;
                
                pretzel.isVulnerable = NO;
                pretzel.shouldMilkSplash = YES;
                
                newPiece = pretzel;
                
                [_theVisiblePieces addObject:pretzel];
                
                [_gameBoard addChild:pretzel];
                
                
            }else if([tileDict[@"itemType"] rangeOfString:@"BOMB"].location != NSNotFound)
            {
                
                int health = [tileDict[@"icreamLevel"] intValue];
                
                NSString* type = @"RANDOM";
                
                if([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                    type = @"RANDOM";
                }else if([tileDict[@"itemType"] rangeOfString:@"CHIP"].location != NSNotFound){
                    type = @"CHIP";
                }else if([tileDict[@"itemType"] rangeOfString:@"BLUE"].location != NSNotFound){
                    type = @"BLUE";
                }else if([tileDict[@"itemType"] rangeOfString:@"RED"].location != NSNotFound){
                    type = @"RED";
                }else if([tileDict[@"itemType"] rangeOfString:@"GREEN"].location != NSNotFound){
                    type = @"GREEN";
                }else if([tileDict[@"itemType"] rangeOfString:@"PURPLE"].location != NSNotFound){
                    type = @"PUPLE";
                }else if([tileDict[@"itemType"] rangeOfString:@"ORANGE"].location != NSNotFound){
                    type = @"ORANGE";
                }else if([tileDict[@"itemType"] rangeOfString:@"YELLOW"].location != NSNotFound){
                    type = @"YELLOW";
                }
                
                // BOMB
                CDBombSpriteNode* bombSprite = [self New_Bomb_with_health:health Type:type];
                
                bombSprite.position = CGPointMake(xCoord, yCoord);
                bombSprite.row = row;
                bombSprite.column = column;
                
                newPiece = bombSprite;
                
                [_allBombs addObject:bombSprite];
                
                [_theVisiblePieces addObject:bombSprite];
                
                [_gameBoard addChild:bombSprite];
                
            }else if([tileDict[@"itemType"] rangeOfString:@"EMPTY"].location != NSNotFound)
            {
                // no nothing
                
            }
            else
            {
                DebugLog(@"This tile is something different.");
            }
            
            // lock it
            {
                int isItLocked = [tileDict[@"isLocked"] intValue];
                if(isItLocked > 0)
                {
                    SKSpriteNode* newLock = [_lockSprite copy];
                    newLock.size = CGSizeMake(_columnWidth, _RowHeight);
                    newLock.zPosition = 26;
                    [newPiece addChild:newLock];
                    
                    newPiece.isLocked = YES;
                }
                
            }
            
            newPiece.scoreMultiplier = 1;
            
            xCoord += _columnWidth;
            
        }
        
        yCoord += _RowHeight;
    }
    
    CDGameBoardSpriteNode* dropIcon = [CDGameBoardSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-ingredient-indicator%@",_deviceModel]];
    
    for (int i=0; i<_numColumns; i++) {
        
        CDGameBoardSpriteNode* bottomPiece = _theVisiblePieces[i];
        
        if(bottomPiece.typeID != CLEAR_BLOCK && bottomPiece.typeID != EMPTY_ITEM){
            CDGameBoardSpriteNode* newIcon = [dropIcon copy];
            newIcon.column = i;
            newIcon.zPosition = 27;
            [_ingredientDropIcons addObject:newIcon];
            
            [_scene addChild:newIcon];
        }
    }
    
    for(int i=0; i<_ingredientDropIcons.count; i++){
        CDGameBoardSpriteNode* dropIcon = _ingredientDropIcons[i];
        dropIcon.size = CGSizeMake(_columnWidth * 0.5, _RowHeight * 0.5);
        dropIcon.hidden = YES;
        dropIcon.position = [_scene convertPoint:CGPointMake((dropIcon.column * _columnWidth) + _columnWidth, _RowHeight - dropIcon.size.height) fromNode:_gameBoard];
        
    }

    
    // Spawn the cookies which wait above the game board.
    [self spawnReserveCookies];

    // Play gamePlay music when board is reset
    [[SGAudioManager audioManager] playTheMusic];
    
    [self Retry_phaseThree];


}

-(void)Retry_phaseThree{
    
    _theGameGrid = [NSMutableArray new];
    _allEmptySpaces = [NSMutableArray new];
    
    for(int i=0; i<_numColumns * _numRows; i++){
        
        CDGameBoardSpriteNode* emptySpite = [CDGameBoardSpriteNode new];
        emptySpite.typeID = EMPTY_ITEM;
        emptySpite.isVulnerable = YES;
        
        float iterator = i;
        float columns = _numColumns;
        int row = floorf(iterator/columns);
        
        emptySpite.row = row;
        emptySpite.column = i - (row * _numColumns);
        
        [_theGameGrid addObject:emptySpite];
        
    }
    
    _allEmptySpaces = [NSMutableArray arrayWithArray:_theGameGrid];
    
    NSMutableArray* obsoleteEmpties = [NSMutableArray new];
    
    for (int i=0; i<_theVisiblePieces.count; i++) {
        
        CDGameBoardSpriteNode* piece = [_theVisiblePieces objectAtIndex:i];
        
        if(piece != nil){ // if it is above the top, ignore
                
                
                if([piece isKindOfClass:[CDCookieSpriteNode class]]){
                    if(piece.typeID != POWERUP_SMORE && piece.typeID != BOOSTER_RADSPRINKLE &&
                       piece.typeID != BOOSTER_SLOTMACHINE && piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM){
                        
                        piece.isVulnerable = YES;
                        
                    }
                    
                }else if([piece isKindOfClass:[CDIngredientSpriteNode class]]){
                    
                    _showIngredientDropIcons = YES;
                    
                }
            
                
                int index = (piece.row * _numColumns) + piece.column;
                
                if(index < _theGameGrid.count){
                    [obsoleteEmpties addObject:_allEmptySpaces[index]];
                    _theGameGrid[index] = piece;
                }
                else
                {
                    
                }
            }
    }
    
    [_allEmptySpaces removeObjectsInArray:obsoleteEmpties];
  
    [self Scan_Whole_Board_for_pre_existing_combos];
    
    for (CDGameBoardSpriteNode* piece in _theVisiblePieces) {
        
        [piece runAction:[SKAction moveToY:(piece.row * _RowHeight) + _RowHeight duration:0.5f]];
        
    }
}

-(void)UseExtra_amount:(int)amount
{
    [_gamePopupView displayPopupAnimated:NO Completion:nil];
    [_gamePopupView hidePopupAnimated:YES Completion:nil];
    
    [_gamePopupView removeFromSuperview];
    
    _isTakingInput = YES;
    
    _limiterValue = amount;
    
    if(_goalLimiter  == GoalLimiters_TIME_LIMIT){
        
        [self Make_A_Timer_Node];
        
    }
    
    [self UpdateHUD];

    
}

-(void)StartSceneActions{
    
    SKAction* loopOfAThousandFaces = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:2 withRange:1],[SKAction runBlock:^{
        [self Make_A_Random_Cookie_Do_Somthing];
    }]]]];
    
    [_scene runAction:loopOfAThousandFaces];
    
    [_scene runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction runBlock:^{
        
        if(_isTakingInput)
            [self Player_Idle_tracking];
        
    }]]]]];
    
}

#pragma mark - Board Creation

- (void)initBoardWithScene:(SKScene *)scene
             withGameBoard:(SKNode *)gameBoard
{
    //
    //    CDMainGameLabelNode *testLabel = [[CDMainGameLabelNode alloc]
    //                                      initLabelWithFontName:kFontDamnNoisyKids
    //                                        fontColor:[SKColor darkTextColor]
    //                                        strokeColor:[SKColor blackColor]
    //                                        fontSize:50.0f
    //                                        scene:scene
    //                                        position:CGPointMake(CGRectGetMidX(scene.frame), CGRectGetMidY(scene.frame))
    //                                        labelType:MainGameLabelType_ComboEasyBake];
    
    DebugLog(@"initBoard");
    
    [self Remove_Scene];
    
    [_gamePopupView removeFromSuperview];
    
    [self HardReset];
    
    _isTakingInput = NO;
    
    _scene = (SGCookieDunkDunkScene *)scene;
    
    _gameBoard = gameBoard;
    
    _gameBoard.name = @"GAME BOARD";
    
    _cherryBombMinHealth = 5;
    _cherryBombMaxHealth = 15;
    
    
    [self loadAssets];
    
    [self setBoosters];
    
    [self createInitialBoardItems:_initialBoardItemsArray];
    
    [self SetTheGameGrid];
    
    [self setup_Gameboardbackground];
    
    [self Scan_Whole_Board_for_pre_existing_combos];
    
    //[self ShowGoals];
    
    [self StartSceneActions];
    
    [self UpdateHUD];
    
    
    DebugLog(@"End initBoard");
}

- (void)setBoosters {
    if ([_availableBoosters count] <= 0) {
        _availableBoosters = [NSArray arrayWithObjects:@"BOOSTER_SPATULA", @"POWERUP_SUPERGLOVE", @"BOOSTER_LIGHTNING", nil];
    }
    
    _scene.topBarBoostersArray = [[NSMutableArray alloc] init];
    
    NSArray *itemsReferenceArray = [[SGFileManager fileManager] loadArrayWithFileName:@"itemtypes-master-list" OfType:@"plist"];
    for (NSString *boosterName in _availableBoosters) {
        ItemType itemType = (ItemType) [itemsReferenceArray indexOfObject:boosterName];
        CDButtonSpriteNode *buttonSpriteNode = [[CDButtonSpriteNode alloc] initButtonSpriteNodeWithItemType:itemType];
        buttonSpriteNode.delegate = _scene;
        buttonSpriteNode.size = CGSizeMake(32, 32);
        
        buttonSpriteNode.boosterCountLabel = [[SGLabelNode alloc] initWithFontNamed:kFontDamnNoisyKids];
        [buttonSpriteNode.boosterCountLabel setFontSize:15];
        buttonSpriteNode.boosterCountLabel.shadowOffset = CGPointMake(1, -1);
        buttonSpriteNode.boosterCountLabel.text = buttonSpriteNode.boosterLabelText;
    
        if ([buttonSpriteNode.boosterCountLabel.text isEqualToString:@"0"])
        {
//            buttonSpriteNode.userInteractionEnabled = NO;
            buttonSpriteNode.color = [SKColor blackColor];
            buttonSpriteNode.colorBlendFactor = 0.5;
        }
        
        [_scene.topBarBoostersArray addObject:buttonSpriteNode];
        [_scene.topBarSpriteNode addChild:buttonSpriteNode];
        
        [buttonSpriteNode.boosterCountLabel setHorizontalAlignment:SKLabelHorizontalAlignmentModeLeft];
        buttonSpriteNode.boosterCountLabel.position = CGPointMake(buttonSpriteNode.frame.size.width * -.4, buttonSpriteNode.frame.size.height * -.5);
        [buttonSpriteNode addChild:buttonSpriteNode.boosterCountLabel];
    }
}

- (void)createInitialBoardItems:(NSArray *)boardArray {
    
    DebugLog(@"Create the initial board.");
    
    _numColumns = (int) [boardArray[0] count];
    _numRows = (int) [boardArray count];
    
    // make the new stuff and board fit
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
     
        //DebugLog(@"Landscape");
        
        [self To_Landscape];
        
    }else{
        //DebugLog(@"Portrait");
        
        [self To_Portrait];
    }
    
    ItemType tileTypeID;
    
    float yCoord = _RowHeight;
    
    SKAction *sound_glassBreak = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassBreak" FileType:@"caf"];}];
    SKAction *sound_glassCracking = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassCracking02" FileType:@"caf"];}];
    
    
    // Go through each row.
    for (int row=0; row<boardArray.count; row++)
    {
        //(NSArray *rowsArray in boardArray)
        
        NSArray* rowArray = [boardArray objectAtIndex:row];
        
        float xCoord =  _columnWidth;
        
        // Set each tile in this row.
        
        for (int column=0; column<rowArray.count; column++)
        {
            // (NSDictionary *tileDict in rowsArray)
            
            NSDictionary* tileDict = [rowArray objectAtIndex:column]; // plateLevel
            
            // plate
            {
                int plateHealth =  [tileDict[@"plateLevel"] intValue];
                if(plateHealth > 0)
                {
                    
                    CDPlateSpriteNode* newPlate = [self New_Plate_with_health:plateHealth];
                    
                    
                    newPlate.column = column;
                    newPlate.row = row;
                    newPlate.position =  CGPointMake(xCoord, yCoord);
                    newPlate.zPosition = 25;
                    [_gameBoard addChild:newPlate];
                    [_allPlates addObject:newPlate];
                    
                    
                    if (sound_glassBreak) {
                      /*  NSError *error = nil;
                        
                        SGAudioPlayer* newsound = [[SGAudioPlayer alloc] initWithContentsOfURL:url_glassBreak error:&error];
                        [newsound prepareToPlay];
                        newsound.baseVolume = 0.25f;
                        newsound.currentTime = 0.25f;
                        newPlate.glassBreakSound = newsound;
                        [_allSoundEffects addObject:newsound];
                        */
                        
                        newPlate.glassBreakSound = sound_glassBreak;
                    }

                    if(plateHealth > 1){
                        
                        
                        if(sound_glassCracking){
                           /* NSError *error_cracking = nil;
                            
                            SGAudioPlayer* newCrackSound = [[SGAudioPlayer alloc] initWithContentsOfURL:url_glassCracking error:&error_cracking];
                            [newCrackSound prepareToPlay];
                            newCrackSound.baseVolume = 0.75f;
                            newPlate.glassCrackSound = newCrackSound;
                            [_allSoundEffects addObject:newCrackSound];
                            */
                            
                            newPlate.glassCrackSound = sound_glassCracking;
                        }
                    }

                }
                
            }
            
            // Get the typeID from the itemType string.
            if ([_masterItemTypesArray indexOfObject:tileDict[@"itemType"]] != NSNotFound)
            {
                tileTypeID = (ItemType) [_masterItemTypesArray indexOfObject:tileDict[@"itemType"]];
            }
            else  // If it isn't recognized, then set it to a random cookie.
            {
                
                DebugLog(@"Error: Could not find typeID for itemType '%@'.  I'm setting it to a random cookie instead.", tileDict[@"itemType"]);
                
                tileTypeID = COOKIE_RANDOM;
            }
            
            // Figure out what the item is, and create it accordingly.
            CDGameBoardSpriteNode* newPiece = nil;
            
            
            if ([tileDict[@"itemType"] rangeOfString:@"COOKIE_"].location != NSNotFound) {
                
                CDCookieSpriteNode *cookie = [self NewCookieWithType:tileTypeID];
                
                cookie.position = CGPointMake(xCoord, yCoord);
                
                cookie.zPosition = 2;
                
                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"INGREDIENT_"].location != NSNotFound)
            {
                DebugLog(@"It's an ingredient tile.");
                
                
                if ([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                    
                    tileTypeID = INGREDIENT_RANDOM;
                    
                }else
                    if ([tileDict[@"itemType"] rangeOfString:@"EGG"].location != NSNotFound){
                        tileTypeID = INGREDIENT_EGG;
                    }
                    else
                        if ([tileDict[@"itemType"] rangeOfString:@"SUGAR"].location != NSNotFound){
                            tileTypeID = INGREDIENT_SUGAR;
                        }
                        else
                            if ([tileDict[@"itemType"] rangeOfString:@"CHIPS"].location != NSNotFound){
                                tileTypeID = INGREDIENT_CHIPS;
                            }
                            else
                                if ([tileDict[@"itemType"] rangeOfString:@"BANANA"].location != NSNotFound){
                                    tileTypeID = INGREDIENT_BANANA;
                                }
                                else
                                    if ([tileDict[@"itemType"] rangeOfString:@"FLOUR"].location != NSNotFound){
                                        tileTypeID = INGREDIENT_FLOUR;
                                    }
                
                CDIngredientSpriteNode *ingredient = [self NewIngredientWithType:tileTypeID];
                
                ingredient.position = CGPointMake(xCoord, yCoord);
                
                ingredient.zPosition = 2;
                
                ingredient.row = row;
                ingredient.column = column;
                
                newPiece = ingredient;
                
                [_theVisiblePieces addObject:ingredient];
                
                [_gameBoard addChild:ingredient];
                
                
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"POWERUP_"].location != NSNotFound)
            {
                DebugLog(@"It's a cookie powerup tile.");
                
                // POWERUP_SUPER_CHIP
                
                int nextCourseOfAction = 0;  //0=super 1=wrapped 2=smore
                
                if ([tileDict[@"itemType"] rangeOfString:@"SUPER_"].location != NSNotFound){
                    nextCourseOfAction = 0;
                }else
                    if([tileDict[@"itemType"] rangeOfString:@"WRAPPED_"].location != NSNotFound){
                        nextCourseOfAction = 1;
                    }else
                        if([tileDict[@"itemType"] rangeOfString:@"SMORE"].location != NSNotFound){
                            nextCourseOfAction = 2;
                        }
                
                if(nextCourseOfAction < 2){
                    
                    if ([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                        
                        tileTypeID = COOKIE_RANDOM;
                    }else
                        if ([tileDict[@"itemType"] rangeOfString:@"RED"].location != NSNotFound){
                            
                            tileTypeID = COOKIE_RED;
                        }
                        else
                            if ([tileDict[@"itemType"] rangeOfString:@"ORANGE"].location != NSNotFound){
                                
                                tileTypeID = COOKIE_ORANGE;
                            }
                            else
                                if ([tileDict[@"itemType"] rangeOfString:@"YELLOW"].location != NSNotFound){
                                    
                                    tileTypeID = COOKIE_YELLOW;
                                }
                                else
                                    if ([tileDict[@"itemType"] rangeOfString:@"GREEN"].location != NSNotFound){
                                        
                                        tileTypeID = COOKIE_GREEN;
                                    }
                                    else
                                        if ([tileDict[@"itemType"] rangeOfString:@"BLUE"].location != NSNotFound){
                                            
                                            tileTypeID = COOKIE_BLUE;
                                        }
                                        else
                                            if ([tileDict[@"itemType"] rangeOfString:@"PURPLE"].location != NSNotFound){
                                                
                                                tileTypeID = COOKIE_PURPLE;
                                            }
                                            else
                                                if ([tileDict[@"itemType"] rangeOfString:@"CHIP"].location != NSNotFound){
                                                    
                                                    tileTypeID = COOKIE_CHIP;
                                                }
                }
                
                CDCookieSpriteNode *cookie;
                
                cookie.row = row;
                cookie.column = column;
                
                cookie.position = CGPointMake(xCoord, yCoord);
                
                cookie.zPosition = 2;
                
                if(nextCourseOfAction == 0){
                    
                    cookie = [self NewCookieWithType:tileTypeID];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self SuperSizeThatCookie:cookie];
                    
                }else if(nextCourseOfAction == 1){
                    cookie = [self NewCookieWithType:tileTypeID];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self Wrap_that_cookie:cookie];
                    
                }else if(nextCourseOfAction == 2){
                    cookie = [self NewCookieWithType:COOKIE_RANDOM];
                    
                    cookie.position = CGPointMake(xCoord, yCoord);
                    cookie.zPosition = 2;
                    
                    [self Smore_that_cookie:cookie];
                }

                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
                
                
            }
            else if ([tileDict[@"itemType"] rangeOfString:@"BOOSTER_"].location != NSNotFound)
            {
                DebugLog(@"It's a booster tile.");
                
                CDCookieSpriteNode *cookie = [self NewCookieWithType:COOKIE_RANDOM];
                
                if ([tileDict[@"itemType"] rangeOfString:@"SLOTMACHINE"].location != NSNotFound){
                    
                    //cookie.typeID = BOOSTER_SLOTMACHINE;
                    
                    [self SlotThatCookie:cookie];
                    
                }else
                    if ([tileDict[@"itemType"] rangeOfString:@"RADSPRINKLE"].location != NSNotFound){
                        
                        //cookie.typeID = BOOSTER_RADSPRINKLE;
                        
                        [self RadiateThatCookie:cookie];
                        
                        DebugLog(@"Radio sprinkle");
                    }
                
                
                cookie.position = CGPointMake(xCoord, yCoord);
                
                cookie.zPosition = 2;
                cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
                
                cookie.row = row;
                cookie.column = column;
                
                newPiece = cookie;
                
                [_theVisiblePieces addObject:cookie];
                
                [_gameBoard addChild:cookie];
                
                
                
            }
            else if([tileDict[@"itemType"] rangeOfString:@"CLEAR"].location != NSNotFound)
            {
                DebugLog(@"It's a clear tile.");
                
                CDClearBlockSprite *clearBlockSprite = [CDClearBlockSprite spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(_cookieWidth, _cookieHeight)];
                
                clearBlockSprite.typeID = CLEAR_BLOCK;
                
                clearBlockSprite.position = CGPointMake(xCoord, yCoord);
                
                clearBlockSprite.zPosition = 2;
                
                clearBlockSprite.row = row;
                clearBlockSprite.column = column;
                
                newPiece = clearBlockSprite;
                
                [_theVisiblePieces addObject:clearBlockSprite];
                
                [_gameBoard addChild:clearBlockSprite];
                
            }else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_ICECREAM"].location != NSNotFound)
            {
                
                // BLOCKER_ICECREAM
                CDIcecreamSpriteNode* IceScreamSprite = [CDIcecreamSpriteNode new];
                
                IceScreamSprite.typeID = BLOCKER_ICECREAM;
                
                int health = [tileDict[@"icreamLevel"] intValue];
                
                if(health >= 5)
                    health = 5;
                
                if(health == 1){
                    
                    IceScreamSprite.texture = _icreamTextures[0];
                    
                }else{
                    
                    IceScreamSprite.texture = _icreamTextures[health];
                    
                }
                
                IceScreamSprite.size = CGSizeMake(_cookieWidth, _cookieHeight);
                
                IceScreamSprite.health = health;
                
                IceScreamSprite.position = CGPointMake(xCoord, yCoord);
                
                IceScreamSprite.zPosition = 4;
                
                IceScreamSprite.row = row;
                IceScreamSprite.column = column;
                
                IceScreamSprite.isVulnerable = NO;
                IceScreamSprite.shouldMilkSplash = NO;
                
                newPiece = IceScreamSprite;
                
                _numberOfIcreams++;
                
                [_theVisiblePieces addObject:IceScreamSprite];
                
                [_gameBoard addChild:IceScreamSprite];
                
            }
            else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_COOKIEDOUGH"].location != NSNotFound)
            {
                
                CDGameBoardSpriteNode* cookie_dough = [CDGameBoardSpriteNode spriteNodeWithTexture:_cookieDoughLord.doughTexture size:CGSizeMake(_columnWidth, _RowHeight)];
                
                cookie_dough.typeID = BLOCKER_COOKIEDOUGH;
                
                cookie_dough.position = CGPointMake(xCoord, yCoord);
                
                cookie_dough.zPosition = 2;
                
                cookie_dough.row = row;
                cookie_dough.column = column;
                
                cookie_dough.isVulnerable = NO;
                cookie_dough.shouldMilkSplash = YES;
                
                newPiece = cookie_dough;
                
                [_cookieDoughLord.myDoughyChildren addObject:cookie_dough];
                
                [_theVisiblePieces addObject:cookie_dough];
                
                [_gameBoard addChild:cookie_dough];

                
            }else if([tileDict[@"itemType"] rangeOfString:@"BLOCKER_PRETZEL"].location != NSNotFound)
            {
                
                CDPretzelSpriteNode* pretzel = [CDPretzelSpriteNode spriteNodeWithTexture:_pretzelTextures[0] size:CGSizeMake(_cookieWidth, _cookieHeight)];
                
                pretzel.typeID = BLOCKER_PRETZEL;
                
                pretzel.position = CGPointMake(xCoord, yCoord);
                
                pretzel.zPosition = 2;
                
                pretzel.row = row;
                pretzel.column = column;
                
                pretzel.isVulnerable = NO;
                pretzel.shouldMilkSplash = YES;
                
                newPiece = pretzel;
                
                [_theVisiblePieces addObject:pretzel];
                
                [_gameBoard addChild:pretzel];
                
                
            }else if([tileDict[@"itemType"] rangeOfString:@"BOMB"].location != NSNotFound)
            {
                
                int health = [tileDict[@"icreamLevel"] intValue];
                
                NSString* type = @"RANDOM";
                
                if([tileDict[@"itemType"] rangeOfString:@"RANDOM"].location != NSNotFound){
                    type = @"RANDOM";
                }else if([tileDict[@"itemType"] rangeOfString:@"CHIP"].location != NSNotFound){
                    type = @"CHIP";
                }else if([tileDict[@"itemType"] rangeOfString:@"BLUE"].location != NSNotFound){
                    type = @"BLUE";
                }else if([tileDict[@"itemType"] rangeOfString:@"RED"].location != NSNotFound){
                    type = @"RED";
                }else if([tileDict[@"itemType"] rangeOfString:@"GREEN"].location != NSNotFound){
                    type = @"GREEN";
                }else if([tileDict[@"itemType"] rangeOfString:@"PURPLE"].location != NSNotFound){
                    type = @"PUPLE";
                }else if([tileDict[@"itemType"] rangeOfString:@"ORANGE"].location != NSNotFound){
                    type = @"ORANGE";
                }else if([tileDict[@"itemType"] rangeOfString:@"YELLOW"].location != NSNotFound){
                    type = @"YELLOW";
                }
                
                // BOMB
                CDBombSpriteNode* bombSprite = [self New_Bomb_with_health:health Type:type];
                
                bombSprite.position = CGPointMake(xCoord, yCoord);
                bombSprite.row = row;
                bombSprite.column = column;
                
                newPiece = bombSprite;
                
                [_allBombs addObject:bombSprite];
                
                [_theVisiblePieces addObject:bombSprite];
                
                [_gameBoard addChild:bombSprite];
                
            }else if([tileDict[@"itemType"] rangeOfString:@"EMPTY"].location != NSNotFound)
            {
                // no nothing
                
            }
            else
            {
                DebugLog(@"This tile is something different.");
            }
            
            // lock it
            {
                int isItLocked = [tileDict[@"isLocked"] intValue];
                if(isItLocked > 0)
                {
                    SKSpriteNode* newLock = [_lockSprite copy];
                    newLock.size = CGSizeMake(_columnWidth, _RowHeight);
                    newLock.zPosition = 26;
                    
                    [newPiece addChild:newLock];
                    
                    newPiece.isLocked = YES;
                
                }
            }
            
            newPiece.scoreMultiplier = 1;
            
            xCoord += _columnWidth;
            
        }
        
        yCoord += _RowHeight;
    }
    
    CDGameBoardSpriteNode* dropIcon = [CDGameBoardSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-ingredient-indicator%@",_deviceModel]];
    
    for (int i=0; i<_numColumns; i++) {
       
        CDGameBoardSpriteNode* bottomPiece = _theVisiblePieces[i];
        
        if(bottomPiece.typeID != CLEAR_BLOCK && bottomPiece.typeID != EMPTY_ITEM){
            CDGameBoardSpriteNode* newIcon = [dropIcon copy];
            newIcon.column = i;
            newIcon.zPosition = 27;
            [_ingredientDropIcons addObject:newIcon];
            
            [_scene addChild:newIcon];
        }
    }
    
    
    if(UIInterfaceOrientationIsLandscape(orientation)){
        
        //DebugLog(@"Landscape");
        
        [self To_Landscape];
        
    }else{
        //DebugLog(@"Portrait");
        
        [self To_Portrait];
    }

    
    
    // Spawn the cookies which wait above the game board.
    [self spawnReserveCookies];
    
}

- (void)setup_Gameboardbackground{
    
    if(_theGameBoardBackgroundTiles == nil){
        
        //DebugLog(@"_theGameBoardBackgroundTiles == null");
        
        return;
        
    }
    
    self.theBackground = nil;
    
    self.theBackground = [NSMutableArray new];
    
    float yCoord = _RowHeight;
    
    // Go through each row.
    for (int row=0; row<_numRows; row++)
    {
        float xCoord =  _columnWidth;
        
        // Set each tile in this row.
        
        for (int column=0; column<_numColumns; column++)
        {
            
            int over = xCoord/_columnWidth;
            int up = yCoord/_RowHeight;
            
            over--;
            up--;
            
            int gridIndex = (up * _numColumns) + over;
            
            CDGameBoardSpriteNode* cookie = _theGameGrid[gridIndex];
            
            if(cookie.typeID == CLEAR_BLOCK)
            {
                
                
            }else{
                
                NSDictionary* tileDict = _theGameBoardBackgroundTiles[(row * _numColumns) + column];
                
                NSString* imageName = tileDict[@"imageName"];
                float rotation = [tileDict[@"rotation"] floatValue];
                
                CDGameBoardSpriteNode* backgroundTile = [CDGameBoardSpriteNode spriteNodeWithImageNamed:imageName];
                
                backgroundTile.zRotation = 0.01745329f * rotation;
                
                backgroundTile.size = CGSizeMake(_columnWidth, _RowHeight);
                
                backgroundTile.zPosition = -1;
                
                backgroundTile.position = [_scene convertPoint:CGPointMake(xCoord, yCoord) fromNode:_gameBoard];;
                
                backgroundTile.column = column;
                backgroundTile.row = row;
                
                [_theBackground addObject:backgroundTile];
                
                [_scene addChild:backgroundTile];
            }
            
            xCoord += _columnWidth;
        }
        
        yCoord += _RowHeight;
    }
    
}

- (void)spawnReserveCookies {

    for (int rowIndex = 0; rowIndex < _numRows; rowIndex++)
    {
        for (int colIndex = 0; colIndex < (_numColumns); colIndex++ )
        {
            CDGameBoardSpriteNode *piece = [self NewCookieWithType:COOKIE_RANDOM];
            
            piece = [self Randomize_this_piece:piece];
            
            piece.hidden = YES;
            piece.zPosition = 2;
            
            if(![piece isMemberOfClass:[CDBombSpriteNode class]])
                piece.size = CGSizeMake(_cookieWidth, _cookieHeight);
            
            if([_SuperCookies containsObject:piece])
                [[CDCookieAnimationManager animationManager] SuperSizing:piece];
            
            
            [_theReservePieces addObject:piece];
            
            if(piece.parent == nil)
                [self.gameBoard addChild:piece];
            
        }
    }
}

//TODO: replace this
- (NSArray *)createRandomBoardOfWidth:(int)width AndHeight:(int)height {
    
    DebugLog(@"Creating a random board.");
    
    NSMutableArray *gameBoard = [NSMutableArray new];
    
    NSDictionary *tile = @{@"itemType": @"COOKIE_RANDOM", @"plateLevel": @0, @"isBottom": @0, @"isLocked": @0};
    
    //NSDictionary *tile = [NSDictionary dictionaryWithObjectsAndKeys:@"COOKIE_RANDOM", @"itemType", 0, @"plateLevel", 0, @"isBottom", 0, @"isLocked", nil];
    
    for (int rowCount = 0; rowCount < height; rowCount++)
    {
        
        NSMutableArray *column = [NSMutableArray new];
        
        for (int tileCount = 0; tileCount < width; tileCount++)
        {
            [column addObject:tile];
        }
        
        [gameBoard addObject:column];
    }
    
    return gameBoard;
}


-(void)Scan_Whole_Board_for_pre_existing_combos{
    
    BOOL did_need_to_change = NO;
    
    for(int i=0; i<_theVisiblePieces.count; i++)
    {
        CDGameBoardSpriteNode* piece = [_theVisiblePieces objectAtIndex:i];
        
        
        if(piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM && [piece isKindOfClass:[CDCookieSpriteNode class]])
            if([self Should_This_piece_be_changed:piece]){
                
                did_need_to_change = YES;
                
                // if it is a cookie
                if([piece isKindOfClass:[CDCookieSpriteNode class]]){
                    
                    [self Randomize_this_Cookie:(CDCookieSpriteNode*)piece];
                    
                    if([_SuperCookies containsObject:piece]){
                        
                        [piece removeAllChildren];
                        [_SuperCookies removeObject:piece];
                        [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                        
                    }else if([_WrappedCookies containsObject:piece]){
                        
                        [piece removeAllChildren];
                        [_WrappedCookies removeObject:piece];
                        [self Wrap_that_cookie:(CDCookieSpriteNode*)piece];
                        
                    }else if([_allBombs containsObject:piece]){
                        
                        [self Bomb_Color_Change:(CDBombSpriteNode*)piece];
                    }
                    
                    if (piece.isLocked) {
                        
                        SKSpriteNode* newLock = [_lockSprite copy];
                        newLock.size = CGSizeMake(_columnWidth, _RowHeight);
                        
                        [piece addChild:newLock];
                    }
                    
                    
                    /*
                     CDCookieSpriteNode* newCookie = (CDCookieSpriteNode*)piece;
                     [self Setup_this_FaceSprite_withFaces:newCookie.faceSprite CookieType:newCookie.typeID];
                     */
                    
                }
            }
    }
    
    if(did_need_to_change)//do another pass
        [self Scan_Whole_Board_for_pre_existing_combos];
    
}

-(BOOL)Should_This_piece_be_changed:(CDGameBoardSpriteNode*)piece{
    
    if(piece.typeID == POWERUP_SMORE || piece.typeID == BOOSTER_SLOTMACHINE || piece.typeID == BOOSTER_RADSPRINKLE)
        return NO;
    
    int vertCount = 1;
    int horCount = 1;
    
    // look up, down, left, right
    
    //up
    for (int i= piece.row+1; i<_numRows; i++) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + piece.column];
        if(theNextPiece.typeID == piece.typeID){
            vertCount++;
        }else
        {
            break;
        }
    }
    
    //down
    for (int i= piece.row-1; i>-1; i--) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + piece.column];
        if(theNextPiece.typeID == piece.typeID){
            vertCount++;
        }else
        {
            break;
        }
    }
    
    //left
    for (int i= piece.column-1; i>-1; i--) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(piece.row * _numColumns) + i];
        if(theNextPiece.typeID == piece.typeID){
            horCount++;
        }else
        {
            break;
        }
    }
    
    //right
    for (int i=piece.column+1; i<_numColumns; i++) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(piece.row * _numColumns) + i];
        if(theNextPiece.typeID == piece.typeID){
            horCount++;
        }else
        {
            break;
        }
    }
    
    if(horCount > 2 || vertCount > 2)
        return YES;
    else
        return NO;
    
}


#pragma mark - Swapping

-(void)PlaySwitchAnimation:(CDGameBoardSpriteNode*)cookie
{
    [[CDCookieAnimationManager animationManager] PlaySwitchAnimation:cookie];
    
}

-(void)PlaySwitchBackAnimation:(CDGameBoardSpriteNode*)cookie
{
    [[CDCookieAnimationManager animationManager] PlaySwitchBackAnimation:cookie];
    
}

- (NSArray*)SetTheGameGrid
{
    
    _showIngredientDropIcons = NO;
    _theGameGrid = [NSMutableArray new];
    _allEmptySpaces = [NSMutableArray new];
    
    for(int i=0; i<_numColumns * _numRows; i++){
        
        CDGameBoardSpriteNode* emptySpite = [CDGameBoardSpriteNode new];
        emptySpite.typeID = EMPTY_ITEM;
        emptySpite.isVulnerable = YES;
        
        float iterator = i;
        float columns = _numColumns;
        int row = floorf(iterator/columns);
        
        emptySpite.row = row;
        emptySpite.column = i - (row * _numColumns);
        
        [_theGameGrid addObject:emptySpite];
        
    }
    
    _allEmptySpaces = [NSMutableArray arrayWithArray:_theGameGrid];
    
    NSMutableArray* obsoleteEmpties = [NSMutableArray new];
    
    for (int i=0; i<_theVisiblePieces.count; i++) {
        
        CDGameBoardSpriteNode* piece = [_theVisiblePieces objectAtIndex:i];
        piece.steps = [NSMutableArray new];
        
        if(piece != nil)
            if(piece.position.y <= _RowHeight * _numRows){ // if it is above the top, ignore
                
                if([piece isKindOfClass:[CDCookieSpriteNode class]]){
                    if(piece.typeID != POWERUP_SMORE && piece.typeID != BOOSTER_RADSPRINKLE &&
                       piece.typeID != BOOSTER_SLOTMACHINE && piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM){
                        
                        piece.isVulnerable = YES;
                        
                    }
                    
                }else if([piece isKindOfClass:[CDIngredientSpriteNode class]]){
                    
                    _showIngredientDropIcons = YES;
                    
                }
                
                piece.column = piece.position.x/_columnWidth;
                piece.row = piece.position.y/_RowHeight;
                
                piece.column--;
                piece.row--;
                
                
                int index = (piece.row * _numColumns) + piece.column;
                
                if(index < _theGameGrid.count){
                    [obsoleteEmpties addObject:_allEmptySpaces[index]];
                    _theGameGrid[index] = piece;
                }
            }
    }
    
    //This no longer works since all the empty SKSpriteNodes are returning
    //the same hash therefore considered the same object and they all get removed
    
    //[_allEmptySpaces removeObjectsInArray:obsoleteEmpties];
    
    //This works!!!
    for (int emptySpaceIndex = 0; emptySpaceIndex < self.allEmptySpaces.count; ++emptySpaceIndex)
    {
        for (int obsoleteIndex = 0; obsoleteIndex < obsoleteEmpties.count; ++obsoleteIndex)
        {
            if (self.allEmptySpaces[emptySpaceIndex] == obsoleteEmpties[obsoleteIndex]) {
                [self.allEmptySpaces removeObjectAtIndex:emptySpaceIndex];
                --emptySpaceIndex;
                break;
            }
        }
    }
    
    for(SKSpriteNode* dropIcon in _ingredientDropIcons){
        
        dropIcon.hidden = !_showIngredientDropIcons;
        
    }
    
    return _theGameGrid;
}

- (BOOL)checkSwap:(CDGameBoardSpriteNode *)gameBoardPiece secondPiece:(CDGameBoardSpriteNode *)secondGameBoardPiece{
    
    
    // the reset
    _isTakingInput = NO;
    _was_a_powerup_triggered = NO;
    _isPlaying_cdd_milky_vortex = NO;
    //_isPlaying_cdd_milky_wave_distorted = NO;
    _isPlaying_CookieWrap = NO;
    _isPlaying_PowerCrunch = NO;
    
    _playerIdleSeconds = 20;
    
    BOOL returnBool = NO;
    
    [_allCombos removeAllObjects];
    [_powerUpVictims removeAllObjects];
    [_inserted_reserve_pieces removeAllObjects];
    
    NSMutableArray* verticalCombos = [NSMutableArray new];
    NSMutableArray* horizontalCombos = [NSMutableArray new];
    NSMutableArray* intersectingPieces = [NSMutableArray new];
    NSMutableArray* preExistingPowerups = [NSMutableArray new];
    
    // 1. the grid was set after the player let go
    
    // 2. check for combos
    {
        // check if both pieces are power ups
        if([self Check_Swapped_Pieces_for_a_Power_Combo:gameBoardPiece CookieTwo:secondGameBoardPiece]){
            
            _was_a_powerup_triggered = YES;
            
        }
        
        if(_was_a_powerup_triggered){
            
            if(!_isPlaying_PowerCrunch){
                
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerCrunch Swipe 1" FileType:@"caf" volume:1]; //@"m4a" volume:1];
                
                _isPlaying_PowerCrunch = YES;
                [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
                    
                    _isPlaying_PowerCrunch = NO;
                    
                }];
                
            }
            
            [self GoodSwap];
            return YES;
        }
        
        // check if piece one is a smore
        if(gameBoardPiece.typeID == POWERUP_SMORE && secondGameBoardPiece.typeID != POWERUP_SMORE && secondGameBoardPiece.typeID != BOOSTER_SLOTMACHINE && secondGameBoardPiece.typeID != BOOSTER_RADSPRINKLE && [secondGameBoardPiece isKindOfClass:[CDCookieSpriteNode class]])
        {
            
            _was_a_powerup_triggered = YES;
            
            gameBoardPiece.isVulnerable = NO;
            [self SearchAndDestroy_target:secondGameBoardPiece.typeID Smore:gameBoardPiece];
            
            returnBool = YES;
            
        }else
            if(secondGameBoardPiece.typeID == POWERUP_SMORE && gameBoardPiece.typeID != POWERUP_SMORE && gameBoardPiece.typeID != BOOSTER_SLOTMACHINE && gameBoardPiece.typeID != BOOSTER_RADSPRINKLE && [gameBoardPiece isKindOfClass:[CDCookieSpriteNode class]])
            {
                
                _was_a_powerup_triggered = YES;
                
                secondGameBoardPiece.isVulnerable = NO;
                [self SearchAndDestroy_target:gameBoardPiece.typeID Smore:secondGameBoardPiece];
                
                returnBool = YES;
                
            }
            else // check if it is a rad sprinkle
                if(gameBoardPiece.typeID == BOOSTER_RADSPRINKLE && ![secondGameBoardPiece isKindOfClass:[CDClearBlockSprite class]]){
                    
                    _was_a_powerup_triggered = YES;
                    
                    int direction = 0; // up down left right
                    
                    if(gameBoardPiece.position.y > secondGameBoardPiece.position.y){
                        
                        direction = 0;
                        
                    }else if(gameBoardPiece.position.y < secondGameBoardPiece.position.y){
                        
                        direction = 1;
                        
                    }else if(gameBoardPiece.position.x < secondGameBoardPiece.position.x){
                        
                        direction = 2;
                        
                    }else if(gameBoardPiece.position.x > secondGameBoardPiece.position.x){
                        
                        direction = 3;
                        
                    }
                    
                    
                    [self Use_Radioactive_Sprinkle:gameBoardPiece OtherPiece:secondGameBoardPiece Direction:direction];
                    
                    returnBool = YES;
                    
                }else{
                    
                    // find vertical and horizontal combos
                    if([gameBoardPiece isKindOfClass:[CDCookieSpriteNode class]] && gameBoardPiece.typeID != POWERUP_SMORE && gameBoardPiece.typeID != BOOSTER_SLOTMACHINE && gameBoardPiece.typeID != BOOSTER_RADSPRINKLE){
                        
                        // vertical first
                        NSMutableArray* Vcombo = [NSMutableArray new];
                        NSMutableArray* Hcombo = [NSMutableArray new];
                        [Vcombo addObject:gameBoardPiece];
                        [Hcombo addObject:gameBoardPiece];
                        
                        // up
                        for (int i= gameBoardPiece.row+1; i<_numRows; i++) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + gameBoardPiece.column];
                            if(theNextPiece.typeID == gameBoardPiece.typeID){
                                [Vcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        // down
                        for (int i= gameBoardPiece.row-1; i>-1; i--) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + gameBoardPiece.column];
                            if(theNextPiece.typeID == gameBoardPiece.typeID){
                                [Vcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        
                        if (Vcombo.count > 2) {
                            [verticalCombos addObject:Vcombo];
                        }
                        
                        // horizontal
                        
                        // right
                        for (int i= gameBoardPiece.column+1; i<_numColumns; i++) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(gameBoardPiece.row * _numColumns) + i];
                            if(theNextPiece.typeID == gameBoardPiece.typeID){
                                [Hcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        // left
                        for (int i= gameBoardPiece.column-1; i>-1; i--) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(gameBoardPiece.row * _numColumns) + i];
                            if(theNextPiece.typeID == gameBoardPiece.typeID){
                                [Hcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        
                        if (Hcombo.count > 2) {
                            [horizontalCombos addObject:Hcombo];
                        }
                    }
                    if([secondGameBoardPiece isKindOfClass:[CDCookieSpriteNode class]] && secondGameBoardPiece.typeID != POWERUP_SMORE && secondGameBoardPiece.typeID != BOOSTER_SLOTMACHINE && secondGameBoardPiece.typeID != BOOSTER_RADSPRINKLE){
                        
                        
                        // vertical first
                        NSMutableArray* Vcombo = [NSMutableArray new];
                        NSMutableArray* Hcombo = [NSMutableArray new];
                        [Vcombo addObject:secondGameBoardPiece];
                        [Hcombo addObject:secondGameBoardPiece];
                        
                        // up
                        for (int i= secondGameBoardPiece.row+1; i<_numRows; i++) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + secondGameBoardPiece.column];
                            if(theNextPiece.typeID == secondGameBoardPiece.typeID){
                                [Vcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        // down
                        for (int i= secondGameBoardPiece.row-1; i>-1; i--) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + secondGameBoardPiece.column];
                            if(theNextPiece.typeID == secondGameBoardPiece.typeID){
                                [Vcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        
                        if (Vcombo.count > 2) {
                            [verticalCombos addObject:Vcombo];
                        }
                        
                        // horizontal
                        
                        // right
                        for (int i= secondGameBoardPiece.column+1; i<_numColumns; i++) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(secondGameBoardPiece.row * _numColumns) + i];
                            if(theNextPiece.typeID == secondGameBoardPiece.typeID){
                                [Hcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        // left
                        for (int i= secondGameBoardPiece.column-1; i>-1; i--) {
                            CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(secondGameBoardPiece.row * _numColumns) + i];
                            if(theNextPiece.typeID == secondGameBoardPiece.typeID){
                                [Hcombo addObject:theNextPiece];
                            }else
                            {
                                break;
                            }
                        }
                        
                        if (Hcombo.count > 2) {
                            [horizontalCombos addObject:Hcombo];
                        }
                        
                    }
                    
                }
    }
    
    if(horizontalCombos.count > 0 || verticalCombos.count > 0){
        returnBool = YES;
    
        // 3. find intersecting pieces
        for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
            NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
            for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
                CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
                for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
                    NSMutableArray* horCombo = horizontalCombos[horComboIndex];
                    for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
                        CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
                        if(vertPiece == horPiece){
                            [intersectingPieces addObject:vertPiece];
                        }
                    }
                }
            }
        }
        
        // 4. add all combos to death row
        for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
            NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
            for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
                
                CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
                [_allCombos addObject:vertPiece];
                vertPiece.isVulnerable = NO;
                vertPiece.scoreMultiplier = _score_multiplier;
                
            }
            _score_multiplier++;
        }
        
        for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
            NSMutableArray* horCombo = horizontalCombos[horComboIndex];
            for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
                
                CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
                [_allCombos addObject:horPiece];
                horPiece.isVulnerable = NO;
                horPiece.scoreMultiplier = _score_multiplier;
            }
            
            _score_multiplier++;
        }
        
        
        // 5. find pre existing power ups
        for (int i=0; i < intersectingPieces.count; i++) {
            
            CDGameBoardSpriteNode* piece = intersectingPieces[i];
            
            if([_SuperCookies containsObject:piece]){
                [preExistingPowerups addObject:piece];
                [_SuperCookies removeObject:piece];
                
                _was_a_powerup_triggered = YES;
                
                if(arc4random() % 2 == 1){
                    [self Super_Horizontal:(CDCookieSpriteNode*)piece];
                }else{
                    [self Super_Vertical:(CDCookieSpriteNode*)piece];
                }
                
            }else if([_WrappedCookies containsObject:piece]){
                [preExistingPowerups addObject:piece];
                
                _was_a_powerup_triggered = YES;
                
                [_WrappedCookies removeObject:piece];
                [self SingleWrapper:piece];
            }
        }
        
        for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
            NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
            for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
                
                CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
                
                if([_SuperCookies containsObject:vertPiece]){
                    if(![preExistingPowerups containsObject:vertPiece]){
                        [preExistingPowerups addObject:vertPiece];
                        
                        _was_a_powerup_triggered = YES;
                        
                        [_SuperCookies removeObject:vertPiece];
                        [self Super_Vertical:(CDCookieSpriteNode*)vertPiece];
                        
                    }
                }else if([_WrappedCookies containsObject:vertPiece]){
                    if(![preExistingPowerups containsObject:vertPiece]){
                        [preExistingPowerups addObject:vertPiece];
                        
                        _was_a_powerup_triggered = YES;
                        
                        [_WrappedCookies removeObject:vertPiece];
                        [self SingleWrapper:(CDCookieSpriteNode*)vertPiece];
                    }
                }
            }
        }
        
        for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
            NSMutableArray* horCombo = horizontalCombos[horComboIndex];
            for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
                
                CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
                
                if([_SuperCookies containsObject:horPiece]){
                    if(![preExistingPowerups containsObject:horPiece]){
                        [preExistingPowerups addObject:horPiece];
                        
                        _was_a_powerup_triggered = YES;
                        
                        [_SuperCookies removeObject:horPiece];
                        [self Super_Horizontal:(CDCookieSpriteNode*)horPiece];
                    }
                }else if([_WrappedCookies containsObject:horPiece]){
                    if(![preExistingPowerups containsObject:horPiece]){
                        [preExistingPowerups addObject:horPiece];
                        
                        _was_a_powerup_triggered = YES;
                        
                        [_WrappedCookies removeObject:horPiece];
                        [self SingleWrapper:(CDCookieSpriteNode*)horPiece];
                        
                    }
                }
                
            }
        }
        
        // 6. wrap intersecting pieces
        for (int i = 0; i<intersectingPieces.count; i++) {
            CDGameBoardSpriteNode* piece = intersectingPieces[i];
            if (![preExistingPowerups containsObject:piece]) {
                
                [self Wrap_that_cookie:(CDCookieSpriteNode*)piece];
                [self Area_Effect:piece  Multiplier:piece.scoreMultiplier];
                [self Add_to_Score:120 Piece:piece];
                [preExistingPowerups addObject:piece];
            }
        }
        
        // 7. look for power up making combos
        for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
            NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
            
            CDGameBoardSpriteNode* OpenPiece = nil;
            
            int index = 0;
            for (int i=0; i < vertCombo.count; i++) {
                
                int vertIndex = index + i;
                if(vertIndex >= vertCombo.count)
                    vertIndex -= vertCombo.count;
                
                CDGameBoardSpriteNode* checkPiece = vertCombo[vertIndex];
                
                if(![preExistingPowerups containsObject:checkPiece]){
                    OpenPiece = checkPiece;
                    break;
                }
            }
            if(OpenPiece != nil){
                if(vertCombo.count >= 5) // smore
                {
                    [self Smore_that_cookie:(CDCookieSpriteNode*)OpenPiece];
                    [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                    [self Add_to_Score:200 Piece:OpenPiece];
                    [preExistingPowerups addObject:OpenPiece];
                    
                }else if(vertCombo.count == 4)// super
                {
                    [self SuperSizeThatCookie:(CDCookieSpriteNode*)OpenPiece];
                    [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                    [self Add_to_Score:60 Piece:OpenPiece];
                    [preExistingPowerups addObject:OpenPiece];
                }
            }
        }
        
        for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
            NSMutableArray* horCombo = horizontalCombos[horComboIndex];
            
            CDGameBoardSpriteNode* OpenPiece = nil;
            
            int index = 0;
            for (int i=0; i < horCombo.count; i++) {
                
                int vertIndex = index + i;
                if(vertIndex >= horCombo.count)
                    vertIndex -= horCombo.count;
                
                CDGameBoardSpriteNode* checkPiece = horCombo[vertIndex];
                
                if(![preExistingPowerups containsObject:checkPiece]){
                    OpenPiece = checkPiece;
                    break;
                }
            }
            if(OpenPiece != nil){
                if(horCombo.count >= 5) // smore
                {
                    [self Smore_that_cookie:(CDCookieSpriteNode*)OpenPiece];
                    [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                    [self Add_to_Score:200 Piece:OpenPiece];
                    [preExistingPowerups addObject:OpenPiece];
                    
                }else if(horCombo.count == 4)// super
                {
                    [self SuperSizeThatCookie:(CDCookieSpriteNode*)OpenPiece];
                    [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                    [self Add_to_Score:60 Piece:OpenPiece];
                    [preExistingPowerups addObject:OpenPiece];
                }
            }
            
        }
        
        // 8. remove pre power ups from death row
        [_allCombos removeObjectsInArray:preExistingPowerups];
        
        // 9. milk slpat the combos
        // play deaths anims
        for (int i=0; i<verticalCombos.count; i++) {
            NSMutableArray* combo = verticalCombos[i];
            for (int k=0; k<combo.count; k++) {
             
                CDGameBoardSpriteNode* victim = combo[k];
                
                if(![preExistingPowerups containsObject:victim]){
                
                    victim.shouldMilkSplash = NO;
                    
                    float iFloat = k;
                    float countFloat = combo.count;
                    
                    float waitTime = (iFloat/countFloat) * 0.5f;
                    
                    SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                                [SKAction runBlock:^{
                        
                        [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
                        
                    }],[SKAction runBlock:^{
                        
                        [self Put_a_milk_splash:victim.position Size:victim.size];
                        
                        // hurt plates
                        [self Area_Effect:victim Multiplier:victim.scoreMultiplier];
                        
                        [self Add_to_Score:_score_Per_cookie * victim.scoreMultiplier Piece:victim];
                        
                    }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                    
                    [victim runAction:piecedeath];
                }
            }
        }
        for (int i=0; i<horizontalCombos.count; i++) {
            NSMutableArray* combo = horizontalCombos[i];
            for (int k=0; k<combo.count; k++) {
                
                CDGameBoardSpriteNode* victim = combo[k];
                
                if(![preExistingPowerups containsObject:victim]){
                    
                    victim.shouldMilkSplash = NO;
                    
                    float iFloat = k;
                    float countFloat = combo.count;
                    
                    float waitTime = (iFloat/countFloat) * 0.5f;
                    
                    SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                                [SKAction runBlock:^{
                        
                        [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
                        
                    }],[SKAction runBlock:^{
                        
                        [self Put_a_milk_splash:victim.position Size:victim.size];
                        
                        // hurt plates
                        [self Area_Effect:victim Multiplier:victim.scoreMultiplier];
                        
                        [self Add_to_Score:_score_Per_cookie * victim.scoreMultiplier Piece:victim];
                        
                    }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                    
                    [victim runAction:piecedeath];
                }
            }
        }
    }
    
    if(returnBool){
        
        [self GoodSwap];
        
        if (!_was_a_powerup_triggered){
            
            [_gameBoard runAction:[SKAction waitForDuration:0.5] completion:^{
                
                [self Kill_Everyone_that_deserves_it];
            }];
            
        }
        
    }else
    {
        [self BadSwap];
    }
    
    return returnBool;
    
}
// old check swap
/*
- (BOOL)checkSwap:(CDGameBoardSpriteNode *)gameBoardPiece secondPiece:(CDGameBoardSpriteNode *)secondGameBoardPiece{
    
    
    // order
     
   //  1. set the grid
     
   //  2. check for combos
   //  a.check for a Power up combo
   //  b.check if piece1 is a smore
   //  c.check for regular combos
     
   //  3. remove combo pieces
   //  a. removes combo pieces from sight and the visible array,
   //  then changes the piece and puts it into the reserve array
   //
   //  NOTE: Piece_Death is best called top to bottom
     
   //  b. drop top pieces, this is called in Piece_Death
     
   //  5. spawn new pieces, this is called in Drop_the_Pieces_Above_this_One
     
   //  6. check the whole board for combos after the pieces dropped.
   //  this will loop until there were no combos
     
     
   //  7. give control back to the player aka _isTakingInput = YES;
    
    // the reset
    _isTakingInput = NO;
    _was_a_powerup_triggered = NO;
    _isPlaying_cdd_milky_vortex = NO;
    _isPlaying_cdd_milky_wave_distorted = NO;
    _isPlaying_CookieWrap = NO;
    _isPlaying_PowerCrunch = NO;
    
    _playerIdleSeconds = 20;
    
    BOOL returnBool = NO;
    
    [_allCombos removeAllObjects];
    [_powerUpVictims removeAllObjects];
    [_inserted_reserve_pieces removeAllObjects];
    
    // 1. the grid was set after the player let go
    
    // 2. check for combos
    {
        // check if both pieces are power ups
        if([self Check_Swapped_Pieces_for_a_Power_Combo:gameBoardPiece CookieTwo:secondGameBoardPiece]){
            
            _was_a_powerup_triggered = YES;
            
        }
        
        if(_was_a_powerup_triggered){
            
            if(!_isPlaying_PowerCrunch){
                
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerCrunch Swipe 1" FileType:@"m4a" volume:1];
                
                _isPlaying_PowerCrunch = YES;
                [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
                    
                    _isPlaying_PowerCrunch = NO;
                    
                }];
                
            }
            
            [self GoodSwap];
            return YES;
        }
        
        // check if piece one is a smore
        if(gameBoardPiece.typeID == POWERUP_SMORE && secondGameBoardPiece.typeID != POWERUP_SMORE && secondGameBoardPiece.typeID != BOOSTER_SLOTMACHINE && secondGameBoardPiece.typeID != BOOSTER_RADSPRINKLE && [secondGameBoardPiece isKindOfClass:[CDCookieSpriteNode class]])
        {
            
            _was_a_powerup_triggered = YES;
            
            gameBoardPiece.isVulnerable = NO;
            [self SearchAndDestroy_target:secondGameBoardPiece.typeID Smore:gameBoardPiece];
            
            returnBool = YES;
            
        }else
            if(secondGameBoardPiece.typeID == POWERUP_SMORE && gameBoardPiece.typeID != POWERUP_SMORE && gameBoardPiece.typeID != BOOSTER_SLOTMACHINE && gameBoardPiece.typeID != BOOSTER_RADSPRINKLE && [gameBoardPiece isKindOfClass:[CDCookieSpriteNode class]])
            {
                
                _was_a_powerup_triggered = YES;
                
                secondGameBoardPiece.isVulnerable = NO;
                [self SearchAndDestroy_target:gameBoardPiece.typeID Smore:secondGameBoardPiece];
                
                returnBool = YES;
                
            }
        else // check if it is a rad sprinkle
            if(gameBoardPiece.typeID == BOOSTER_RADSPRINKLE && ![secondGameBoardPiece isKindOfClass:[CDClearBlockSprite class]]){
                
                _was_a_powerup_triggered = YES;
                
                int direction = 0; // up down left right
                
                if(gameBoardPiece.position.y > secondGameBoardPiece.position.y){
                    
                    direction = 0;
                    
                }else if(gameBoardPiece.position.y < secondGameBoardPiece.position.y){
                    
                    direction = 1;
                    
                }else if(gameBoardPiece.position.x < secondGameBoardPiece.position.x){
                    
                    direction = 2;
                    
                }else if(gameBoardPiece.position.x > secondGameBoardPiece.position.x){
                    
                    direction = 3;
                    
                }
                
                
                [self Use_Radioactive_Sprinkle:gameBoardPiece OtherPiece:secondGameBoardPiece Direction:direction];
                
                returnBool = YES;
                
            }else{
                
                if(![gameBoardPiece isKindOfClass:[CDIngredientSpriteNode class]])
                    returnBool = [self Check_Swapped_Piece_for_combos_and_powerups:gameBoardPiece];
                
                // have to check both
                if(![secondGameBoardPiece isKindOfClass:[CDIngredientSpriteNode class]]){
                    
                    if([self Check_Swapped_Piece_for_combos_and_powerups:secondGameBoardPiece]) // it still gets checked by doing this
                        returnBool = YES;
                    
                }
            }
    }
    
    if(_was_a_powerup_triggered){
        
        [self GoodSwap];
        return YES;
    }
    
    // 3. // 4. // 5.
    if(returnBool){
        
        [self GoodSwap];
        
        // play deaths anims
        for (CDGameBoardSpriteNode* victim in _allCombos) {
            
            [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
        }
        
        [_gameBoard runAction:[SKAction waitForDuration:0.5] completion:^{
            
            [self Kill_Everyone_that_deserves_it];
            
        }];
        
    }else
    {
        [self BadSwap];
    }
    
    
    return returnBool;
    
}
 */
 
-(BOOL)Check_Swapped_Pieces_for_a_Power_Combo:(CDGameBoardSpriteNode*)piece1 CookieTwo:(CDGameBoardSpriteNode*)piece2
{
    
    BOOL returnValue = NO;
    
    // 1 Super, 2 Wrapped, 3 Smore, 4 Tin
    
    int TypeOne = 0;
    int TypeTwo = 0;
    
    if([self.SuperCookies containsObject:piece1])
        TypeOne = 1;
    else if ([self.WrappedCookies containsObject:piece1])
        TypeOne = 2;
    else if(piece1.typeID == POWERUP_SMORE)
        TypeOne = 3;
    else if(piece1.typeID == BOOSTER_RADSPRINKLE)
        TypeOne = 4;
    
    
    if([self.SuperCookies containsObject:piece2])
        TypeTwo = 1;
    else if ([self.WrappedCookies containsObject:piece2])
        TypeTwo = 2;
    else if(piece2.typeID == POWERUP_SMORE)
        TypeTwo = 3;
    else if(piece2.typeID == BOOSTER_RADSPRINKLE)
        TypeTwo = 4;
    
    
    if(TypeOne == 1 && TypeTwo == 1){
        
        [_SuperCookies removeObject:piece1];
        [_SuperCookies removeObject:piece2];
        
        piece1.isVulnerable = NO;
        piece2.isVulnerable = NO;
        
        [self Super_on_Super:piece1 SecondPiece:piece2];
        
        returnValue = YES;
        
    }else if((TypeOne == 1 && TypeTwo == 2) || (TypeOne == 2 && TypeTwo == 1) ){
        
        
        [self Super_on_Wrapper:piece1 SecondPiece:piece2];
        
        returnValue = YES;
        
    }else if((TypeOne == 2 && TypeTwo == 2) || (TypeOne == 2 && TypeTwo == 2) ){
        
        [_WrappedCookies removeObject:piece1];
        [_WrappedCookies removeObject:piece2];
        
        [self Wrapper_on_Wrapper:piece1 secondPiece:piece2];
        
        returnValue = YES;
        
    }else if((TypeOne == 3 && TypeTwo == 3) || (TypeOne == 3 && TypeTwo == 3) ){
        
        [self Smore_on_Smore:piece1 SecondSmore:piece2];
        
        returnValue = YES;
        
    }else if((TypeOne == 1 && TypeTwo == 3) || (TypeOne == 3 && TypeTwo == 1) ){
        
        if(TypeOne == 3){
        
            [self Smore_on_Super:piece1 Target:piece2];
        
        }else{
            
            [self Smore_on_Super:piece2 Target:piece1];
            
        }
        
        returnValue = YES;
        
    }else if((TypeOne == 2 && TypeTwo == 3) || (TypeOne == 3 && TypeTwo == 2) ){
        
        if(TypeOne == 3){
            
            [self Smore_on_Wrapper:piece1 Target:piece2];
            
        }else{
            
            [self Smore_on_Wrapper:piece2 Target:piece1];
            
        }
        
        returnValue = YES;
    }
    
    return returnValue;
    
}

/*
-(BOOL)Check_Swapped_Piece_for_combos_and_powerups:(CDGameBoardSpriteNode*)piece
{
    BOOL returnBool = NO;
    
    if(piece.typeID == POWERUP_SMORE || piece.typeID == BOOSTER_SLOTMACHINE || piece.typeID == BOOSTER_RADSPRINKLE)
        return returnBool;
    
    NSMutableArray* horizontalCombo = [NSMutableArray new];
    NSMutableArray* verticalCombo = [NSMutableArray new];
    
    [horizontalCombo addObject:piece];
    [verticalCombo addObject:piece];
    
    // look up, down, left, right
    
    //up
    for (int i= piece.row+1; i<_numRows; i++) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + piece.column];
        if(theNextPiece.typeID == piece.typeID){
            [verticalCombo addObject:theNextPiece];
        }else
        {
            break;
        }
    }
    
    //down
    for (int i= piece.row-1; i>-1; i--) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + piece.column];
        if(theNextPiece.typeID == piece.typeID){
            [verticalCombo addObject:theNextPiece];
        }else
        {
            break;
        }
    }
    
    //left
    for (int i= piece.column-1; i>-1; i--) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(piece.row * _numColumns) + i];
        if(theNextPiece.typeID == piece.typeID){
            [horizontalCombo addObject:theNextPiece];
        }else
        {
            break;
        }
    }
    
    //right
    for (int i=piece.column+1; i<_numColumns; i++) {
        
        CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(piece.row * _numColumns) + i];
        if(theNextPiece.typeID == piece.typeID){
            [horizontalCombo addObject:theNextPiece];
        }else
        {
            break;
        }
    }
    
    // make all combo pieces not up for grabs
    
    if(horizontalCombo.count > 2){
        
        returnBool = YES;
        
        for(CDGameBoardSpriteNode* comboPiece in horizontalCombo){
            comboPiece.isVulnerable = NO;
        }
    }
    
    if(verticalCombo.count > 2){
        
        returnBool = YES;
        
        for(CDGameBoardSpriteNode* comboPiece in verticalCombo){
            comboPiece.isVulnerable = NO;
        }
    }
    
    NSMutableArray* preExistingPowerUps = [NSMutableArray new];
    
    if(horizontalCombo.count > 2){
        
        // now activate power ups
        
        for (int i=0; i<horizontalCombo.count; i++) {
            
            CDGameBoardSpriteNode* checkPiece = [horizontalCombo objectAtIndex:i];
            
            if([_SuperCookies containsObject:checkPiece]){
                
                [_SuperCookies removeObject:checkPiece];
                
                [self Super_Horizontal:(CDCookieSpriteNode*)checkPiece];
               
                
                _was_a_powerup_triggered = YES;
                
                [preExistingPowerUps addObject:checkPiece];
                
            }else if([_WrappedCookies containsObject:checkPiece]){
                
                [_WrappedCookies removeObject:checkPiece];
                [self SingleWrapper:checkPiece];
                
                _was_a_powerup_triggered = YES;
                
                [preExistingPowerUps addObject:checkPiece];
                
            }
        }
    }
    
    if(verticalCombo.count > 2){
        
        // now activate power ups
        
        for (int i=0; i<verticalCombo.count; i++) {
            
            CDGameBoardSpriteNode* checkPiece = [verticalCombo objectAtIndex:i];
            
            if([_SuperCookies containsObject:checkPiece]){
                
                [_SuperCookies removeObject:checkPiece];
                
                [self Super_Vertical:(CDCookieSpriteNode*)checkPiece];
                
                
                _was_a_powerup_triggered = YES;
                
                [preExistingPowerUps addObject:checkPiece];
                
            }else if([_WrappedCookies containsObject:checkPiece]){
                
                [_WrappedCookies removeObject:checkPiece];
                [self SingleWrapper:checkPiece];
                
                _was_a_powerup_triggered = YES;
                
                [preExistingPowerUps addObject:checkPiece];
                
            }
        }
    }
    
    // now check if it should make power ups
    
    BOOL isDoneHere = NO;
    BOOL isHorizontalDeleting = NO;
    BOOL isVerticalDeleting = NO;
    
    // smore takes over
    if(verticalCombo.count >= 5){
        
        [verticalCombo removeObjectsInArray:preExistingPowerUps];
        
        if([preExistingPowerUps containsObject:piece]){
            
            if(verticalCombo.count > 0){
                
                CDCookieSpriteNode* newPowerup = verticalCombo[arc4random() % verticalCombo.count];
                
                [verticalCombo removeObject:newPowerup];
                
                if([horizontalCombo containsObject:newPowerup]){
                    
                    [horizontalCombo removeObject:newPowerup];
                    
                    if(horizontalCombo.count > 1){
                        
                        isHorizontalDeleting = YES;
                        [_allCombos addObjectsFromArray:horizontalCombo];
                    }
                    
                }
                
                [self Area_Effect:newPowerup];
                
                [self Smore_that_cookie:newPowerup];
                [self Add_to_Score:200 Piece:newPowerup];
                
            }
            
        }else{
            
            [verticalCombo removeObject:piece];
            
            if([horizontalCombo containsObject:piece]){
                
                [horizontalCombo removeObject:piece];
                
                if(horizontalCombo.count > 1){
                    
                    isHorizontalDeleting = YES;
                    [_allCombos addObjectsFromArray:horizontalCombo];
                }
                
            }
            
            [self Area_Effect:piece];
            [self Smore_that_cookie:(CDCookieSpriteNode*)piece];
            [self Add_to_Score:200 Piece:piece];
            
        }
        
        [_allCombos addObjectsFromArray:verticalCombo];
        
        returnBool = YES;
        isVerticalDeleting = YES;
        isDoneHere = YES;
        
    }
    
    if(horizontalCombo.count >= 5){
        
        [horizontalCombo removeObjectsInArray:preExistingPowerUps];
        
        if([preExistingPowerUps containsObject:piece]){
            
            if(horizontalCombo.count > 0){
                
                CDCookieSpriteNode* newPowerup = horizontalCombo[arc4random() % horizontalCombo.count];
                
                [horizontalCombo removeObject:newPowerup];
                
                if([verticalCombo containsObject:newPowerup]){
                    
                    [verticalCombo removeObject:newPowerup];
                    
                    if(verticalCombo.count > 1){
                        
                        isVerticalDeleting = YES;
                        [_allCombos addObjectsFromArray:verticalCombo];
                    }
                    
                }
                
                [self Area_Effect:newPowerup];
                [self Smore_that_cookie:newPowerup];
                [self Add_to_Score:200 Piece:newPowerup];
                
            }
            
        }else{
            
            [horizontalCombo removeObject:piece];
            
            if([verticalCombo containsObject:piece]){
                
                [verticalCombo removeObject:piece];
                
                if(verticalCombo.count > 1){
                    
                    isVerticalDeleting = YES;
                    [_allCombos addObjectsFromArray:verticalCombo];
                }
                
            }
            
            [self Area_Effect:piece];
            [self Smore_that_cookie:(CDCookieSpriteNode*)piece];
            [self Add_to_Score:200 Piece:piece];
            
        }
        
        [_allCombos addObjectsFromArray:horizontalCombo];
        
        returnBool = YES;
        isHorizontalDeleting = YES;
        isDoneHere = YES;
    }
    
    // check if it  should wrap
    if(!isDoneHere)
    if(horizontalCombo.count > 2 && verticalCombo.count > 2){
        
        for (int i=0; i<horizontalCombo.count; i++) {
            
            CDGameBoardSpriteNode* checkPiece = horizontalCombo[i];
            
            if([verticalCombo containsObject:checkPiece]){ // wrap it
                
                isHorizontalDeleting = YES;
                isVerticalDeleting = YES;
                
                if(preExistingPowerUps.count > 0){
                    
                    [horizontalCombo removeObjectsInArray:preExistingPowerUps];
                    [verticalCombo removeObjectsInArray:preExistingPowerUps];
                    
                    if([preExistingPowerUps containsObject:checkPiece]){ // find another
                        
                        if(horizontalCombo.count > 0){
                            
                            CDCookieSpriteNode* newWrapper = horizontalCombo[arc4random() % horizontalCombo.count];
                            [self Area_Effect:newWrapper];
                            [self Wrap_that_cookie:newWrapper];
                            
                            [self Add_to_Score:120 Piece:newWrapper];
                            
                            isDoneHere = YES;
                            
                            [horizontalCombo removeObject:newWrapper];
                            [verticalCombo removeObject:newWrapper];
                            
                            [_allCombos addObjectsFromArray:horizontalCombo];
                            [_allCombos addObjectsFromArray:verticalCombo];
                            
                        }else if(verticalCombo.count > 0){
                            
                            CDCookieSpriteNode* newWrapper = verticalCombo[arc4random() % verticalCombo.count];
                            [self Area_Effect:newWrapper];
                            [self Wrap_that_cookie:newWrapper];
                            
                            [self Add_to_Score:120 Piece:newWrapper];
                            
                            isDoneHere = YES;
                            
                            [horizontalCombo removeObject:newWrapper];
                            [verticalCombo removeObject:newWrapper];
                            
                            [_allCombos addObjectsFromArray:horizontalCombo];
                            [_allCombos addObjectsFromArray:verticalCombo];
                        }
                        
                    }else{
                        
                        [self Area_Effect:checkPiece];
                        [self Wrap_that_cookie:(CDCookieSpriteNode*)checkPiece];
                        
                        [self Add_to_Score:120 Piece:checkPiece];
                        
                        isDoneHere = YES;
                        [horizontalCombo removeObject:checkPiece];
                        [verticalCombo removeObject:checkPiece];
                        
                        [_allCombos addObjectsFromArray:horizontalCombo];
                        [_allCombos addObjectsFromArray:verticalCombo];
                    }
                    
                }
                else{ // if(preExistingPowerUps.count > 0)
                    
                    [self Area_Effect:checkPiece];
                    [self Wrap_that_cookie:(CDCookieSpriteNode*)checkPiece];
                    
                    [self Add_to_Score:120 Piece:checkPiece];
                    
                    isDoneHere = YES;
                    [horizontalCombo removeObject:checkPiece];
                    [verticalCombo removeObject:checkPiece];
                    
                    [_allCombos addObjectsFromArray:horizontalCombo];
                    [_allCombos addObjectsFromArray:verticalCombo];
                }

                
                
                break;
            }
            
        }
        
    }

    // check if it is done
    
    if (!isDoneHere) {
        
        if(verticalCombo.count == 3){
            
            [verticalCombo removeObjectsInArray:preExistingPowerUps];
            
            [_allCombos addObjectsFromArray:verticalCombo];
            
            returnBool = YES;
            isVerticalDeleting = YES;
            
        }else
            if(verticalCombo.count == 4){
                
                [verticalCombo removeObjectsInArray:preExistingPowerUps];
                
                if([preExistingPowerUps containsObject:piece]){
                
                    if(verticalCombo.count > 0){
                        
                        CDCookieSpriteNode* newPowerup = verticalCombo[arc4random() % verticalCombo.count];
                        
                        [verticalCombo removeObject:newPowerup];
                        [self Area_Effect:newPowerup];
                        [self SuperSizeThatCookie:newPowerup];
                        [self Add_to_Score:60 Piece:newPowerup];
                        
                    }
                    
                }else{
                    
                    [verticalCombo removeObject:piece];
                    [self Area_Effect:piece];
                    [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                    [self Add_to_Score:60 Piece:piece];
                
                }
                
                [_allCombos addObjectsFromArray:verticalCombo];
                
                returnBool = YES;
                isVerticalDeleting = YES;
                
            }
        
        // horizontal
        
        if(horizontalCombo.count == 3){
            
            [horizontalCombo removeObjectsInArray:preExistingPowerUps];
            
            [_allCombos addObjectsFromArray:horizontalCombo];
            
            returnBool = YES;
            isHorizontalDeleting = YES;
            
        }else
            if(horizontalCombo.count == 4){
                
                [horizontalCombo removeObjectsInArray:preExistingPowerUps];
                
                if([preExistingPowerUps containsObject:piece]){
                    
                    if(horizontalCombo.count > 0){
                        
                        CDCookieSpriteNode* newPowerup = horizontalCombo[arc4random() % horizontalCombo.count];
                        
                        [horizontalCombo removeObject:newPowerup];
                        [self Area_Effect:newPowerup];
                        [self SuperSizeThatCookie:newPowerup];
                        [self Add_to_Score:60 Piece:newPowerup];
                        
                    }
                    
                }else{
                    
                    [horizontalCombo removeObject:piece];
                    [self Area_Effect:piece];
                    [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                    [self Add_to_Score:60 Piece:piece];
                    
                }
                
                [_allCombos addObjectsFromArray:horizontalCombo];
                
                returnBool = YES;
                isHorizontalDeleting = YES;
                
            }
        
    }
    
    // now remove the combo pieces
    if(isHorizontalDeleting){
        for(int i=0; i<horizontalCombo.count; i++){
            
            CDGameBoardSpriteNode* comboPiece = horizontalCombo[i];
            
            comboPiece.shouldMilkSplash = NO;
            
            float iFloat = i;
            float countFloat = horizontalCombo.count;
            
            float waitTime = (iFloat/countFloat) * 0.5f;
            
            SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                        [SKAction runBlock:^{
                
                [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:comboPiece];
                
            }],[SKAction runBlock:^{
                
                [self Put_a_milk_splash:comboPiece.position Size:comboPiece.size];
                
                // hurt plates
                [self Area_Effect:comboPiece];
                
                    [self Add_to_Score:_score_Per_cookie Piece:comboPiece];
                
            }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
            
            [comboPiece runAction:piecedeath];
          
            
        }
    }
    if(isVerticalDeleting) {
        for(int i=0; i<verticalCombo.count; i++){
            
            CDGameBoardSpriteNode* comboPiece = verticalCombo[i];
            
            if(comboPiece.shouldMilkSplash == YES)
            {
                comboPiece.shouldMilkSplash = NO;
                
                float iFloat = i;
                float countFloat = verticalCombo.count;
                
                float waitTime = (iFloat/countFloat) * 0.5f;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                            [SKAction runBlock:^{
                    
                    [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:comboPiece];
                    
                }],[SKAction runBlock:^{
                    
                    [self Put_a_milk_splash:comboPiece.position Size:comboPiece.size];
                    
                    // hurt plates
                    [self Area_Effect:comboPiece];
                    
                    [self Add_to_Score:_score_Per_cookie Piece:comboPiece];
                    
                }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                
                [comboPiece runAction:piecedeath];
            }
            
        }
    }

    
    return returnBool;
}
 
 */

-(void)Remove_Combo_Pieces
{
    for (int row=_numRows; row>-1; row--) {
        for(int i=0; i<_allCombos.count; i++){
            CDGameBoardSpriteNode* piece = [_allCombos objectAtIndex:i];

        
            // death FX
            {
                if(piece.shouldMilkSplash){
                    
                    [self Put_a_milk_splash:piece.position Size:piece.size];
                    
                    [self Add_to_Score:_score_Per_cookie * piece.scoreMultiplier Piece:piece];
                    
                    // hurt plates
                    [self Area_Effect:piece Multiplier:piece.scoreMultiplier];
                    
                }
            }
        }
    }
    
}

-(void)Kill_Everyone_that_deserves_it
{
    DebugLog(@"Kill_Everyone_that_deserves_it");
    
    
    _numFallingPieces = 0;
    [_inserted_reserve_pieces removeAllObjects];
    
    // 1. first tell every victim to die
    for(int i=0; i<_allCombos.count; i++){
        CDGameBoardSpriteNode* piece = [_allCombos objectAtIndex:i];
        [self Piece_Death:piece];
    }
    
    [self SetTheGameGrid];
    
    // 2. get the empties as high as they can go
    for (int i= (int)_allEmptySpaces.count-1; i>=0; i--) {
        CDGameBoardSpriteNode* spot = _allEmptySpaces[i];
        [self FillEmptyVertically:spot Speed:0.2f];
    }
    
    // line up the _inserted_reserve_pieces
    
    // find the lowest row
    int lowestRow = _numRows;
    for(CDGameBoardSpriteNode* piece in _inserted_reserve_pieces){
        if(piece.row < lowestRow)
            lowestRow = piece.row;
    }
    
    for(CDGameBoardSpriteNode* piece in _inserted_reserve_pieces){
        
        piece.position = CGPointMake(piece.position.x, _scene.size.height + (piece.row * _RowHeight));
        
        float duration =  0.2f * ((piece.row - lowestRow)+1);
        
        [piece.steps insertObject:[SKAction moveTo:CGPointMake(piece.position.x, _numRows * _RowHeight) duration:duration] atIndex:0];
    }
    
    // 3. tell everyone but the new guys
    for(int i=0; i<_theGameGrid.count; i++){
        
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
    
        // check if it can drop
        if(piece.isLocked || [_inserted_reserve_pieces containsObject:piece]){
            
        }else if([piece isKindOfClass:[CDCookieSpriteNode class]] ||
                 piece.typeID == BLOCKER_PRETZEL ||
                 [piece isKindOfClass:[CDIngredientSpriteNode class]]){
            
            //1. find your path
            NSMutableArray* steps = [NSMutableArray new];
            [self SandFill_Piece:piece Column:piece.column Row:piece.row Steps:steps Speed:0.2f];
            
            [piece.steps addObjectsFromArray:steps];
        }
    }
    
    // 3B now tell the new guys
    for(int i=0; i<_inserted_reserve_pieces.count; i++){
        
        CDGameBoardSpriteNode* piece = _inserted_reserve_pieces[i];
        
        //1. find your path
        NSMutableArray* steps = [NSMutableArray new];
        [self SandFill_Piece:piece Column:piece.column Row:piece.row Steps:steps Speed:0.2f];
        
        [piece.steps addObjectsFromArray:steps];
    }
    
    // 4. tell everyone to move
    BOOL didSomeOneMove = NO;
    for(CDGameBoardSpriteNode* piece in _theVisiblePieces)
    {
        
        if(piece.steps.count > 1){
            didSomeOneMove = YES;
            [[CDCookieAnimationManager animationManager] PlayFallingAnimation:piece];
        
            _numFallingPieces++;
            [piece runAction:[SKAction sequence:piece.steps] completion:^{
            
                piece.position = CGPointMake(_columnWidth + (_columnWidth * piece.column),
                                             _RowHeight + (_RowHeight * piece.row));
                
                _numFallingPieces--;
                
                if(_numFallingPieces <= 0)
                {
                    _numFallingPieces = 0;
                    
                    [self Kill_Everyone_that_deserves_it];
                    
                    [self UpdateHUD];
                }
            }];
        }
    }
    
    if(!didSomeOneMove){
        
        DebugLog(@"Kill_Everyone_that_deserves_it !didSomeOneMove");
        
        if(_inserted_reserve_pieces.count > 0){
            
            [_allCombos removeAllObjects];
            [self Kill_Everyone_that_deserves_it];
            
        }else if(_isNukeAfterMath){
            _isNukeAfterMath = NO;
            [self NukeAfterMath];
        }else{
            [self Scan_and_clear_the_grid_of_combos];
        }
    }
    
    DebugLog(@"Kill_Everyone_that_deserves_it end");
    
}

-(void)FillEmptyVertically:(CDGameBoardSpriteNode*)spot Speed:(float)speed
{
    
    if(spot.row >= _numRows-1){
        [self DropNewPiece:spot Speed:speed];
        return;
    }
    
    int spotIndex = (spot.row * _numColumns) + spot.column;
    
    CDGameBoardSpriteNode* topPiece;
    // look through clearBlocks
    for(int i=spot.row+1; i<_numRows; i++){
        
        topPiece = _theGameGrid[(i * _numColumns)+ spot.column];
        
        if(topPiece.typeID == CLEAR_BLOCK){
            
        }else{
            break;
        }
    }
    
    int topIndex = (topPiece.row * _numColumns) + spot.column;
    
    // check if it can drop
    if(topPiece.isLocked){
        
    }else if([topPiece isKindOfClass:[CDCookieSpriteNode class]] ||
             topPiece.typeID == BLOCKER_PRETZEL ||
             [topPiece isKindOfClass:[CDIngredientSpriteNode class]]){

        int topPieceRow = topPiece.row;
        int spotPieceRow = spot.row;
        
        spot.row = topPieceRow;
        topPiece.row = spotPieceRow;
        
        _theGameGrid[spotIndex] = topPiece;
        _theGameGrid[topIndex] = spot;
        
        [topPiece.steps addObject:[SKAction moveTo:CGPointMake(_columnWidth +(_columnWidth * topPiece.column) ,_RowHeight + (_RowHeight * topPiece.row))  duration:speed]];
        
        [self FillEmptyVertically:spot Speed:speed];
    
    }else if(topPiece.typeID == CLEAR_BLOCK){
        
        [self DropNewPiece:topPiece Speed:speed];
        
    }
    
}

#pragma mark - After swapping

-(void)Scan_and_clear_the_grid_of_combos
{
    
    [self SetTheGameGrid];
    
    _isTakingInput = NO;
    
    _isPlaying_cdd_milky_vortex = NO;
    //_isPlaying_cdd_milky_wave_distorted = NO;
    _isPlaying_CookieWrap = NO;
    _isPlaying_PowerCrunch = NO;
    
    _was_a_powerup_triggered = NO;
    [_allCombos removeAllObjects]; // the reset
    [_powerUpVictims removeAllObjects];
    [_inserted_reserve_pieces removeAllObjects];
    
    BOOL did_make_a_combo = NO;
    
    
    if([self Check_for_bottom_row_ingredients]){
        _was_a_powerup_triggered = YES;
        did_make_a_combo = YES;
    }
    
    NSMutableArray* verticalCombos = [NSMutableArray new];
    NSMutableArray* horizontalCombos = [NSMutableArray new];
    NSMutableArray* intersectingPieces = [NSMutableArray new];
    NSMutableArray* preExistingPowerups = [NSMutableArray new];
    
    // 1. find vertical combos
    for (int column=0; column<_numColumns; column++) {
        for (int row=0; row<_numRows; row++) {
            
            CDGameBoardSpriteNode* piece = _theGameGrid[(row * _numColumns) + column];
            
            NSMutableArray* combo = [NSMutableArray new];
            [combo addObject:piece];
            // up
            if([piece isKindOfClass:[CDCookieSpriteNode class]] && piece.typeID != POWERUP_SMORE && piece.typeID != BOOSTER_SLOTMACHINE && piece.typeID != BOOSTER_RADSPRINKLE){
                for (int i= piece.row+1; i<_numRows; i++) {
                    CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(i * _numColumns) + column];
                    if(theNextPiece.typeID == piece.typeID){
                        
                        [combo addObject:theNextPiece];
                        row++;
                        
                    }else
                    {
                        break;
                    }
                }
            }
            
            if(combo.count > 2){
                [verticalCombos addObject:combo];
                did_make_a_combo = YES;
            }
        }
    }

    // 2. find horizontal combos
    for (int row=0; row<_numRows; row++) {
        for (int column=0; column<_numColumns; column++) {
            
            CDGameBoardSpriteNode* piece = _theGameGrid[(row * _numColumns) + column];
            
            NSMutableArray* combo = [NSMutableArray new];
            [combo addObject:piece];
            // right
            if([piece isKindOfClass:[CDCookieSpriteNode class]] && piece.typeID != POWERUP_SMORE && piece.typeID != BOOSTER_SLOTMACHINE && piece.typeID != BOOSTER_RADSPRINKLE){
                for (int i=piece.column+1; i<_numColumns; i++) {
                    
                    CDGameBoardSpriteNode* theNextPiece = [_theGameGrid objectAtIndex:(row * _numColumns) + i];
                    if(theNextPiece.typeID == piece.typeID){
                        [combo addObject:theNextPiece];
                        column++;
                        
                    }else
                    {
                        break;
                    }
                }
            }
            
            if(combo.count > 2){
                [horizontalCombos addObject:combo];
                did_make_a_combo = YES;
            }
        }
    }

    // 3. find intersecting pieces
    for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
        NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
        for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
            CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
            for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
                NSMutableArray* horCombo = horizontalCombos[horComboIndex];
                for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
                    CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
                    if(vertPiece == horPiece){
                        [intersectingPieces addObject:vertPiece];
                    }
                }
            }
        }
    }
    
    // 4. add all combos to death row
    for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
        NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
        for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
            
            CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
            [_allCombos addObject:vertPiece];
            vertPiece.isVulnerable = NO;
            vertPiece.scoreMultiplier = _score_multiplier;
        }
        
        _score_multiplier++;
    }
    
    for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
        NSMutableArray* horCombo = horizontalCombos[horComboIndex];
        for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
            
            CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
            [_allCombos addObject:horPiece];
            horPiece.isVulnerable = NO;
            horPiece.scoreMultiplier = _score_multiplier;
        }
        _score_multiplier++;
    }
    
    // 5. find pre existing power ups
    for (int i=0; i < intersectingPieces.count; i++) {
        
        CDGameBoardSpriteNode* piece = intersectingPieces[i];
        
        if([_SuperCookies containsObject:piece]){
            [preExistingPowerups addObject:piece];
            [_SuperCookies removeObject:piece];
            
            _was_a_powerup_triggered = YES;
            
            if(arc4random() % 2 == 1){
                [self Super_Horizontal:(CDCookieSpriteNode*)piece];
            }else{
                [self Super_Vertical:(CDCookieSpriteNode*)piece];
            }
            
        }else if([_WrappedCookies containsObject:piece]){
            [preExistingPowerups addObject:piece];
            
            _was_a_powerup_triggered = YES;
            
            [_WrappedCookies removeObject:piece];
            [self SingleWrapper:piece];
        }
    }
    
    for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
        NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
        for (int vertPieceIndex=0; vertPieceIndex < vertCombo.count; vertPieceIndex++) {
            
            CDGameBoardSpriteNode* vertPiece = vertCombo[vertPieceIndex];
            
            if([_SuperCookies containsObject:vertPiece]){
                if(![preExistingPowerups containsObject:vertPiece]){
                    [preExistingPowerups addObject:vertPiece];
                    
                    _was_a_powerup_triggered = YES;
                    
                    [_SuperCookies removeObject:vertPiece];
                    [self Super_Vertical:(CDCookieSpriteNode*)vertPiece];
                    
                }
            }else if([_WrappedCookies containsObject:vertPiece]){
                if(![preExistingPowerups containsObject:vertPiece]){
                    [preExistingPowerups addObject:vertPiece];
                    
                    _was_a_powerup_triggered = YES;
                    
                    [_WrappedCookies removeObject:vertPiece];
                    [self SingleWrapper:(CDCookieSpriteNode*)vertPiece];
                }
            }
        }
    }
    
    for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
        NSMutableArray* horCombo = horizontalCombos[horComboIndex];
        for (int horPieceIndex=0; horPieceIndex < horCombo.count; horPieceIndex++){
            
            CDGameBoardSpriteNode* horPiece = horCombo[horPieceIndex];
        
            if([_SuperCookies containsObject:horPiece]){
                if(![preExistingPowerups containsObject:horPiece]){
                    [preExistingPowerups addObject:horPiece];
                    
                    _was_a_powerup_triggered = YES;
                    
                    [_SuperCookies removeObject:horPiece];
                    [self Super_Horizontal:(CDCookieSpriteNode*)horPiece];
                }
            }else if([_WrappedCookies containsObject:horPiece]){
                if(![preExistingPowerups containsObject:horPiece]){
                    [preExistingPowerups addObject:horPiece];
                    
                    _was_a_powerup_triggered = YES;
                    
                    [_WrappedCookies removeObject:horPiece];
                    [self SingleWrapper:(CDCookieSpriteNode*)horPiece];

                }
            }

        }
    }
    
    // 6. wrap intersecting pieces
    for (int i = 0; i<intersectingPieces.count; i++) {
        CDGameBoardSpriteNode* piece = intersectingPieces[i];
        if (![preExistingPowerups containsObject:piece]) {
            
            [self Wrap_that_cookie:(CDCookieSpriteNode*)piece];
            [self Area_Effect:piece Multiplier:piece.scoreMultiplier];
            [self Add_to_Score:120 Piece:piece];
            [preExistingPowerups addObject:piece];
        }
    }

    // 7. look for power up making combos
    for (int vertComboIndex=0; vertComboIndex < verticalCombos.count; vertComboIndex++) {
        NSMutableArray* vertCombo = verticalCombos[vertComboIndex];
        
        CDGameBoardSpriteNode* OpenPiece = nil;
        
        int index = arc4random() % vertCombo.count;
        for (int i=0; i < vertCombo.count; i++) {
            
            int vertIndex = index + i;
            if(vertIndex >= vertCombo.count)
                vertIndex -= vertCombo.count;
            
            CDGameBoardSpriteNode* checkPiece = vertCombo[vertIndex];
            
            if(![preExistingPowerups containsObject:checkPiece]){
                OpenPiece = checkPiece;
                break;
            }
        }
        if(OpenPiece != nil){
            if(vertCombo.count >= 5) // smore
            {
                [self Smore_that_cookie:(CDCookieSpriteNode*)OpenPiece];
                [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                [self Add_to_Score:200 Piece:OpenPiece];
                [preExistingPowerups addObject:OpenPiece];
                
            }else if(vertCombo.count == 4)// super
            {
                [self SuperSizeThatCookie:(CDCookieSpriteNode*)OpenPiece];
                [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                [self Add_to_Score:60 Piece:OpenPiece];
                [preExistingPowerups addObject:OpenPiece];
            }
        }
    }
    
    for (int horComboIndex=0; horComboIndex < horizontalCombos.count; horComboIndex++) {
        NSMutableArray* horCombo = horizontalCombos[horComboIndex];
        
        CDGameBoardSpriteNode* OpenPiece = nil;
        
        int index = arc4random() % horCombo.count;
        for (int i=0; i < horCombo.count; i++) {
            
            int vertIndex = index + i;
            if(vertIndex >= horCombo.count)
                vertIndex -= horCombo.count;
            
            CDGameBoardSpriteNode* checkPiece = horCombo[vertIndex];
            
            if(![preExistingPowerups containsObject:checkPiece]){
                OpenPiece = checkPiece;
                break;
            }
        }
        if(OpenPiece != nil){
            if(horCombo.count >= 5) // smore
            {
                [self Smore_that_cookie:(CDCookieSpriteNode*)OpenPiece];
                [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                [self Add_to_Score:200 Piece:OpenPiece];
                [preExistingPowerups addObject:OpenPiece];
                
            }else if(horCombo.count == 4)// super
            {
                [self SuperSizeThatCookie:(CDCookieSpriteNode*)OpenPiece];
                [self Area_Effect:OpenPiece Multiplier:OpenPiece.scoreMultiplier];
                [self Add_to_Score:60 Piece:OpenPiece];
                [preExistingPowerups addObject:OpenPiece];
            }
        }

    }
    
    // 8. remove pre power ups from death row
    [_allCombos removeObjectsInArray:preExistingPowerups];
    
    // 9. milk slpat the combos
    // play deaths anims
    for (int i=0; i<verticalCombos.count; i++) {
        NSMutableArray* combo = verticalCombos[i];
        for (int k=0; k<combo.count; k++) {
            
            CDGameBoardSpriteNode* victim = combo[k];
            
            if(![preExistingPowerups containsObject:victim]){
                
                victim.shouldMilkSplash = NO;
                
                float iFloat = k;
                float countFloat = combo.count;
                
                float waitTime = (iFloat/countFloat) * 0.5f;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                            [SKAction runBlock:^{
                    
                    [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
                    
                }],[SKAction runBlock:^{
                    
                    [self Put_a_milk_splash:victim.position Size:victim.size];
                    
                    // hurt plates
                    [self Area_Effect:victim Multiplier:victim.scoreMultiplier];
                    
                    [self Add_to_Score:(_score_Per_cookie * victim.scoreMultiplier) Piece:victim];
                    
                }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                
                [victim runAction:piecedeath];
            }
        }
    }
    for (int i=0; i<horizontalCombos.count; i++) {
        NSMutableArray* combo = horizontalCombos[i];
        for (int k=0; k<combo.count; k++) {
            
            CDGameBoardSpriteNode* victim = combo[k];
            
            if(![preExistingPowerups containsObject:victim]){
                
                victim.shouldMilkSplash = NO;
                
                float iFloat = k;
                float countFloat = combo.count;
                
                float waitTime = (iFloat/countFloat) * 0.5f;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                            [SKAction runBlock:^{
                    
                    [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
                    
                }],[SKAction runBlock:^{
                    
                    [self Put_a_milk_splash:victim.position Size:victim.size];
                    
                    // hurt plates
                    [self Area_Effect:victim Multiplier:victim.scoreMultiplier];
                    
                    [self Add_to_Score:(_score_Per_cookie * victim.scoreMultiplier) Piece:victim];
                    
                }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                
                [victim runAction:piecedeath];
            }
        }
    }
    
    if(did_make_a_combo){ // This happens on a cascade.
        
        if (!_was_a_powerup_triggered){
            
            [_gameBoard runAction:[SKAction waitForDuration:0.5] completion:^{
                
                [self Kill_Everyone_that_deserves_it];
            }];
            
        }
        
    }
    else{
        
        [_cookieDoughLord MyTurn];
        
        if([self Check_For_No_Possible_Combos]){ // YES there are / NO there aren't
        
            [self Give_Control_Back_to_User];
        }
        else{
            [self Spatula];
        }
        
    }
    
}

-(BOOL)Check_for_bottom_row_ingredients
{
    
    BOOL returnBool = NO;
    NSMutableArray* list = [NSMutableArray new];
    
    //SKAction* drop_animation = [SKAction moveToY:-(_RowHeight*_numRows) duration:0.5];
    
    for(int i=0; i<_numColumns;i++){
        
        CDGameBoardSpriteNode* checkpiece = [_theGameGrid objectAtIndex:i];
        
        if([checkpiece isKindOfClass:[CDIngredientSpriteNode class]]){
            
            [self Add_to_Score:_score_Per_ingredient Piece:checkpiece];
            
            [list addObject:checkpiece];
            
            float animationDuration = 0.6f;
            SKAction *dropAction = [SKAction moveToY:-_RowHeight * 4 duration:animationDuration];
            SKAction *dropScaleAction = [SKAction scaleTo:0.66f duration:animationDuration];
            SKAction *fadeAction = [SKAction fadeAlphaTo:0.0f duration:animationDuration];
            SKAction *drop_animation = [SKAction group:@[dropAction, dropScaleAction, fadeAction]];
            [checkpiece runAction:drop_animation];
            
            SKEmitterNode *motionBlur = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"MotionBlur"];
            [motionBlur setParticleTexture:checkpiece.texture];
            [motionBlur setParticleScale:0.29f];
            [motionBlur setParticleColorBlendFactor:0.0];
            [motionBlur setTargetNode:_gameBoard];
            [checkpiece addChild:motionBlur];
            
            SKEmitterNode *sparkles01 = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"RisingSparkles01"];
            sparkles01.targetNode = _gameBoard;
            [checkpiece addChild:sparkles01];
            
            SKEmitterNode *sparkles02 = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"RisingSparkles02"];
            sparkles02.targetNode = _gameBoard;
            [checkpiece addChild:sparkles02];
            
            returnBool = YES;
            
        }
    }
    
    if(list.count > 0){
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"IngredientDrop" FileType:@"caf"]; //@"m4a"];
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        _numActivePowerUps++;
        
        [self.gameBoard runAction:[SKAction waitForDuration:0.6f] completion:^{
            
            _numActivePowerUps--;
            
            if(_numActivePowerUps <= 0)
            {
                _numActivePowerUps = 0;
                
                [self Powerup_deletion];
            }
            
        }];
        
    }
    
    return returnBool;
}

-(BOOL)Check_For_No_Possible_Combos
{
    [self SetTheGameGrid];
    
    BOOL returnBool = NO;
    
    for (int i=0; i<_theGameGrid.count; i++) {
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        if(piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM && piece.typeID != BLOCKER_ICECREAM)
            if([piece isKindOfClass:[CDCookieSpriteNode class]] || [piece isKindOfClass:[CDIngredientSpriteNode class]] || piece.typeID == BLOCKER_PRETZEL)
                if([self IsThereAPossibleCombo_Here:piece])
                {
                    returnBool = YES;
                    break;
                }
    }
    
    return returnBool;
}
-(BOOL)IsThereAPossibleCombo_Here:(CDGameBoardSpriteNode*)piece{
    
    if(piece.isLocked)
        return NO;
    
    if(piece.typeID == POWERUP_SMORE  || piece.typeID == BOOSTER_RADSPRINKLE){
     
        _possible_combo = nil;
        return YES;
    }
    
    int numberOf_Reds = 0;
    int numberOf_Blues = 0;
    int numberOf_Greens = 0;
    int numberOf_Oranges = 0;
    int numberOf_Purples = 0;
    int numberOf_Yellows = 0;
    int numberOf_Browns = 0;
    
    
    // look up, down, left, right
    CDGameBoardSpriteNode* upPiece = [[CDGameBoardSpriteNode alloc] init];
    CDGameBoardSpriteNode* downPiece = [[CDGameBoardSpriteNode alloc] init];
    CDGameBoardSpriteNode* leftPiece = [[CDGameBoardSpriteNode alloc] init];
    CDGameBoardSpriteNode* rightPiece = [[CDGameBoardSpriteNode alloc] init];
    
    if(piece.row < _numRows-1)
        upPiece = _theGameGrid[((piece.row+1) * _numColumns) + piece.column];
    if(piece.row > 0)
        downPiece = _theGameGrid[((piece.row-1) * _numColumns) + piece.column];
    if(piece.column > 0)
        leftPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column-1)];
    if(piece.column < _numColumns-1)
        rightPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column+1)];
    
    // check their types
    
    if(upPiece){
        int type = upPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
    }
    
    if(downPiece){
        int type = downPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
        
    }
    if(leftPiece){
        int type = leftPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
        
    }
    if(rightPiece){
        int type = rightPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
    }
    
    // check the numbers
    NSMutableArray* types_to_check_for = [NSMutableArray new];
    
    if(numberOf_Blues >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_BLUE]];
    }
    if(numberOf_Browns >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_CHIP]];
    }
    if(numberOf_Greens >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_GREEN]];
    }
    if(numberOf_Oranges >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_ORANGE]];
    }
    if(numberOf_Purples >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_PURPLE]];
    }
    if(numberOf_Reds >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_RED]];
    }
    if(numberOf_Yellows >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_YELLOW]];
    }
    
    // check for possible combos
    
    if(types_to_check_for.count > 0)
        for (int i=0; i<types_to_check_for.count; i++) {
            
            int type = [types_to_check_for[i] intValue];
            NSMutableArray* pieces_up = [NSMutableArray new];
            NSMutableArray* pieces_down = [NSMutableArray new];
            NSMutableArray* pieces_left = [NSMutableArray new];
            NSMutableArray* pieces_right = [NSMutableArray new];
            
            if(upPiece){
                
                int checkType = upPiece.typeID;
                if(checkType == type){
                    
                    [pieces_up addObject:upPiece];
                    
                    
                    for(int row = upPiece.row+1; row<_numRows; row++)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(row * _numColumns) + piece.column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_up addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
            if(downPiece){
                
                int checkType = downPiece.typeID;
                if(checkType == type){
                    
                    [pieces_down addObject:downPiece];
                    
                    for(int row = downPiece.row-1; row >= 0; row--)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(row * _numColumns) + piece.column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_down addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
           
            if(leftPiece){
                
                int checkType = leftPiece.typeID;
                if(checkType == type){
                    
                    [pieces_left addObject:leftPiece];
                    
                    for(int column = leftPiece.column-1; column >= 0; column--)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(piece.row * _numColumns) + column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_left addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
            
            if(rightPiece){
                
                int checkType = rightPiece.typeID;
                if(checkType == type){
                    
                    [pieces_right addObject:rightPiece];
                    
                    for(int column = rightPiece.column+1; column < _numColumns; column++)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(piece.row * _numColumns) + column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_right addObject:nextPiece];
                        else
                            break;
                    }

                }
            }
            
            // check how many was found
            
            
            /*
             order
             
             up right down
             up right left
             up down left
             right down left
             
             */
            
            if(pieces_up.count > 0 && pieces_right.count > 0 && pieces_down.count > 0)  // up right down
                if(!rightPiece.isLocked){
                    if (upPiece && rightPiece && downPiece)
                    {
                        _possible_combo = @[upPiece, rightPiece, downPiece];
                    }
                    return YES;
                }
            if(pieces_up.count > 0 && pieces_right.count > 0 && pieces_left.count > 0)  // up right left
                if(!upPiece.isLocked){
                    if (upPiece && rightPiece && leftPiece)
                    {
                        _possible_combo = @[upPiece, rightPiece, leftPiece];
                    }
                    return YES;
                }
            if(pieces_up.count > 0 && pieces_down.count > 0 && pieces_left.count > 0)  // up down left
                if(!leftPiece.isLocked){
                    if (upPiece && leftPiece && downPiece)
                    {
                        _possible_combo = @[upPiece, leftPiece, downPiece];
                    }
                    return YES;
                }
            if(pieces_right.count > 0 && pieces_down.count > 0 && pieces_left.count > 0)  // right down left
                if(!downPiece.isLocked){
                    if (leftPiece && rightPiece && downPiece)
                    {
                        _possible_combo = @[leftPiece, rightPiece, downPiece];
                    }
                    return YES;
                }
            
            
            /* order
            
             up down
             up right
             up left
             
             right left
             right down
             
             down left
             
             */
            
            if(pieces_up.count + pieces_down.count >= 3){  // up down
                
                if(upPiece.isLocked && downPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_down.count > 1){
                    if (upPiece)
                    {
                        [pieces_down addObject:upPiece];
                        _possible_combo = pieces_down;
                    }
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_up.count > 1){
                    if (downPiece)
                    {
                        [pieces_up addObject:downPiece];
                        _possible_combo = pieces_up;
                    }
                    return YES;
                }
            }
            
            if(pieces_up.count + pieces_right.count >= 3){  // up right
                
                if(upPiece.isLocked && rightPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_right.count > 1){
                    if (upPiece)
                    {
                        [pieces_right addObject:upPiece];
                    }
                    _possible_combo = pieces_right;
                    return YES;
                    
                }else if(!rightPiece.isLocked && pieces_up.count > 1){
                    if (rightPiece)
                    {
                        [pieces_up addObject:rightPiece];
                        _possible_combo = pieces_up;
                    }
                    return YES;
                }
            }
            
            if(pieces_up.count + pieces_left.count >= 3){  // up left
                
                if(upPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_left.count > 1){
                    if (upPiece)
                    {
                        [pieces_left addObject:upPiece];
                        _possible_combo = pieces_left;
                    }
                    return YES;
                    
                }else if(!leftPiece.isLocked && pieces_up.count > 1){
                    if (leftPiece)
                    {
                        [pieces_up addObject:leftPiece];
                        _possible_combo = pieces_up;
                    }
                    return YES;
                }
            }

            if(pieces_right.count + pieces_left.count >= 3){  // right left
                
                if(rightPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!rightPiece.isLocked && pieces_left.count > 1){
                    if (rightPiece)
                    {
                        [pieces_left addObject:rightPiece];
                        _possible_combo = pieces_left;
                    }
                    return YES;
                    
                }else if(!leftPiece.isLocked && pieces_right.count > 1){
                    if (leftPiece)
                    {
                        [pieces_right addObject:leftPiece];
                        _possible_combo = pieces_right;
                    }
                    return YES;
                }
            }

            if(pieces_right.count + pieces_down.count >= 3){  // right down
                
                if(rightPiece.isLocked && downPiece.isLocked){
                    
                }else if(!rightPiece.isLocked && pieces_down.count > 1){
                    if (rightPiece)
                    {
                        [pieces_down addObject:rightPiece];
                        _possible_combo = pieces_down;
                    }
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_right.count > 1){
                    if (downPiece)
                    {
                        [pieces_right addObject:downPiece];
                        _possible_combo = pieces_right;
                    }
                    return YES;
                }
            }
            
            
            if(pieces_down.count + pieces_left.count >= 3){  // down left
                
                if(downPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!leftPiece.isLocked && pieces_down.count > 1){
                    if (leftPiece)
                    {
                        [pieces_down addObject:leftPiece];
                        _possible_combo = pieces_down;
                    }
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_left.count > 1){
                    if (downPiece)
                    {
                        [pieces_left addObject:downPiece];
                        _possible_combo = pieces_left;
                    }
                    return YES;
                }
            }
        }
    
    return NO;
}


#pragma mark - Piece Removal

-(void)Piece_Death:(CDGameBoardSpriteNode*)piece
{
    // this should be called on the top pieces first then the lower ones
    
    if(piece.isHidden) // it checks if the piece is alive
        return;
    
    // also clear blocks cannot die
    if(piece.typeID == CLEAR_BLOCK)
        return;
    
    
    if(piece.typeID == EMPTY_ITEM){
        return;
    }
    
    // it's alive, so kill it
    
    if(piece.typeID == BLOCKER_COOKIEDOUGH)
        _cookieDoughLord.isHurt = YES;
    
    if(piece.isLocked){
        [self LockBreak:piece];
    }

    
    // if Clear type
    if(_mainGoalType == GoalTypes_TYPECLEAR || _mainGoalType == GoalTypes_INGREDIENT)
        for(int i=0;i<_mainGoalItems.count; i+=2){
            
            int value = [_mainGoalItems[i] intValue];
            int how_many_left = [_mainGoalItems[i+1] intValue];
            
            if(value == (int) piece.typeID){
                
                if(how_many_left > 0){
                    _mainGoalItems[i+1] = [NSNumber numberWithInt:how_many_left-1];
                    
                }
                
            }
            
        }

    if(_secondGoalType == GoalTypes_TYPECLEAR || _secondGoalType == GoalTypes_INGREDIENT)
        for(int i=0;i<_secondGoalItems.count; i+=2){
            
            int value = [_secondGoalItems[i] intValue];
            int how_many_left = [_secondGoalItems[i+1] intValue];
            
            if(value == (int) piece.typeID){
                
                if(how_many_left > 0){
                    _secondGoalItems[i+1] = [NSNumber numberWithInt:how_many_left-1];
                    
                }
                
            }
            
        }

    // just in case
    [_SuperCookies removeObject:piece];
    [_WrappedCookies removeObject:piece];
    [_allBombs removeObject:piece];
    [piece removeAllActions];
    [piece removeAllChildren];
    
    piece.typeID = COOKIE_RANDOM;
    
    piece.zPosition = 2;
    piece.zRotation = 0;
    piece.xScale = 1;
    piece.yScale = 1;
    piece.alpha = 1;
    piece.isVulnerable = YES;
    piece.shouldMilkSplash = YES;
    piece.isLocked = NO;
    piece.size = CGSizeMake(_cookieWidth, _cookieHeight);
    
    [_theVisiblePieces removeObject:piece]; // remove from visible array
    piece.position = CGPointMake(0, 0);
    piece.hidden = YES;
    
    piece = [self Randomize_this_piece:piece]; // this will change or possibly replace the piece

    if([_SuperCookies containsObject:piece])
        [[CDCookieAnimationManager animationManager] SuperSizing:piece];
    
    [_theReservePieces addObject:piece]; // add it to the end of the reserve
    
}
 
-(void)DropNewPiece:(CDGameBoardSpriteNode*)piece Speed:(float)speed
{
    if(_theReservePieces.count <= 0)
        return;
    
    CDGameBoardSpriteNode* newPiece = [_theReservePieces objectAtIndex:0];
    [_theReservePieces removeObjectAtIndex:0];
    [_theVisiblePieces addObject:newPiece];
    
    if([newPiece isMemberOfClass:[CDBombSpriteNode class]])
       [_allBombs addObject:newPiece];
    
    
    newPiece.steps = [NSMutableArray new];
    
    int newRowPlace = _numRows-1;
    
    // look through clearBlocks
    for(int i=newRowPlace; i>=0; i--){
        CDGameBoardSpriteNode* spot = _theGameGrid[(i * _numColumns)+ piece.column];
        
        if(spot.typeID == CLEAR_BLOCK){
            newRowPlace--;
            [newPiece.steps addObject:[SKAction moveByX:0 y:-_RowHeight duration:speed]];
        }else{
            break;
        }
    }
    
    newPiece.row = newRowPlace;
    newPiece.column = piece.column;
    
    newPiece.position = CGPointMake((newPiece.column * _columnWidth) + _columnWidth, _scene.size.height + (newPiece.row * _RowHeight));
    newPiece.hidden = NO;
    
    [newPiece removeAllActions];
    
    [newPiece runAction:[SKAction scaleTo:1.0f duration:0]];
    
    _theGameGrid[(newPiece.row * _numColumns)+ newPiece.column] = newPiece;
    
    [_inserted_reserve_pieces addObject:newPiece];
    
}

-(void)SandFill_Piece:(CDGameBoardSpriteNode*)piece Column:(int)column Row:(int)row Steps:(NSMutableArray*)steps Speed:(float)speed
{
    
    if(row <= 0){
        
        // claim this spot
        CDGameBoardSpriteNode* spot = _theGameGrid[(row * _numColumns)+column];
        
        int pieceRow = piece.row;
        int spotPieceRow = spot.row;
        
        int pieceColumn = piece.column;
        int spotPieceColumn = spot.column;
        
        piece.column = spotPieceColumn;
        piece.row = spotPieceRow;
        
        spot.column = pieceColumn;
        spot.row = pieceRow;
        
        int pieceIndex = (pieceRow * _numColumns) + pieceColumn;
        int emptyIndex = (spotPieceRow * _numColumns) + spotPieceColumn;
        
        _theGameGrid[emptyIndex] = piece;
        _theGameGrid[pieceIndex] = spot;
        
        [steps addObject:[SKAction moveTo:CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight) duration:0]];
        return;
    }
    
    CDGameBoardSpriteNode* belowPiece = nil;
    CDGameBoardSpriteNode* leftBelowPiece = nil;
    CDGameBoardSpriteNode* rightBelowPiece = nil;
    
    belowPiece = _theGameGrid[((row-1) * _numColumns)+column];
    
    if(column > 0)
        leftBelowPiece = _theGameGrid[((row-1) * _numColumns)+(column - 1)];
    
    if(column < _numColumns-1)
        rightBelowPiece = _theGameGrid[((row-1) * _numColumns)+(column + 1)];
    
    
    
    if(belowPiece.typeID == EMPTY_ITEM){ // going down
        
        [steps addObject:[SKAction moveTo:CGPointMake(_columnWidth +(_columnWidth * column) ,_RowHeight + (_RowHeight * (row-1)))  duration:speed]];
        [self SandFill_Piece:piece Column:column Row:row-1 Steps:steps Speed:speed];
        
        
    }else if (leftBelowPiece != nil && leftBelowPiece.typeID == EMPTY_ITEM){ // left down
        
        [steps addObject:[SKAction moveTo:CGPointMake(_columnWidth +(_columnWidth * (column-1)) ,_RowHeight + (_RowHeight * (row-1)))  duration:speed]];        [self SandFill_Piece:piece Column:column-1 Row:row-1 Steps:steps Speed:speed];
        
        
    }else if (rightBelowPiece != nil && rightBelowPiece.typeID == EMPTY_ITEM){ // right down
        
        [steps addObject:[SKAction moveTo:CGPointMake(_columnWidth +(_columnWidth * (column+1)) ,_RowHeight + (_RowHeight * (row-1)))  duration:speed]];
        [self SandFill_Piece:piece Column:column+1 Row:row-1 Steps:steps Speed:speed];
        
    }else{
        
        // claim this spot
        CDGameBoardSpriteNode* spot = _theGameGrid[(row * _numColumns)+column];
        
        int pieceRow = piece.row;
        int spotPieceRow = spot.row;
        
        int pieceColumn = piece.column;
        int spotPieceColumn = spot.column;
        
        piece.column = spotPieceColumn;
        piece.row = spotPieceRow;
        
        spot.column = pieceColumn;
        spot.row = pieceRow;
        
        int pieceIndex = (pieceRow * _numColumns) + pieceColumn;
        int emptyIndex = (spotPieceRow * _numColumns) + spotPieceColumn;
        
        _theGameGrid[emptyIndex] = piece;
        _theGameGrid[pieceIndex] = spot;
        
        [steps addObject:[SKAction moveTo:CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight) duration:0]];
    }
    
}

-(void)SetTheSpawnPot
{
    _spawnablePot = 0;
    
    for (int i=2; i<_spawnablePieces.count; i+=2) {
        
        int previousChance = [_spawnablePieces[i-1] intValue];
        int currentChance = [_spawnablePieces[i+1] intValue];
        
        _spawnablePieces[i+1] = [NSNumber numberWithInt:previousChance + currentChance];
        
    }
    
    _spawnablePot = [_spawnablePieces[_spawnablePieces.count-1] intValue];

}

-(CDGameBoardSpriteNode*)Randomize_this_piece:(CDGameBoardSpriteNode*)piece{
    
    // this will change or possibly replace the given piece
    // the piece should be removed from every array it is in, except its parent
    // and you should use what this method returns
    
    CDGameBoardSpriteNode* newPiece = piece;
    
    int newType = 0;
    int lastGuysType = 0;
    
    
    int loopCounter = 0;
    do {
        
        newType = arc4random() % _spawnablePot;
    
        for (int i=0; i<_spawnablePieces.count; i+=2) {
            
            int currentChance = [_spawnablePieces[i+1] intValue];
            
            if(newType <= currentChance){
                
                newType = [_spawnablePieces[i] intValue];
                break;
            }
            
        }
        
        if(_theReservePieces.count > 1){
            CDGameBoardSpriteNode* lastGuy = _theReservePieces[_theReservePieces.count-1];
            lastGuysType = lastGuy.typeID;
        }
        
        loopCounter++;
        if(loopCounter > 10){
            break;
        }
        
    }while (newType == lastGuysType);

    // make it so
    switch (newType) {
        case COOKIE_RANDOM:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RANDOM];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                [self Randomize_this_Cookie:(CDCookieSpriteNode*)newPiece];
                
            }
            
            break;
            
        case COOKIE_RED:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RED];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_RED;
                newPiece.texture = [self NeedCookieTexture:COOKIE_RED];
                
            }
            
            break;
            
            
        case COOKIE_ORANGE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_ORANGE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_ORANGE;
                newPiece.texture = [self NeedCookieTexture:COOKIE_ORANGE];
                
            }
            
            break;
            
        case COOKIE_YELLOW:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_YELLOW];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_YELLOW;
                newPiece.texture = [self NeedCookieTexture:COOKIE_YELLOW];
                
            }
            
            break;
            
        case COOKIE_GREEN:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_GREEN];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_GREEN;
                newPiece.texture = [self NeedCookieTexture:COOKIE_GREEN];
                
                
            }
            
            break;
            
        case COOKIE_BLUE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_BLUE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_BLUE;
                newPiece.texture = [self NeedCookieTexture:COOKIE_BLUE];
                
            }
            
            break;
            
        case COOKIE_PURPLE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_PURPLE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_PURPLE;
                newPiece.texture = [self NeedCookieTexture:COOKIE_PURPLE];
                
            }
            
            break;
            
        case COOKIE_CHIP:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_CHIP];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                newPiece.typeID = COOKIE_CHIP;
                newPiece.texture = [self NeedCookieTexture:COOKIE_CHIP];
            }
            
            break;
            
        case POWERUP_SMORE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [CDCookieSpriteNode new];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            [self Smore_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_BLUE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_BLUE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
            }
            
            newPiece.typeID = COOKIE_BLUE;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_CHIP:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_CHIP];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_CHIP;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_GREEN:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_GREEN];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_GREEN;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_ORANGE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_ORANGE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_ORANGE;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_PURPLE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_PURPLE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_PURPLE;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_RED:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RED];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_RED;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_YELLOW:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_YELLOW];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_YELLOW;
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_SUPER_RANDOM: // this is random
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RANDOM];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                [self Randomize_this_Cookie:(CDCookieSpriteNode*)newPiece];
            }
            
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_RANDOM: // this is random
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RANDOM];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }else{
                
                [self Randomize_this_Cookie:(CDCookieSpriteNode*)newPiece];
            }
            
            [self SuperSizeThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_BLUE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_BLUE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_BLUE;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_CHIP:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_CHIP];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_CHIP;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_GREEN:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_GREEN];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_GREEN;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_ORANGE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_ORANGE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_ORANGE;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_PURPLE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_PURPLE];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_PURPLE;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_RED:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_RED];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_RED;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case POWERUP_WRAPPED_YELLOW:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_YELLOW];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            newPiece.typeID = COOKIE_YELLOW;
            [self Wrap_that_cookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case INGREDIENT_RANDOM:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_RANDOM];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case INGREDIENT_SUGAR:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_SUGAR];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case INGREDIENT_FLOUR:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_FLOUR];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case INGREDIENT_EGG:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_EGG];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case INGREDIENT_CHIPS:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_CHIPS];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case INGREDIENT_BANANA:
            
            newPiece = [self NewIngredientWithType:INGREDIENT_BANANA];
            [piece removeFromParent];
            [_gameBoard addChild:newPiece];
            
            break;
            
        case BOOSTER_RADSPRINKLE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_CHIP];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            [self RadiateThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case BOOSTER_SLOTMACHINE:
            
            if (![piece isMemberOfClass:[CDCookieSpriteNode class]]) { // replace It, for it is not a cookie
                
                CDCookieSpriteNode* newCookie = [self NewCookieWithType:COOKIE_CHIP];
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            
            [self SlotThatCookie:(CDCookieSpriteNode*)newPiece];
            
            break;
            
        case BLOCKER_PRETZEL:{
                
                CDPretzelSpriteNode* newCookie = [CDPretzelSpriteNode spriteNodeWithTexture:_pretzelTextures[0]];
                newCookie.typeID = BLOCKER_PRETZEL;
                newCookie.isVulnerable = NO;
                newCookie.shouldMilkSplash = YES;
                newPiece = newCookie;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
            }
            break;

        case BOMB:{
                
//                int health = 5;
            
                CDBombSpriteNode* newBomb = [self New_Bomb_with_health:0 Type:@"RANDOM"];
                newPiece = newBomb;
                [piece removeFromParent];
                [_gameBoard addChild:newPiece];
                
            }
            break;
            
        default:
            DebugLog(@" won't change it %i", newType);
            break;
    }
    
    newPiece.hidden = piece.hidden;
    newPiece.position = piece.position;
    newPiece.zPosition = piece.zPosition;
    
    if(![newPiece isMemberOfClass:[CDBombSpriteNode class]])
        newPiece.size = piece.size;
    
    newPiece.row = piece.row;
    newPiece.column = piece.column;
    newPiece.isLocked = NO;
    newPiece.scoreMultiplier = 1;
    
    return newPiece;
    
}

-(void)Area_Effect:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier{
    
    [self HurtPlates:piece Multiplier:multiplier];
    
    if(![piece isKindOfClass:[CDIcecreamSpriteNode class]])
        [self CheckAroundForIcream:piece.column Row:piece.row Multiplier:multiplier];
    
    if(piece.typeID != BLOCKER_COOKIEDOUGH)
        [self CheckAroundForCookiedough:piece.column Row:piece.row Multiplier:multiplier];
    
    if(piece.typeID != BLOCKER_PRETZEL)
        [self CheckAroundForPretzels:piece.column Row:piece.row Multiplier:multiplier];
    
}

-(void)CheckAroundForIcream:(int)column Row:(int)row Multiplier:(int)multiplier
{
    int index = (row * _numColumns) + column;
    
    // look up down left right
    
    CDGameBoardSpriteNode* checkPiece;
    
    // up
    if(row < _numRows-1 && row >= 0){
        checkPiece = [_theGameGrid objectAtIndex:index+_numColumns];
        if(checkPiece.typeID == BLOCKER_ICECREAM){
            
            [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:multiplier];
            
        }
    }
    // down
    if(row <= _numRows-1 && row > 0){
        checkPiece = [_theGameGrid objectAtIndex:index-_numColumns];
        if(checkPiece.typeID == BLOCKER_ICECREAM){
            
            [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:multiplier];
            
        }
    }
    // left
    if(column > 0 && column <= _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index-1];
        if(checkPiece.typeID == BLOCKER_ICECREAM){
            
            [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:multiplier];
            
        }    }
    // right
    if(column >= 0 && column < _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index+1];
        if(checkPiece.typeID == BLOCKER_ICECREAM){
            
            [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:multiplier];
            
        }
    }

}

-(void)HurtIcecream:(CDIcecreamSpriteNode*)piece Multiplier:(int)multiplier{
    
    if(piece.health <= 0)
        return;
    
    piece.health--;
    
    if(piece.health <= 0){
        
        [_allCombos addObject:piece];
        
        piece.alpha = 0;
        
        _numberOfIcreams--;
        
        [self Add_to_Score:_score_Per_icecream * multiplier Piece:piece];
        
    }else{
        
        piece.texture = _icreamTextures[piece.health];
    }
    
}

-(void)CheckAroundForCookiedough:(int)column Row:(int)row Multiplier:(int)multiplier
{
    int index = (row * _numColumns) + column;
    
    // look up down left right
    
    CDGameBoardSpriteNode* checkPiece;
    
    // up
    if(row < _numRows-1 && row >= 0){
        checkPiece = [_theGameGrid objectAtIndex:index+_numColumns];
        if(checkPiece.typeID == BLOCKER_COOKIEDOUGH){
            
            [self HurtCookiedough:checkPiece Multiplier:multiplier];
            
        }
    }
    // down
    if(row <= _numRows-1 && row > 0){
        checkPiece = [_theGameGrid objectAtIndex:index-_numColumns];
        if(checkPiece.typeID == BLOCKER_COOKIEDOUGH){
            
            [self HurtCookiedough:checkPiece Multiplier:multiplier];
        }
    }
    // left
    if(column > 0 && column <= _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index-1];
        if(checkPiece.typeID == BLOCKER_COOKIEDOUGH){
        
            [self HurtCookiedough:checkPiece Multiplier:multiplier];
        }
    }
    // right
    if(column >= 0 && column < _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index+1];
        if(checkPiece.typeID == BLOCKER_COOKIEDOUGH){
            
            [self HurtCookiedough:checkPiece Multiplier:multiplier];
        }
    }
    
}

-(void)HurtCookiedough:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier{
    
    if(!piece.shouldMilkSplash)
        return;
    
    piece.shouldMilkSplash = NO;
    
    _cookieDoughLord.isHurt = YES;
    
    [[SGGameManager gameManager] Put_a_milk_splash:piece.position Size:piece.size];
        
    [_allCombos addObject:piece];
    
    [_cookieDoughLord.myDoughyChildren removeObject:piece];
    
    piece.alpha = 0;
        
    
}

-(void)HurtPlates:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier{
    
    // hurt plates
    NSMutableArray* brokenPlates = [NSMutableArray new];
    
    for (int i=0; i<_allPlates.count; i++) {
        
        CDPlateSpriteNode* plate = [_allPlates objectAtIndex:i];
        
        if(piece.row == plate.row)
            if(piece.column == plate.column){
                plate.health--;
                
                if(plate.health <= 0){
                    [brokenPlates addObject:plate];
                    
                    //[plate runAction:plate.glassBreakSound];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassBreak" FileType:@"caf"];
                    
                    [plate removeFromParent];
                    
                    [self Add_to_Score:_score_Per_plate * multiplier Piece:plate];
                    
                    SKEmitterNode* glassshards = [_glassParticle copy];
                    glassshards.position = piece.position;
                    glassshards.zPosition = 2;
                    glassshards.numParticlesToEmit = 6;
                    glassshards.particleSpeed = _cookieWidth * 6;
                    glassshards.particleSpeedRange = _cookieWidth * 2;
                    
                    [_gameBoard addChild:glassshards];
                    
                    SKAction* deleteglassShards = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
                    [glassshards runAction:deleteglassShards];
                    
                    
                    // if Clear type
                    if(_mainGoalType == GoalTypes_TYPECLEAR)
                        if([_mainGoalItems[0] intValue] == 500){
                            
                            int how_many_left = [_mainGoalItems[1] intValue];
                            
                            if(how_many_left > 0){
                                _mainGoalItems[1] = [NSNumber numberWithInt:how_many_left-1];
                                
                            }
                            
                        }
                    
                    // if Clear type
                    if(_secondGoalType == GoalTypes_TYPECLEAR)
                        if([_secondGoalItems[0] intValue] == 500){
                            
                            int how_many_left = [_secondGoalItems[1] intValue];
                            
                            if(how_many_left > 0){
                                NSNumber *newCount = [NSNumber numberWithInt:how_many_left-1];
                                [_secondGoalItems replaceObjectAtIndex:1 withObject:newCount];
                            }
                        }
                    
                }
                else
                {
                    [self ChangePlateTexture:plate];
                    
                    if(plate.health == 1){
                        //                            AVAudioPlayer* glassCrack = _allPlatesCrackingSounds[plate.glassCrack_index];
                        //                            glassCrack.volume *= 0.75f;
                        //                            [glassCrack play];
                        
                        [plate runAction:plate.glassCrackSound];
                        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"GlassCracking02" FileType:@"caf"];
                        [self Add_to_Score:500 * multiplier Piece:plate];
                        
                    }
                }
            }
    }
    
    [_allPlates removeObjectsInArray:brokenPlates];
    
}

-(void)CheckAroundForPretzels:(int)column Row:(int)row Multiplier:(int)multiplier
{
    int index = (row * _numColumns) + column;
    
    // look up down left right
    
    CDGameBoardSpriteNode* checkPiece;
    
    // up
    if(row < _numRows-1 && row >= 0){
        checkPiece = [_theGameGrid objectAtIndex:index+_numColumns];
        if(checkPiece.typeID == BLOCKER_PRETZEL){
            
            [self HurtPretzel:checkPiece Multiplier:multiplier];
            
        }
    }
    // down
    if(row <= _numRows-1 && row > 0){
        checkPiece = [_theGameGrid objectAtIndex:index-_numColumns];
        if(checkPiece.typeID == BLOCKER_PRETZEL){
            
            [self HurtPretzel:checkPiece Multiplier:multiplier];
        }
    }
    // left
    if(column > 0 && column <= _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index-1];
        if(checkPiece.typeID == BLOCKER_PRETZEL){
            
            [self HurtPretzel:checkPiece Multiplier:multiplier];
        }
    }
    // right
    if(column >= 0 && column < _numColumns-1){
        checkPiece = [_theGameGrid objectAtIndex:index+1];
        if(checkPiece.typeID == BLOCKER_PRETZEL){
            
            [self HurtPretzel:checkPiece Multiplier:multiplier];
        }
    }
    
}

-(void)HurtPretzel:(CDGameBoardSpriteNode*)piece Multiplier:(int)multiplier{
    
    if(!piece.shouldMilkSplash)
        return;
    
    piece.shouldMilkSplash = NO;
    
    [_allCombos addObject:piece];
    
    SKSpriteNode* fakeSwirl = [piece copy];
    [_gameBoard addChild:fakeSwirl];
    
    piece.alpha = 0;
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_jellyworm" FileType:@"m4a"];
    
    [fakeSwirl runAction:[SKAction animateWithTextures:_pretzelTextures timePerFrame:0.06f] completion:^{
    
        [fakeSwirl removeFromParent];
    
    }];
    
}

#pragma mark - Cookie methods

-(CDCookieSpriteNode*)NewCookieWithType:(ItemType)type{
    
    CDCookieSpriteNode* newCookie = [[CDCookieSpriteNode new] initCookie];
    newCookie.isVulnerable = YES;
    newCookie.shouldMilkSplash = YES;
    newCookie.isLocked = NO;
    
    if(type == COOKIE_RANDOM){
        [self Randomize_this_Cookie:newCookie];
        
    }else
    {
        newCookie.typeID = type;
        newCookie.texture = [self NeedCookieTexture:type];
    }
    
    newCookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
    
    // new face
    /*
     CDCookieFaceSpriteNode* its_face = [CDCookieFaceSpriteNode new];
     [self Setup_this_FaceSprite_withFaces:its_face CookieType:newCookie.typeID];
     
     its_face.size = newCookie.size;
     [newCookie addChild:its_face];
     newCookie.faceSprite = its_face;
     */
    
    return newCookie;
}

-(SKTexture*)NeedCookieTexture:(ItemType)type{
    
    SKTexture* returnTexture;
    
    int cookieTypeID = type;
    
    switch (cookieTypeID)
    {
        case COOKIE_RED:
            returnTexture = [self.cookieTextures objectAtIndex:0];
            break;
        case COOKIE_ORANGE:
            returnTexture = [self.cookieTextures objectAtIndex:1];
            break;
        case COOKIE_YELLOW:
            returnTexture = [self.cookieTextures objectAtIndex:2];
            break;
        case COOKIE_GREEN:
            returnTexture = [self.cookieTextures objectAtIndex:3];
            break;
        case COOKIE_BLUE:
            returnTexture = [self.cookieTextures objectAtIndex:4];
            break;
        case COOKIE_PURPLE:
            returnTexture = [self.cookieTextures objectAtIndex:5];
            break;
        case COOKIE_CHIP:
            returnTexture = [self.cookieTextures objectAtIndex:6];
            break;
            
        default: returnTexture = [self.cookieTextures objectAtIndex:6];
            break;
            
    }
    
    
    return returnTexture;
    
}


-(void)Randomize_this_Cookie:(CDCookieSpriteNode*)cookie
{
    cookie.isVulnerable = YES;
    
    ItemType type;
    int newType = arc4random() % _spawnableCookies.count;
    
    newType = [_spawnableCookies[newType] intValue];
    
    switch (newType)
    {
        case COOKIE_RED:
            type = COOKIE_RED;
            break;
        case COOKIE_ORANGE:
            type = COOKIE_ORANGE;
            break;
        case COOKIE_YELLOW:
            type = COOKIE_YELLOW;
            break;
        case COOKIE_GREEN:
            type = COOKIE_GREEN;
            break;
        case COOKIE_BLUE:
            type = COOKIE_BLUE;
            break;
        case COOKIE_PURPLE:
            type = COOKIE_PURPLE;
            break;
        case COOKIE_CHIP:
            type = COOKIE_CHIP;
            break;
            
            
        default: type = COOKIE_CHIP;
            break;
    }
    
    cookie.typeID = type;
    cookie.texture = [self NeedCookieTexture:type];
    
}

#pragma mark - Ingredient methods

-(CDIngredientSpriteNode*)NewIngredientWithType:(ItemType)type
{
    if(type == INGREDIENT_RANDOM){
        
        int newType = arc4random() % 2;
        newType++;
        
        switch (newType) {
        /*    case 0:
                type = INGREDIENT_BANANA;
                break;
         */   case 1:
                type = INGREDIENT_CHIPS;
                break;
            case 2:
                type = INGREDIENT_EGG;
                break;
        /*    case 3:
                type = INGREDIENT_FLOUR;
                break;
            case 4:
                type = INGREDIENT_SUGAR;
                break;
          */
            default: type = INGREDIENT_CHIPS;
                break;
        }
    }
    
    SKTexture* texture = [self NeedIngredientTexture:type];
    
    CDIngredientSpriteNode *ingredient = [CDIngredientSpriteNode spriteNodeWithTexture:texture size:CGSizeMake(_cookieWidth, _cookieHeight)];
    ingredient.typeID = type;
    
    ingredient.isVulnerable = NO;
    ingredient.isLocked = NO;
    
    return ingredient;
    
}

-(SKTexture*)NeedIngredientTexture:(ItemType)type
{
    SKTexture* texture;
    
    int newtype = type;
    
    switch (newtype) {
        case INGREDIENT_EGG:
            texture = [_ingredientTextures objectAtIndex:0];
            break;
  /*      case INGREDIENT_BANANA:
            texture = [_ingredientTextures objectAtIndex:1];
            break;
   */
        case INGREDIENT_CHIPS:
            texture = [_ingredientTextures objectAtIndex:2];
            break;
 /*       case INGREDIENT_FLOUR:
            texture = [_ingredientTextures objectAtIndex:3];
            break;
        case INGREDIENT_SUGAR:
            texture = [_ingredientTextures objectAtIndex:4];
            break;
   */
        default:
            texture = [_ingredientTextures objectAtIndex:2];
            break;
    }
    
    return texture;
    
}

#pragma mark - Plate methods

-(CDPlateSpriteNode*)New_Plate_with_health:(int)health
{
    CDPlateSpriteNode* newPlate;
    
    if(health > 1){
        
        health = 2;
        
        newPlate = [CDPlateSpriteNode spriteNodeWithTexture:[_plateTextures objectAtIndex:2] size:CGSizeMake(_columnWidth, _columnWidth)];
        
   //     //newPlate.color = [UIColor colorWithRed:0 green:185 blue:223 alpha:1.0f]; // 255
   //     newPlate.color = [UIColor colorWithRed:0 green:1 blue:1 alpha:1]; // 255
        
   //     newPlate.colorBlendFactor = 1.0f;
    }else
    {
        
        newPlate = [CDPlateSpriteNode spriteNodeWithTexture:[_plateTextures objectAtIndex:1] size:CGSizeMake(_columnWidth, _columnWidth)];
        
    }
    
    newPlate.health = health;
    
    return newPlate;
}

-(void)ChangePlateTexture:(CDPlateSpriteNode*)plate
{
    
    plate.texture = [_plateTextures objectAtIndex:plate.health-1];
    
}

#pragma mark - BOMB spawn method

-(CDBombSpriteNode*)New_Bomb_with_health:(int)health Type:(NSString*)type
{
    
    ItemType bombType;
    
    if([type isEqualToString:@"RANDOM"]){
        
        int newType = arc4random() % _spawnableCookies.count;
        
        newType = [_spawnableCookies[newType] intValue];
        
        switch (newType)
        {
            case COOKIE_RED:
                bombType = COOKIE_RED;
                break;
            case COOKIE_ORANGE:
                bombType = COOKIE_ORANGE;
                break;
            case COOKIE_YELLOW:
                bombType = COOKIE_YELLOW;
                break;
            case COOKIE_GREEN:
                bombType = COOKIE_GREEN;
                break;
            case COOKIE_BLUE:
                bombType = COOKIE_BLUE;
                break;
            case COOKIE_PURPLE:
                bombType = COOKIE_PURPLE;
                break;
            case COOKIE_CHIP:
                bombType = COOKIE_CHIP;
                break;
                
            default: bombType = COOKIE_CHIP;
                break;
        }

    }else if([type isEqualToString:@"CHIP"]){
        bombType = COOKIE_CHIP;
    }else if([type isEqualToString:@"BLUE"]){
        bombType = COOKIE_BLUE;
    }else if([type isEqualToString:@"RED"]){
        bombType = COOKIE_RED;
    }else if([type isEqualToString:@"GREEN"]){
        bombType = COOKIE_GREEN;
    }else if([type isEqualToString:@"PURPLE"]){
        bombType = COOKIE_PURPLE;
    }else if([type isEqualToString:@"ORANGE"]){
        bombType = COOKIE_ORANGE;
    }else if([type isEqualToString:@"YELLOW"]){
        bombType = COOKIE_YELLOW;
    }else{
        bombType = COOKIE_CHIP;
    }
    
//    if(health > 5){
//        health = 5;
//    }
    
    if (health < 1) {
        // Choose a random value.
        health = arc4random_uniform(self.cherryBombMaxHealth - self.cherryBombMinHealth) + self.cherryBombMinHealth;
    }
    
    CDBombSpriteNode* newBomb = [CDBombSpriteNode spriteNodeWithTexture:_bombTexture
                                                                   size:CGSizeMake(_cookieWidth * 1.15f, _cookieWidth * 1.15f)];
    newBomb.anchorPoint = CGPointMake(0.4583f, 0.5f);
    newBomb.typeID = bombType;
    [self Bomb_Color_Change:newBomb];
    newBomb.colorBlendFactor = 1.0f;
    
    SKSpriteNode* shine = [SKSpriteNode spriteNodeWithTexture:_bombShineTexture size:newBomb.size];
    shine.anchorPoint = newBomb.anchorPoint;
    [newBomb addChild:shine];
    
    SKSpriteNode* wick = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:newBomb.size];
    wick.anchorPoint = newBomb.anchorPoint;
    [wick runAction:_bombSpark];
    [newBomb addChild:wick];

    SKLabelNode* countdown = [SKLabelNode labelNodeWithFontNamed:kFontDamnNoisyKids];
    countdown.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    countdown.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
    countdown.fontSize = _cookieWidth * 0.5f;
    [countdown setText:[NSString stringWithFormat:@"%i", health]];
    countdown.position = CGPointMake(0, -newBomb.size.height * 0.25f);
    
    newBomb.countdown = countdown;
    [newBomb addChild:countdown];
    
    newBomb.turnsLeft = health;
    newBomb.justDropped = YES;
    newBomb.zPosition = 2;
    newBomb.isLocked = NO;
    newBomb.isVulnerable = YES;
    newBomb.shouldMilkSplash = YES;
    
    return newBomb;
}

-(void)Bomb_Color_Change:(CDBombSpriteNode*)bomb
{
    
    SKColor* bombColor;
    
    int cookieTypeID = bomb.typeID;
    
    switch (cookieTypeID)
    {
        case COOKIE_RED:
            bombColor = [SKColor colorWithRed:0.9608f green:0.3294f blue:0.4431f alpha:1];
            break;
        case COOKIE_ORANGE:
            bombColor = [SKColor colorWithRed:0.9765f green:0.5451f blue:0.0588f alpha:1];
            break;
        case COOKIE_YELLOW:
            bombColor = [SKColor colorWithRed:1.0f green:0.8471f blue:0.0f alpha:1];
            break;
        case COOKIE_GREEN:
            bombColor = [SKColor colorWithRed:0.2392f green:0.8980f blue:0.1490f alpha:1];
            break;
        case COOKIE_BLUE:
            bombColor = [SKColor colorWithRed:0.1176f green:0.6353f blue:1.0f alpha:1];
            break;
        case COOKIE_PURPLE:
            bombColor = [SKColor colorWithRed:0.5843f green:0.1922f blue:0.6039f alpha:1];
            break;
        case COOKIE_CHIP:
            bombColor = [SKColor colorWithRed:0.7372f green:0.4823f blue:0.1843f alpha:1];
            break;
            
        default: bombColor = [SKColor colorWithRed:1 green:1 blue:1 alpha:1];
            break;
    }
    
    bomb.color = bombColor;
    bomb.texture = _bombTexture;
    
}

#pragma mark - Device orientation
-(void)To_Landscape
{
    CGSize boardSizeLimits = CGSizeMake(_scene.size.width * 0.75, _scene.size.height * 0.9);
    
    // make the board fit
    if(_numRows > _numColumns){
        
        _RowHeight = boardSizeLimits.height/_numRows;
        _columnWidth = _RowHeight;
        
        if((_columnWidth*_numColumns) >= boardSizeLimits.width){
            
            _columnWidth = boardSizeLimits.width/_numColumns;
            _RowHeight = _columnWidth;
        }
        
    }else{
        
        _columnWidth = boardSizeLimits.width/_numColumns;
        _RowHeight = _columnWidth;
        
        if((_RowHeight*_numRows) >= boardSizeLimits.height){
            
            _RowHeight = boardSizeLimits.height/_numRows;
            _columnWidth = _RowHeight;
        }
        
    }
    
    
    float heightTest = _RowHeight * 0.95;
    float widthTest = _columnWidth * 0.95;
    
    if(heightTest > widthTest){
        
        _cookieWidth = widthTest;
        _cookieHeight = widthTest;
        
    }else{
        
        _cookieWidth = heightTest;
        _cookieHeight = heightTest;
        
    }
    
    
    _gameBoard.position = CGPointMake((_scene.size.width * 0.6) - ((_columnWidth * _numColumns) * 0.5) - (_columnWidth * 0.5),
                                      (_scene.size.height * 0.5) - ((_RowHeight * _numRows) * 0.5) - (_RowHeight * 0.5)
                                      );
    
    CGSize cookieSize = CGSizeMake(_cookieWidth, _cookieHeight);
    CGSize tileSize = CGSizeMake(_columnWidth, _RowHeight);
    
    for (int i=0; i<_theVisiblePieces.count; i++) {
        CDGameBoardSpriteNode* piece = _theVisiblePieces[i];
        piece.size = cookieSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_theReservePieces.count; i++) {
        CDGameBoardSpriteNode* piece = _theReservePieces[i];
        piece.size = cookieSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_theBackground.count; i++) {
        CDGameBoardSpriteNode* piece = _theBackground[i];
        piece.size = tileSize;
        piece.position = [_scene convertPoint:CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight) fromNode:_gameBoard];
        
    }
    for (int i=0; i<_allPlates.count; i++) {
        CDGameBoardSpriteNode* piece = _allPlates[i];
        piece.size = tileSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_SuperCookies.count; i++) {
        CDGameBoardSpriteNode* piece = _SuperCookies[i];
        [[CDCookieAnimationManager animationManager] SuperSizing:piece];
    }
    for(int i=0; i<_ingredientDropIcons.count; i++){
        CDGameBoardSpriteNode* dropIcon = _ingredientDropIcons[i];
        dropIcon.size = CGSizeMake(_columnWidth * 0.5, _RowHeight * 0.5);
       
        dropIcon.position = [_scene convertPoint:CGPointMake((dropIcon.column * _columnWidth) + _columnWidth, _RowHeight - dropIcon.size.height) fromNode:_gameBoard];
        
    }
    for (int i=0; i<_cookieDoughLord.myDoughyChildren.count; i++) {
        CDGameBoardSpriteNode* piece = _cookieDoughLord.myDoughyChildren[i];
        piece.size = tileSize;
    }
    
    for (int i=0; i<_allBombs.count; i++) {
        CDBombSpriteNode* piece = _allBombs[i];
        piece.size = CGSizeMake(cookieSize.width * 1.15f, cookieSize.height * 1.15f);
        
        piece.anchorPoint = CGPointMake(0.4583f, 0.5f);
        
        SKSpriteNode* shine = piece.children[0];
        shine.size = piece.size;
        shine.anchorPoint = piece.anchorPoint;
        
        SKSpriteNode* wick = piece.children[1];
        wick.size = piece.size;
        wick.anchorPoint = piece.anchorPoint;
        
        SKLabelNode* number = piece.children[2];
        number.fontSize = _cookieWidth * 0.5f;
        number.position = CGPointMake(0, -piece.size.height * 0.25f);
        
    }
}

-(void)To_Portrait
{

    CGSize boardSizeLimits = CGSizeMake(_scene.size.width * 0.9, _scene.size.height * 0.75);
    
    // make the board fit
    if(_numRows > _numColumns){
        
        _RowHeight = boardSizeLimits.height/_numRows;
        _columnWidth = _RowHeight;
        
        if((_columnWidth*_numColumns) >= boardSizeLimits.width){
            
            _columnWidth = boardSizeLimits.width/_numColumns;
            _RowHeight = _columnWidth;
        }
        
    }else{
        
        _columnWidth = boardSizeLimits.width/_numColumns;
        _RowHeight = _columnWidth;
        
        if((_RowHeight*_numRows) >= boardSizeLimits.height){
            
            _RowHeight = boardSizeLimits.height/_numRows;
            _columnWidth = _RowHeight;
        }
        
    }
    
    
    float heightTest = _RowHeight * 0.95;
    float widthTest = _columnWidth * 0.95;
    
    if(heightTest > widthTest){
        
        _cookieWidth = widthTest;
        _cookieHeight = widthTest;
        
    }else{
        
        _cookieWidth = heightTest;
        _cookieHeight = heightTest;
        
    }

    _gameBoard.position = CGPointMake((_scene.size.width * 0.5) - ((_columnWidth * _numColumns) * 0.5) - (_columnWidth * 0.5),
                                      (_scene.size.height * 0.55) - ((_RowHeight * _numRows)*0.5) - (_RowHeight * 0.5)
                                      );
    
    CGSize cookieSize = CGSizeMake(_cookieWidth, _cookieHeight);
    CGSize tileSize = CGSizeMake(_columnWidth, _RowHeight);
    
    for (int i=0; i<_theVisiblePieces.count; i++) {
        CDGameBoardSpriteNode* piece = _theVisiblePieces[i];
        piece.size = cookieSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_theReservePieces.count; i++) {
        CDGameBoardSpriteNode* piece = _theReservePieces[i];
        piece.size = cookieSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_theBackground.count; i++) {
        CDGameBoardSpriteNode* piece = _theBackground[i];
        piece.size = tileSize;
        piece.position = [_scene convertPoint:CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight) fromNode:_gameBoard];
        
    }
    for (int i=0; i<_allPlates.count; i++) {
        CDGameBoardSpriteNode* piece = _allPlates[i];
        piece.size = tileSize;
        piece.position = CGPointMake((piece.column * _columnWidth)+ _columnWidth, (piece.row * _RowHeight)+ _RowHeight);
        
    }
    for (int i=0; i<_SuperCookies.count; i++) {
        CDGameBoardSpriteNode* piece = _SuperCookies[i];
        [[CDCookieAnimationManager animationManager] SuperSizing:piece];
        
    }
    for(int i=0; i<_ingredientDropIcons.count; i++){
        CDGameBoardSpriteNode* dropIcon = _ingredientDropIcons[i];
        dropIcon.size = CGSizeMake(_columnWidth * 0.5, _RowHeight * 0.5);
        
        dropIcon.position = [_scene convertPoint:CGPointMake((dropIcon.column * _columnWidth) + _columnWidth, _RowHeight - dropIcon.size.height) fromNode:_gameBoard];
        
    }
    for (int i=0; i<_cookieDoughLord.myDoughyChildren.count; i++) {
        CDGameBoardSpriteNode* piece = _cookieDoughLord.myDoughyChildren[i];
        piece.size = tileSize;
    }
    
    for (int i=0; i<_allBombs.count; i++) {
        CDBombSpriteNode* piece = _allBombs[i];
        piece.size =  CGSizeMake(cookieSize.width * 1.15f, cookieSize.height * 1.15f);
        
        piece.anchorPoint = CGPointMake(0.4583f, 0.5f);
        
        SKSpriteNode* shine = piece.children[0];
        shine.size = piece.size;
        shine.anchorPoint = piece.anchorPoint;
        
        SKSpriteNode* wick = piece.children[1];
        wick.size = piece.size;
        wick.anchorPoint = piece.anchorPoint;
        
        SKLabelNode* number = piece.children[2];
        number.fontSize = _cookieWidth * 0.5f;
        number.position = CGPointMake(0, -piece.size.height * 0.25f);
        
    }
    
}


/*
 - (void)changeCookieToClearBlock:(CDCookieSpriteNode *)cookie
 {
 CDClearBlockSprite *clearBlockSprite = [[CDClearBlockSprite alloc] initClearBlockWithTexture:nil size:CGSizeMake(_cookieWidth, _cookieHeight) color:[SKColor redColor] rowIndex:cookie.row];
 
 [_gameBoard addChild:clearBlockSprite];
 
 clearBlockSprite.position = cookie.position;
 
 [cookie removeFromParent];
 
 if ([_blockArray containsObject:cookie])
 {
 [_blockArray removeObjectAtIndex:[_blockArray indexOfObject:cookie]];
 }
 }
 
 - (void)changeCookieToIngredient:(CDCookieSpriteNode *)cookie
 {
 CDIngredientSpriteNode *ingredient = [[CDIngredientSpriteNode alloc] initIngredientWithTexture:[SKTexture textureWithImageNamed:@"tempIngredient@2x"] size:CGSizeMake(_cookieWidth, _cookieHeight) color:[SKColor redColor]];
 
 [_gameBoard addChild:ingredient];
 
 ingredient.position = cookie.position;
 
 [cookie removeFromParent];
 
 if ([_blockArray containsObject:cookie])
 {
 [_blockArray removeObjectAtIndex:[_blockArray indexOfObject:cookie]];
 }
 }
 
 
 - (void)changeCookieToBlocker:(CDCookieSpriteNode *)cookie
 {
 CDBlockerSpriteNode *blocker = [[CDBlockerSpriteNode alloc] initBlockerSpriteWithLevelOneTexture:nil levelTwoTexture:nil levelThreeTexture:nil levelFourTexture:nil withSize:CGSizeMake(_cookieWidth, _cookieHeight) withColor:[SKColor blueColor] withLevel:4];
 
 [_gameBoard addChild:blocker];
 
 blocker.position = cookie.position;
 
 [cookie removeFromParent];
 
 if ([_blockArray containsObject:cookie])
 {
 [_blockArray removeObjectAtIndex:[_blockArray indexOfObject:cookie]];
 }
 }
 
 - (void)willAnimateInComboTexture
 {
 SKTexture *comboTexture = nil;
 
 switch (self.comboCounter)
 {
 case 1:
 {
 comboTexture = [SKTexture sgtextureWithImageNamed:@"combo-easybake"];
 }
 break;
 
 case 2:
 {
 comboTexture = [SKTexture sgtextureWithImageNamed:@"combo-halfbaked"];
 }
 break;
 
 case 3:
 {
 comboTexture = [SKTexture sgtextureWithImageNamed:@"combo-fullybaked"];
 }
 break;
 
 default:
 break;
 }
 
 if (self.comboCounter >= 1 && self.comboCounter <= 3)
 {
 SKSpriteNode *comboTextureSpriteNode = [[SKSpriteNode alloc] initWithTexture:comboTexture color:nil size:CGSizeMake(_scene.size.width-100, comboTexture.size.height)];
 comboTextureSpriteNode.zPosition = 1;
 comboTextureSpriteNode.xScale = 0.0f;
 comboTextureSpriteNode.yScale = 0.0f;
 comboTextureSpriteNode.alpha = 0.0f;
 
 SKSpriteNode *bgSpriteNode = [[SKSpriteNode alloc] initWithColor:[SKColor blackColor] size:CGSizeMake(comboTextureSpriteNode.size.width+2, comboTextureSpriteNode.size.height+2)];
 bgSpriteNode.zPosition = 10000;
 bgSpriteNode.alpha = 0.0f;
 
 //[bgSpriteNode addChild:comboTextureSpriteNode];
 [self.scene addChild:comboTextureSpriteNode];
 
 comboTextureSpriteNode.position = CGPointMake(CGRectGetMidX(self.scene.frame), CGRectGetMidY(self.scene.frame)+50);
 
 SKAction *fadeInAction = [SKAction fadeAlphaTo:1.0f duration:0.3f];
 SKAction *fadeOutAction = [SKAction fadeAlphaTo:0.0f duration:0.3f];
 SKAction *delayAction = [SKAction waitForDuration:0.8f];
 SKAction *removeAction = [SKAction removeFromParent];
 
 SKAction *scaleIn = [SKAction scaleTo:1.0f duration:0.3f];
 SKAction *scaleOut = [SKAction scaleTo:0.0f duration:0.3];
 
 SKAction *groupInAction = [SKAction group:@[fadeInAction, scaleIn]];
 SKAction *groupOutAction = [SKAction group:@[fadeOutAction, scaleOut]];
 
 SKAction *sequenceAction = [SKAction sequence:@[groupInAction, delayAction, groupOutAction, removeAction]];
 [comboTextureSpriteNode runAction:sequenceAction];
 }
 else if (self.comboCounter > 4)
 {
 self.comboCounter = 0;
 }
 }
 
 */


#pragma mark - Sound effects methods

-(void)Play_swipe_sound
{
//    [_scene runAction:_SwipeSounds[_whichSwipeSound]];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:[NSString stringWithFormat:@"Swoosh %i", _whichSwipeSound] FileType:@"caf" volume:1]; //@"m4a" volume:1];
    
    _whichSwipeSound++;
    
    if(_whichSwipeSound > 4)
    {
        _whichSwipeSound = 1;
    }
    
}


#pragma mark - Score, Goals, and Limiters methods

-(void)GoodSwap
{
    // Play the crunch sound.
    int randomCrunch = (arc4random() % 3) + 5;//_crunchSoundsArray.count;
//    [_gameBoard runAction:_crunchSoundsArray[randomCrunch]];

    [[SGAudioManager audioManager] playSoundEffectWithFilename:[NSString stringWithFormat:@"Crunch %i", randomCrunch] FileType:@"caf" volume:1]; //@"m4a" volume:1];

    
    if(_goalLimiter == GoalLimiters_MOVE_LIMIT && _limiterValue > -1)
        _limiterValue--;
    
    
}

-(void)BadSwap
{
    DebugLog(@"You're a moron!");
    
}

-(void)Make_A_Timer_Node{
    
    if(_timerNode){
        
        [_timerNode removeAllActions];
        [_timerNode removeFromParent];
    }
    
    _timerNode = [SKNode new];
    
    [_scene addChild:_timerNode];
    
    [_timerNode runAction:[SKAction repeatAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction runBlock:^{
        
        if(_limiterValue > -1)
            _limiterValue--;
        
        float secondsLeft = _limiterValue;
        
        int minutes = floorf(secondsLeft/60);
        int seconds = secondsLeft - (minutes*60);
        
        if(seconds < 10){
            
            _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%02i:0%i",minutes, seconds];
            
        }else
            _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%02i:%i",minutes, seconds];
        
        
    }]]] count:_limiterValue] completion:^{
        
        
        float secondsLeft = _limiterValue;
        
        int minutes = floorf(secondsLeft/60);
        int seconds = secondsLeft - (minutes*60);
        
        if(seconds < 10){
            
            _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%02i:0%i",minutes, seconds];
            
        }else
            _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%02i:%i",minutes, seconds];
        
        // too slow mofo
        
        if(_isTakingInput){
            [self Give_Control_Back_to_User];
        }
        
    }];
    
}

-(BOOL)Check_Board_for_types_to_Clear{ // only on clear all
    
    BOOL returnBool = YES;
    
    if([_mainGoalItems[0] intValue] == 500){ // plates
        if(_allPlates.count > 0){
            
            returnBool = NO;
            
        }
    }
    
    for (CDGameBoardSpriteNode* piece in _theGameGrid) {
        
        // if Clear type
        for(int i=0;i<_mainGoalItems.count; i++){
            
            int value = [_mainGoalItems[i] intValue];
            
            if(value == (int) piece.typeID){
                
                returnBool = NO;
                
            }
        }
    }
    
    return returnBool;
}

-(void)Shout_Out_Time:(BOOL)isCookieCrumble{
    SKNode *shoutOutNode = [SKNode new];
    
    if(isCookieCrumble) {
        // Cookie Crumble!
        UIImage *cookieTextureImage = [UIImage imageNamed:@"cdd-emptext-cookie"];
        SKTexture *cookieTexture = [SKTexture textureWithImage:cookieTextureImage];
        SKSpriteNode *cookieSprite = [SKSpriteNode spriteNodeWithTexture:cookieTexture];
        cookieSprite.position = CGPointMake(cookieSprite.size.width * -0.15f, cookieSprite.size.height * 0.5f);
        [shoutOutNode addChild:cookieSprite];
        
        UIImage *crumbleTextureImage = [UIImage imageNamed:@"cdd-emptext-crumble"];
        SKTexture *crumbleTexture = [SKTexture textureWithImage:crumbleTextureImage];
        SKSpriteNode *crumbleSprite = [SKSpriteNode spriteNodeWithTexture:crumbleTexture];
        crumbleSprite.position = CGPointMake(crumbleSprite.size.width * 0.2f, crumbleSprite.size.height * -0.5f);
        [shoutOutNode addChild:crumbleSprite];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieCrumble2" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    }else if (_score_multiplier > 20) {
        // Ultra Cookie Combo Breaker!
        UIImage *ultraTextureImage = [UIImage imageNamed:@"cdd-emptext-ultra"];
        SKTexture *ultraTexture = [SKTexture textureWithImage:ultraTextureImage];
        SKSpriteNode *ultraSprite = [SKSpriteNode spriteNodeWithTexture:ultraTexture];
        ultraSprite.position = CGPointMake(ultraSprite.size.width * -0.65f, ultraSprite.size.height * 1.3f);
        [shoutOutNode addChild:ultraSprite];
        
        UIImage *cookieTextureImage = [UIImage imageNamed:@"cdd-emptext-cookie"];
        SKTexture *cookieTexture = [SKTexture textureWithImage:cookieTextureImage];
        SKSpriteNode *cookieSprite = [SKSpriteNode spriteNodeWithTexture:cookieTexture];
        cookieSprite.position = CGPointMake(cookieSprite.size.width * 0.13f, cookieSprite.size.height * 0.1f);
        [shoutOutNode addChild:cookieSprite];
        
        UIImage *comboTextureImage = [UIImage imageNamed:@"cdd-emptext-combo"];
        SKTexture *comboTexture = [SKTexture textureWithImage:comboTextureImage];
        SKSpriteNode *comboSprite = [SKSpriteNode spriteNodeWithTexture:comboTexture];
        comboSprite.position = CGPointMake(comboSprite.size.width * -0.4f, comboSprite.size.height * -0.85f);
        [shoutOutNode addChild:comboSprite];
        
        UIImage *breakerTextureImage = [UIImage imageNamed:@"cdd-emptext-breaker"];
        SKTexture *breakerTexture = [SKTexture textureWithImage:breakerTextureImage];
        SKSpriteNode *breakerSprite = [SKSpriteNode spriteNodeWithTexture:breakerTexture];
        breakerSprite.position = CGPointMake(breakerSprite.size.width * 0.2f, breakerSprite.size.height * -1.6f);
        [shoutOutNode addChild:breakerSprite];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ComboBreaker" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    }
    else if (_score_multiplier > 15) {
        // Fully Baked!
        UIImage *fullyTextureImage = [UIImage imageNamed:@"cdd-emptext-fully"];
        SKTexture *fullyTexture = [SKTexture textureWithImage:fullyTextureImage];
        SKSpriteNode *fullySprite = [SKSpriteNode spriteNodeWithTexture:fullyTexture];
        fullySprite.position = CGPointMake(fullySprite.size.width * -0.4f, fullySprite.size.height * 0.5f);
        [shoutOutNode addChild:fullySprite];
        
        UIImage *bakedTextureImage = [UIImage imageNamed:@"cdd-emptext-baked"];
        SKTexture *bakedTexture = [SKTexture textureWithImage:bakedTextureImage];
        SKSpriteNode *bakedSprite = [SKSpriteNode spriteNodeWithTexture:bakedTexture];
        bakedSprite.position = CGPointMake(bakedSprite.size.width * 0.1f, bakedSprite.size.height * -0.5f);
        [shoutOutNode addChild:bakedSprite];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"FullyBaked" FileType:@"caf" volume:1]; //@"m4a" volume:1];
        
    }
    else if (_score_multiplier > 10) {
        // Half Baked!
        UIImage *halfTextureImage = [UIImage imageNamed:@"cdd-emptext-half"];
        SKTexture *halfTexture = [SKTexture textureWithImage:halfTextureImage];
        SKSpriteNode *halfSprite = [SKSpriteNode spriteNodeWithTexture:halfTexture];
        halfSprite.position = CGPointMake(halfSprite.size.width * -0.4f, halfSprite.size.height * 0.5f);
        [shoutOutNode addChild:halfSprite];
        
        UIImage *bakedTextureImage = [UIImage imageNamed:@"cdd-emptext-baked"];
        SKTexture *bakedTexture = [SKTexture textureWithImage:bakedTextureImage];
        SKSpriteNode *bakedSprite = [SKSpriteNode spriteNodeWithTexture:bakedTexture];
        bakedSprite.position = CGPointMake(bakedSprite.size.width * 0.1f, bakedSprite.size.height * -0.5f);
        [shoutOutNode addChild:bakedSprite];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"HalfBaked" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    }
    else if (_score_multiplier > 7) {
        // Easy Bake!
        UIImage *easyTextureImage = [UIImage imageNamed:@"cdd-emptext-easy"];
        SKTexture *easyTexture = [SKTexture textureWithImage:easyTextureImage];
        SKSpriteNode *easySprite = [SKSpriteNode spriteNodeWithTexture:easyTexture];
        easySprite.position = CGPointMake(easySprite.size.width * -0.4f, easySprite.size.height * 0.5f);
        [shoutOutNode addChild:easySprite];
        
        UIImage *bakedTextureImage = [UIImage imageNamed:@"cdd-emptext-baked"];
        SKTexture *bakedTexture = [SKTexture textureWithImage:bakedTextureImage];
        SKSpriteNode *bakedSprite = [SKSpriteNode spriteNodeWithTexture:bakedTexture];
        bakedSprite.position = CGPointMake(bakedSprite.size.width * 0.1f, bakedSprite.size.height * -0.5f);
        [shoutOutNode addChild:bakedSprite];
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"EasyBaked" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    }
    
    // Fixing scale issues from setting textures with a UIImage.
    for (SKNode *node in shoutOutNode.children) {
        if ([node isKindOfClass:[SKSpriteNode class]]) {
            SKSpriteNode *spriteNode = (SKSpriteNode *)node;
            [spriteNode setScale:0.5f];
            spriteNode.position = CGPointMake(spriteNode.position.x * 0.5f, spriteNode.position.y * 0.5f);
        }
    }
    
    // Set the initial state of the shoutout.
    shoutOutNode.alpha = 0.3f;
    shoutOutNode.position = CGPointMake(_scene.size.width * 0.5f, _scene.size.height * 0.4f);
    shoutOutNode.xScale = 0.3f;
    shoutOutNode.yScale = 0.8f;
    shoutOutNode.zPosition = 500;
    [_scene addChild:shoutOutNode];
    
    // Display the shoutout.
    SKAction *scaleUpAction = [SKAction scaleTo:1.0f duration:0.3f];
    SKAction *fadeInAction = [SKAction fadeAlphaTo:1.0f duration:0.3];
    SKAction *moveUpAction = [SKAction moveTo:CGPointMake(_scene.size.width * 0.5f, _scene.size.height * 0.65f) duration:0.3f];
    SKAction *displayShoutout = [SKAction group:@[scaleUpAction, fadeInAction, moveUpAction]];
    
    // Zoom the shoutout away.
    SKAction *zoomScaleAction = [SKAction scaleTo:8.0f duration:0.3f];
    SKAction *zoomFadeAction = [SKAction fadeAlphaTo:0.0f duration:0.3f];
    SKAction *dismissShoutout = [SKAction group:@[zoomScaleAction, zoomFadeAction]];
    
    // Full action.
    SKAction *shoutoutAction = [SKAction sequence:@[displayShoutout, [SKAction waitForDuration:1.0f], dismissShoutout]];
    [shoutOutNode runAction:shoutoutAction completion:^{
        [shoutOutNode removeFromParent];
    }];
    
}

-(void)Give_Control_Back_to_User{
    
    _isTakingInput = YES;
    
    [self checkScoreAchievements];
    
    if(_scene.theSelectedPiece != nil)
    if(_scene.theSelectedPiece.isHidden == NO){
        [self PlaySwitchBackAnimation:_scene.theSelectedPiece];
    }
    
    if(_scene.theOtherPiece != nil)
    if(_scene.theOtherPiece.isHidden == NO){
        [self PlaySwitchBackAnimation:_scene.theOtherPiece];
    }
    
    _scene.theSelectedPiece = nil;
    _scene.theOtherPiece = nil;
    
    
    BOOL isABombGoingOff = NO;
    
    for(CDBombSpriteNode* bomb in _allBombs){
        if([bomb Tick]){
            isABombGoingOff = YES;
            DebugLog(@"\n\n\t boom \n\n");
            [self GameOver_isConditionGood:NO];
            break;
        }
    }
    
    if(isABombGoingOff)
        return;
    
    if(_limiterValue == -1) // unlimited
    {
        [self Check_if_the_player_won_Unlimited];
        
        [self Shout_Out_Time:NO];  // <<< Cascade end.
    
    }else if(_limiterValue == 0){
        
        [self Check_if_the_player_won_Limited];
        
        [self Shout_Out_Time:NO];  // <<< Cascade end.
        
    }else if(_limiterValue > 0){
        
        if(_goalLimiter == GoalLimiters_MOVE_LIMIT){
            if(_score >= _score_gold){
                [self Check_if_the_player_won_Unlimited];
            }else{
                [self Shout_Out_Time:NO];  // <<< Cascade end.
            }
        }else{
            [self Shout_Out_Time:NO];  // <<< Cascade end.
        }
        
    }

    _score_multiplier = 1;
    
}

- (void)checkScoreAchievements {
    if ([CDPlayerObject player].cumulativeScore > 100000) {
        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"master_chef" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
            if (reportWasSuccessful) {
                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"master_chef" InView:_scene.view Completion:nil];
                
                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker_apprentice" percentComplete:100.0 Completion:nil];
                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:nil];
            }
        }];
    }
    else if ([CDPlayerObject player].cumulativeScore > 50000) {
        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker_apprentice" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
            if (reportWasSuccessful) {
                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"baker_apprentice" InView:_scene.view Completion:nil];
                
                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:nil];
            }
        }];
    }
    else if ([CDPlayerObject player].cumulativeScore > 10000) {
        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
            if (reportWasSuccessful) {
                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"baker" InView:_scene.view Completion:nil];
            }
        }];
    }

}

-(void)Check_if_the_player_won_Limited{
    
    
    BOOL isFirstGoalCompleted = NO;
    BOOL isSecondGoalCompleted = NO;
    
    // first check
    {
        if(_mainGoalType == GoalTypes_TOTALSCORE){
            
            if(_score >= _mainGoalValue){
                
                isFirstGoalCompleted = YES;
                
            }else{
                
                isFirstGoalCompleted = NO;
                
            }
        }
        
        if(_mainGoalType == GoalTypes_TYPECLEAR || _mainGoalType == GoalTypes_INGREDIENT){
            
            
            BOOL win = YES;
            for(int i=0;i<_mainGoalItems.count; i+=2){
                
                int how_many_left = [_mainGoalItems[i+1] intValue];
                
                if(how_many_left > 0){
                    win = NO;
                }
            }
            
            if(win){
                isFirstGoalCompleted = YES;
            }else{
                isFirstGoalCompleted = NO;
            }
            
        }
        
        if(_mainGoalType == GoalTypes_STARCOUNT){
            
            if(_mainGoalValue == 1){
                
                if(_score >= _score_bronze){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
                
            }else if(_mainGoalValue == 2){
                
                if(_score >= _score_silver){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
                
                
            }else if(_mainGoalValue >= 3){
                
                if(_score >= _score_gold){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
            }
            
        }
    }
    
    // second check
    if(_secondGoalType == _mainGoalType){
        
        isSecondGoalCompleted = YES;
    }
    else
    {
        if(_secondGoalType == GoalTypes_TOTALSCORE){
            
            if(_score >= _secondGoalValue){
                
                isSecondGoalCompleted = YES;
                
            }else{
                
                isSecondGoalCompleted = NO;
                
            }
        }
        
        if(_secondGoalType == GoalTypes_TYPECLEAR || _secondGoalType == GoalTypes_INGREDIENT){
            
            
            BOOL win = YES;
            for(int i=0;i<_secondGoalItems.count; i+=2){
                
                int how_many_left = [_secondGoalItems[i+1] intValue];
                
                if(how_many_left > 0){
                    win = NO;
                }
            }
            
            if(win){
                isSecondGoalCompleted = YES;
            }else{
                isSecondGoalCompleted = NO;
            }
            
        }
        
        if(_secondGoalType == GoalTypes_STARCOUNT){
            
            if(_secondGoalValue == 1){
                
                if(_score >= _score_bronze){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
                
            }else if(_secondGoalValue == 2){
                
                if(_score >= _score_silver){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
                
                
            }else if(_secondGoalValue >= 3){
                
                if(_score >= _score_gold){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
            }
            
        }
    }
    
    // check the results
    
    if(isFirstGoalCompleted && isSecondGoalCompleted){
        
        [self MeteorShower];
        
        if(!_didCookieCrumble){
            [self Shout_Out_Time:YES];
            _didCookieCrumble = YES;
        }else
            [self Shout_Out_Time:NO];
        
    }else{
        
        [self GameOver_isConditionGood:NO];
        
    }
    
}

-(void)Check_if_the_player_won_Unlimited{
    
    // check bombs first
    
    BOOL isFirstGoalCompleted = NO;
    BOOL isSecondGoalCompleted = NO;
    
    // first check
    {
        if(_mainGoalType == GoalTypes_TOTALSCORE){
            
            if(_score >= _mainGoalValue){
                
                isFirstGoalCompleted = YES;
                
            }else{
                
                isFirstGoalCompleted = NO;
                
            }
        }
        
        if(_mainGoalType == GoalTypes_TYPECLEAR || _mainGoalType == GoalTypes_INGREDIENT){
            
            
            BOOL win = YES;
            for(int i=0;i<_mainGoalItems.count; i+=2){
                
                int how_many_left = [_mainGoalItems[i+1] intValue];
                
                if(how_many_left > 0){
                    win = NO;
                }
            }
            
            if(win){
                isFirstGoalCompleted = YES;
            }else{
                isFirstGoalCompleted = NO;
            }
            
        }
        
        if(_mainGoalType == GoalTypes_STARCOUNT){
            
            if(_mainGoalValue == 1){
                
                if(_score >= _score_bronze){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
                
            }else if(_mainGoalValue == 2){
                
                if(_score >= _score_silver){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
                
                
            }else if(_mainGoalValue >= 3){
                
                if(_score >= _score_gold){
                    
                    isFirstGoalCompleted = YES;
                }
                else
                    isFirstGoalCompleted = NO;
            }
            
        }
    }
    
    // second check
    if(_secondGoalType == _mainGoalType){
        
        isSecondGoalCompleted = YES;
    }
    else
    {
        if(_secondGoalType == GoalTypes_TOTALSCORE){
            
            if(_score >= _secondGoalValue){
                
                isSecondGoalCompleted = YES;
                
            }else{
                
                isSecondGoalCompleted = NO;
                
            }
        }
        
        if(_secondGoalType == GoalTypes_TYPECLEAR || _secondGoalType == GoalTypes_INGREDIENT){
            
            
            BOOL win = YES;
            for(int i=0;i<_secondGoalItems.count; i+=2){
                
                int how_many_left = [_secondGoalItems[i+1] intValue];
                
                if(how_many_left > 0){
                    win = NO;
                }
            }
            
            if(win){
                isSecondGoalCompleted = YES;
            }else{
                isSecondGoalCompleted = NO;
            }
            
        }
        
        if(_secondGoalType == GoalTypes_STARCOUNT){
            
            if(_secondGoalValue == 1){
                
                if(_score >= _score_bronze){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
                
            }else if(_secondGoalValue == 2){
                
                if(_score >= _score_silver){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
                
                
            }else if(_secondGoalValue >= 3){
                
                if(_score >= _score_gold){
                    
                    isSecondGoalCompleted = YES;
                }
                else
                    isSecondGoalCompleted = NO;
            }
        }
    }
    
    // check the results
    
    if(isFirstGoalCompleted && isSecondGoalCompleted){
        
        [self MeteorShower];
        
        if(!_didCookieCrumble){
            [self Shout_Out_Time:YES];
            _didCookieCrumble = YES;
        }else
            [self Shout_Out_Time:NO];
        
    }else{
        
        // not yet
    }
}

-(void)GameOver_isConditionGood:(BOOL)isGood{
    
    self.gameIsOver = YES;
    _gameInProgress = NO;
    
    [[SGAudioManager audioManager] stopTheMusic];
    
    _scene.throwAwayButton.boosterName = nil;
    _scene.ApplyPowerupOnCookie = EMPTY_ITEM;
    [_scene.boosterSelectedObject removeFromParent];
    
    _isTakingInput = NO;
    
    if(_timerNode != nil)
        [_timerNode removeAllActions];
    
    if(isGood){
        
        // Congrats
        
        DebugLog(@"\n\n\t You win \n");
        
        [self displayVictoryScreen];
        
        [self updateLevel];
        
    }else{
        
        DebugLog(@"\n\n\t  You Loose \n");
        
        [self displayLoseScreen];
    }
}

- (void)updateLevel {
    NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
    // CRASHLYTICS
    NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
    NSString *worldName = [[SGFileManager fileManager] stringFromIndex:[_worldType intValue] inFile:@"planetoids-master-list"];
    
    // Check for star count.
    int worldIndex = [_worldType intValue];
    NSNumber *previousStarCount = 0; //[SGAppDelegate appDelegate].accountDict[@"worlds"][worldIndex][@"levels"][[_levelType intValue]-1][@"starCount"];
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    if (worldsArray && [_worldType intValue] < [worldsArray count]) {
        NSDictionary *worldDict = worldsArray[[_worldType intValue]];
        NSArray *levelsArray = worldDict[@"levels"];
        if (levelsArray && [_levelType intValue] <= [levelsArray count]) {
            NSDictionary *levelDict = levelsArray[[_levelType intValue]-1];
            if (levelDict) {
                previousStarCount = levelDict[@"starCount"];
            }
        }
    }
    NSNumber *currentStarCount = [NSNumber numberWithInt:_scene.milkCup.starLevel];
    NSNumber *bestStarCount = [[NSNumber alloc] initWithInt:0];
    if ([currentStarCount intValue] > [previousStarCount intValue]) {
        bestStarCount = currentStarCount;
    }
    else {
        bestStarCount = previousStarCount;
    }
    
    // Check for high score
    NSNumber *previousHighScore = 0; //[SGAppDelegate appDelegate].accountDict[@"worlds"][worldIndex][@"levels"][[_levelType intValue]-1][@"highScore"];
//    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
   
    if (worldsArray && [_worldType intValue] < [worldsArray count]) {
        NSDictionary *worldDict = worldsArray[[_worldType intValue]];
        NSArray *levelsArray = worldDict[@"levels"];
        if (levelsArray && [_levelType intValue] <= [levelsArray count]) {
            NSDictionary *levelDict = levelsArray[[_levelType intValue]-1];
            if (levelDict) {
                previousHighScore = levelDict[@"highScore"];
            }
        }
    }
    
    NSNumber *currentHighScore = [NSNumber numberWithInt:self.score];
    NSNumber *bestHighScore = [[NSNumber alloc] initWithInt:0];
    
    if ([currentHighScore intValue] > [previousHighScore intValue])
    {
        bestHighScore = currentHighScore;
    }
    else
    {
        bestHighScore = previousHighScore;
    }
    
    // TODO: Need to compare high scores.
    [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
                                                             deviceId:deviceID
                                                            worldType:[NSNumber numberWithInt:[_worldType intValue]+1]
                                                            worldName:worldName
                                                            levelType:_levelType
                                                            starCount:bestStarCount
                                                            highScore:bestHighScore
                                                    completionHandler:^
     (NSError *error, NSDictionary *levelInfo)
     {
         DebugLog(@"Updated current level info.");
     }];
    
    [self checkAndUnlockNextLevel];
}


- (void)displayVictoryScreen {
    // Setup the victory screen.
    
//    BOOL addToArray = YES;
    
    
    [_gamePopupView setupWinScreenWithStarType:_scene.milkCup.starLevel Score:_score];
    _gamePopupView.didWin = YES;
    
//    if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation))
//    {
    _gamePopupView.frame = _scene.frame;//CGRectMake(_scene.view.frame.origin.x, _scene.view.frame.origin.y, _scene.view.frame.size.width, _scene.view.frame.size.height);
        
//    }
//    else
//    {
//        _gamePopupView.frame = CGRectMake(_scene.view.frame.origin.x, _scene.view.frame.origin.y, _scene.view.frame.size.height, _scene.view.frame.size.width);
//    }
    
    NSDictionary *planetDict = [[SGFileManager fileManager] loadDictionaryWithFileName:_what_planet_am_I_on OfType:@"plist"];
    NSString *planetDisplayName = planetDict[@"displayName"];
    [_gamePopupView.labelLabel setText:[NSString stringWithFormat:@"%@: %@", planetDisplayName, _levelType]];
    _gamePopupView.level = [_levelType intValue];
    _gamePopupView.levelName = _what_planet_am_I_on;
    
    // Gonna have to keep this updated.
    // THIS IS 0 BASED!!!! JUST A FAIR WARNING!!!!
    if ([_scene.parentController.planetType intValue] == numUnlockablePlanets-1 &&
        [_scene.parentController.levelType intValue] == 30) {
        
        // Last level of the last planet.
        _gamePopupView.nextButton.hidden = YES;
        _gamePopupView.nextButtonTextLabel.hidden = YES;
    }
    else {
        _gamePopupView.nextButton.hidden = NO;
        _gamePopupView.nextButtonTextLabel.hidden = NO;
    }
    
    [_scene.view insertSubview:_gamePopupView atIndex:0];
    
    int originalStarCount = 0;
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    if (worldsArray && [_worldType intValue] < [worldsArray count]) {
        NSDictionary *worldDict = worldsArray[[_worldType intValue]];
        NSArray *levelsArray = worldDict[@"levels"];
        if (levelsArray && [_levelType intValue] <= [levelsArray count]) {
            NSDictionary *levelDict = levelsArray[[_levelType intValue]-1];
            if (levelDict) {
                originalStarCount = [levelDict[@"starCount"] intValue];
            }
        }
    }
    
    // Run the animation.
    _gamePopupView.userInteractionEnabled = NO;
    [_gamePopupView hidePopupAnimated:NO Completion:nil];
    [_gamePopupView displayPopupAnimated:YES Completion:^(BOOL completed) {
        [self displayAwardPopupWithOriginalStarCount:originalStarCount];
    }];
    
    
    if (_scene.milkCup.starLevel == GOLD_STAR) {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"3-Star" FileType:@"caf"]; //@"m4a"];
    }
    else if (_scene.milkCup.starLevel == SILVER_STAR) {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"2-Star" FileType:@"caf"]; //@"m4a"];
    }
    else {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"1-Star" FileType:@"caf"]; //@"m4a"];
    }
    
}

- (void)displayAwardPopupWithOriginalStarCount:(int)originalStarCount {
    CDAwardPopupViewController *awardPopup = [_scene.parentController.storyboard instantiateViewControllerWithIdentifier:@"CDAwardPopupViewController"];
    awardPopup.view.frame = _scene.frame;//CGRectMake(0, 0, _scene.frame.size.width, _scene.frame.size.height);
    awardPopup.delegate = _scene.parentController;
    
    if (_scene.milkCup.starLevel == GOLD_STAR)
    {
        //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"3-Star" FileType:@"m4a"];
     
//        awardPopup.coinsToAward = 50;
//        awardPopup.awardForMainGame = YES;
        
        /* TODO: JOSH here was a problem */
        // Gary J: Fixed, however, who changed the planet IDs?
        if (originalStarCount != GOLD_STAR)
        {
            awardPopup.awardGem = YES;
            awardPopup.awardForMainGame = NO;
        }
        else
        {
            awardPopup.coinsToAward = 50;
            awardPopup.awardForMainGame = YES;
        }
    }
    else if (_scene.milkCup.starLevel == SILVER_STAR)
    {
        //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"2-Star" FileType:@"m4a"];
        
        awardPopup.coinsToAward = 30;
        awardPopup.awardForMainGame = YES;
    }
    else if (_scene.milkCup.starLevel == BRONZE_STAR)
    {
        //[[SGAudioManager audioManager] playSoundEffectWithFilename:@"1-Star" FileType:@"m4a"];
        
        awardPopup.coinsToAward = 10;
        awardPopup.awardForMainGame = YES;
    }
    else
    {
        DebugLog(@"You have somehow managed to win without a star.... We'll award 10 coins to be somewhat fair....");
        awardPopup.coinsToAward = 10;
        awardPopup.awardForMainGame = YES;
    }
    [_scene.parentController addChildViewController:awardPopup];
    [_scene.parentController.view addSubview:awardPopup.view];
    
    _gamePopupView.userInteractionEnabled = YES;
}

- (void)displayLoseScreen {
    // Setup the lose screen.
    
    // Lose a life.
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    int currentLives = (int)[userDefaults integerForKey:CurrentLivesDefault] - 1;
//    [userDefaults setInteger:currentLives forKey:CurrentLivesDefault];
    
    [[CDIAPManager iapMananger] requestToDecreaseLivesValue:[NSNumber numberWithInt:1] costValue:[NSNumber numberWithInt:0] costType:CostType_None completionHandler:nil];
   
    _gamePopupView.frame = _scene.frame;
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"GameFail-2" FileType:@"caf"]; //@"m4a"];
    
    // Make sure to write down what time you changed the lives.
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:LifeUnlockDateDefault] == nil) {
        [userDefaults setObject:[NSDate dateWithTimeIntervalSinceNow:LifeUnlockDelay] forKey:LifeUnlockDateDefault];
    }
    
    
    int currentLives = [[SGAppDelegate appDelegate].accountDict[@"lives"] intValue] - 1;
    BOOL isOutOfLives = NO;
    if (currentLives <= 0) {
        isOutOfLives = YES;
    }
    
    if(isOutOfLives)
    {
        [_gamePopupView setupLoseScreenWithCondition:isOutOfLives WithLossCondition:@"YOU'RE OUT OF LIVES!"];
        _gamePopupView.didWin = NO;
    }
    else
    {
        if(_goalLimiter == GoalLimiters_MOVE_LIMIT)
        {
            [_gamePopupView setupLoseScreenWithCondition:isOutOfLives WithLossCondition:@"YOU'RE OUT OF MOVES!"];
            _gamePopupView.didWin = NO;
        }
        else
        {
            if(_goalLimiter == GoalLimiters_TIME_LIMIT)
            {
                [_gamePopupView setupLoseScreenWithCondition:isOutOfLives WithLossCondition:@"YOU'RE OUT OF TIME!"];
                _gamePopupView.didWin = NO;
            }
            else
            {
                [_gamePopupView setupLoseScreenWithCondition:isOutOfLives WithLossCondition:@"YOU LOSE"];
                _gamePopupView.didWin = NO;
            }
        }
    }
    
    [_gamePopupView.labelLabel setText:[NSString stringWithFormat:@"%@: %@", _what_planet_am_I_on, _levelType]];
    
    [_scene.view addSubview:_gamePopupView];
    
    // Run the animation.
    [_gamePopupView hidePopupAnimated:NO Completion:nil];
    [_gamePopupView displayPopupAnimated:YES Completion:nil];
    

}

- (void)checkAndUnlockNextLevel {
    
    BOOL shouldUnlockNextLevel = NO;
    
    // Figure out if the level you just beat is last one unlocked.
    NSArray *worldsArray = [SGAppDelegate appDelegate].accountDict[@"worlds"];
    int worldIndex = [_worldType intValue];
    NSDictionary *currentWorldDict = worldsArray[worldIndex];
    NSArray *levelsArray = currentWorldDict[@"levels"];
    NSDictionary *lastLevelDict = [levelsArray lastObject];
    
    if ([lastLevelDict[@"type"] isEqualToNumber:_levelType]) {
        shouldUnlockNextLevel = YES;
    }
    
    if (shouldUnlockNextLevel) {
        NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
        NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
        
        NSNumber *nextLevelType;
        NSNumber *nextworldType;
        if ([_levelType intValue] < numLevelsPerPlanet) {
            nextLevelType = [NSNumber numberWithInt:[_levelType intValue] + 1];
            nextworldType = [NSNumber numberWithInt:[_worldType intValue] + 1]; // World type is based on 1, 2, 3 on the the server. Make sure you send it the right number!!!!
                                                                                // Milkywaie            = 1
                                                                                // Dunkopolis           = 2
                                                                                // Abduction Junction   = 3
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:[nextworldType intValue] inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:[NSNumber numberWithInt:[nextworldType intValue]]
                                                                    worldName:worldName
                                                                    levelType:nextLevelType
                                                                    starCount:[NSNumber numberWithInt:0]
                                                                    highScore:[NSNumber numberWithInt:0]
                                                            completionHandler:^(NSError *error, NSDictionary *levelInfo) {
                                                                DebugLog(@"Unlocked level %@ - %@", nextworldType, nextLevelType);
                                                            }];
            
            
            
            
            
            
            
            
            
            
            
            
//            // Unlock the next level of the current world.
//            nextLevelType = [NSNumber numberWithInt:[_levelType intValue] + 1];
//            nextworldType = _worldType;
//            
//            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue]) inFile:@"planetoids-master-list"];
//            
//            [[WebserviceManager sharedManager] updateLevelParametersWithEmail:email
//                                                                     deviceId:deviceID
//                                                                    worldType:nextworldType
//                                                                    worldName:worldName
//                                                                    levelType:nextLevelType
//                                                                    starCount:[NSNumber numberWithInt:0]
//                                                                    highScore:[NSNumber numberWithInt:0]
//                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
//                                                                if (error) {
//                                                                    DebugLog(@"Error updating level: %@", error.localizedDescription);
//                                                                    self.isProcessingNextLevel = NO;
//                                                                    return;
//                                                                }
//                                                                
//                                                                if (returnDict[@"error"]) {
//                                                                    DebugLog(@"Server Error updating level: %@", returnDict[@"error"]);
//                                                                    self.isProcessingNextLevel = NO;
//                                                                    return;
//                                                                }
//                                                                
//                                                                DebugLog(@"Unlocked level %@ - %@", nextworldType, nextLevelType);
//                                                                
//                                                                [self loadPlayerInfo];
//                                                                
//                                                                // Force this on the main thread for visual updating.
//                                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                                    [self updateLevelBubbles];
//                                                                    [self updateMinigameBubble];
//                                                                    self.isProcessingNextLevel = NO;
//                                                                });
//                                                            }];
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        }
        else if ([_worldType intValue]+1 < numUnlockablePlanets) {
            // If the next world is already unlocked, stop right here.
            for (NSDictionary *worldDict in [SGAppDelegate appDelegate].accountDict[@"worlds"]) { // worldsArray?
                DebugLog(@"Checking world %@", worldDict[@"type"]);
                if ([worldDict[@"type"] isEqualToNumber:[NSNumber numberWithInt:[_worldType intValue] + 2]]) { // Yes, +2 is the next world.
                    DebugLog(@"Warning: That world is already unlocked.");
                    return;
                }
            }
            
            nextworldType = [NSNumber numberWithInt:[_worldType intValue] + 2]; // Yes, +2 is the next world.
            
            NSString *worldName = [[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"];
            
            [[WebserviceManager sharedManager] updateWorldParametersWithEmail:email
                                                                     deviceId:deviceID
                                                                    worldType:nextworldType
                                                                    worldName:worldName
                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                                                                
                                                                if (error) {
                                                                    DebugLog(@"Error unlocking planet %@: %@", worldName, error.localizedDescription);
                                                                    return;
                                                                }
                                                                
                                                                if (returnDict[@"error"]) {
                                                                    DebugLog(@"Error unlocking planet %@: %@", worldName, returnDict[@"error"]);
                                                                    return;
                                                                }
                                                            }];
            
            
            
            // Unlock the free costume.
            [self checkAndUnlockFreeCostumeForWorld:[[SGFileManager fileManager] stringFromIndex:([nextworldType intValue] - 1) inFile:@"planetoids-master-list"]];
        }
        else {
            DebugLog(@"There are no more levels or planets to unlock.");
        }
    }
}

- (void)checkAndUnlockFreeCostumeForWorld:(NSString *)worldName
{
    NSString *email = [[SGAppDelegate appDelegate] fetchPlayerEmail];
    NSString *deviceID = [[SGAppDelegate appDelegate] fetchPlayerDeviceID];
    
    NSDictionary *worldDict = [[SGFileManager fileManager] loadDictionaryWithFileName:worldName OfType:@"plist"];
    if (worldDict[@"freeCostume"]) {
        NSDictionary *freeCostumeDict = worldDict[@"freeCostume"];
        //BOOL shouldBother = YES;
        
        
        NSDictionary *accountDict = [SGAppDelegate appDelegate].accountDict;
        NSArray *cookieCostumesArray = [accountDict objectForKey:@"cookieCostumes"];
        for (NSDictionary *dict in cookieCostumesArray) {
            // Check name and theme.
            if ([dict[@"name"] isEqualToString:freeCostumeDict[@"keyName"]] &&
                [dict[@"theme"] isEqualToString:freeCostumeDict[@"keyTheme"]]) {
                //DebugLog(@"Found %@ costume for %@", freeCostumeDict[@"keyTheme"], freeCostumeDict[@"keyName"]);
                if (![dict[@"isUnlocked"] boolValue]) {
                    DebugLog(@"Now unlocking the %@ costume for %@.", dict[@"theme"], dict[@"name"]);
                    NSMutableDictionary *tempDict = [dict mutableCopy];
                    [tempDict setValue:[NSNumber numberWithBool:YES] forKey:@"isUnlocked"];
                    //[tempCookieCostumesArray addObject:tempDict];
                    NSMutableArray *freeCostumeArray = [NSMutableArray arrayWithArray:@[tempDict]];
                    [[WebserviceManager sharedManager] requestToUpdateCookieCostumesWithEmail:email
                                                                                     deviceId:deviceID
                                                                               cookieCostumes:freeCostumeArray
                                                                            completionHandler:^(NSError *error, NSDictionary *returnDict) {
                        if (error) {
                            DebugLog(@"Error updating cookie costumes: %@", error.localizedDescription);
                            return;
                        }
                        if (returnDict) {
                            if (returnDict[@"account"]) {
                                if (returnDict[@"account"][@"cookieCostumes"]) {
                                    [[SGAppDelegate appDelegate].accountDict setObject:returnDict[@"account"][@"cookieCostumes"] forKey:@"cookieCostumes"];
                                    NSString *identifierName = [NSString stringWithFormat:@"IAPIdentifiers_%@%@",
                                                                freeCostumeDict[@"keyTheme"],
                                                                freeCostumeDict[@"keyName"]];
                                    //NSString *iapIdentifier = [[CDIAPManager iapMananger] valueForKey:identifierName]; // <<< Use this in the 'forKey' value below.
                                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:identifierName];
                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                    
                                    NSMutableDictionary *freeCostume = [NSMutableDictionary dictionaryWithObjectsAndKeys:freeCostumeDict[@"keyName"], @"name", freeCostumeDict[@"keyImage"], @"imageName", freeCostumeDict[@"keyTheme"], @"theme", nil];
                                    
                                    [[NSUserDefaults standardUserDefaults] setObject:freeCostume forKey:FreeCookieCostumeDictionaryDefault];
                                }
                                else {
                                    DebugLog(@"Error: No cookie costumes found in returned account when updating cookie costumes.");
                                }
                            }
                            else {
                                DebugLog(@"Error: No account returned when updating cookie costumes.");
                            }
                        }
                        else {
                            DebugLog(@"Error: No return dict when updating cookie costumes.");
                        }
                    }];
                    break;
                }
                else {
                    DebugLog(@"The %@ costume for %@ has already been unlocked.", dict[@"theme"], dict[@"name"]);
                    break;
                }
            }
        }
    }
}


- (void)mainGamePopupViewExited:(CDMainGamePopupView *)popupView Stars:(StarType)starType Score:(int)score ShouldContinue:(BOOL)shouldContinue {
    DebugLog(@"Exit endgame popup.");
    
    [popupView hidePopupAnimated:YES Completion:^(BOOL completed)
    {
        if (shouldContinue)
        {
            [_scene quit:YES];
        }
        else
        {
//            if ([_scene.parentController.levelType intValue] == 30)
//            {
//                [_scene quit:YES];
//            }
//            else
//            {
                [_scene quit:NO];
//            }
        }
    }];
}



-(void)Add_to_Score:(int)amount Piece:(CDGameBoardSpriteNode*)piece
{
    
    if(amount == 0){
        
        DebugLog(@"\n\n\t here %u , %i, %i \n\n",piece.typeID, piece.column, piece.row);
    }
    
//    [CDPlayerObject player].cumulativeScore += amount;
//    if ([CDPlayerObject player].cumulativeScore > 100000) {
//        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"master_chef" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
//            if (reportWasSuccessful) {
//                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"master_chef" InView:_scene.view Completion:nil];
//                
//                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker_apprentice" percentComplete:100.0 Completion:nil];
//                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:nil];
//            }
//        }];
//    }
//    else if ([CDPlayerObject player].cumulativeScore > 50000) {
//        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker_apprentice" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
//            if (reportWasSuccessful) {
//                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"baker_apprentice" InView:_scene.view Completion:nil];
//                
//                [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:nil];
//            }
//        }];
//    }
//    else if ([CDPlayerObject player].cumulativeScore > 10000) {
//        [[SGGameCenterManager gcManager] reportAchievementWithIdentifier:@"baker" percentComplete:100.0 Completion:^(BOOL reportWasSuccessful) {
//            if (reportWasSuccessful) {
//                [[SGGameCenterManager gcManager] displayAchievementAlertForAchievementWithIdentifier:@"baker" InView:_scene.view Completion:nil];
//            }
//        }];
//    }
    
    if(piece != nil)
        [self createScorePopupForPiece:piece score:amount];
    
    _score += amount;
    
    [_scene.milkCup setLiquidLevelTo:_score];
    
    _scene.scorelabelNode.text = [NSString stringWithFormat:@"Score: %i",_score];
    
    
//    CGPoint scenePos = [_scene convertPoint:piece.position fromNode:_gameBoard];
    
}


-(void)createScorePopupForPiece:(CDGameBoardSpriteNode*)piece score:(int)score {
    // Grab a color based on what the piece is.
    
    UIColor *pieceColor;
    float yOffset = 0.0f;
    switch (piece.typeID) {
        case COOKIE_CHIP:
            pieceColor = [UIColor colorWithRed:0.827 green:0.477 blue:0.251 alpha:1.000];
            break;
            
        case COOKIE_RED:
            pieceColor = [UIColor colorWithRed:0.970 green:0.246 blue:0.333 alpha:1.000];
            break;
            
        case COOKIE_ORANGE:
            pieceColor = [UIColor colorWithRed:0.960 green:0.424 blue:0.216 alpha:1.000];
            break;
            
        case COOKIE_YELLOW:
            pieceColor = [UIColor colorWithRed:0.989 green:0.788 blue:0.238 alpha:1.000];
            break;
            
        case COOKIE_GREEN:
            pieceColor = [UIColor colorWithRed:0.144 green:0.941 blue:0.021 alpha:1.000];
            break;
            
        case COOKIE_BLUE:
            pieceColor = [UIColor colorWithRed:0.297 green:0.576 blue:0.994 alpha:1.000];
            break;
            
        case COOKIE_PURPLE:
            pieceColor = [UIColor colorWithRed:0.676 green:0.000 blue:0.977 alpha:1.000];
            break;
            
        default:
            pieceColor = [UIColor colorWithWhite:1.000 alpha:1.000];
            yOffset += 14.0f;
            break;
    }
    
    // Create the actual popup.
    SGPopupNode *scorePopup = [[SGPopupNode alloc] initWithFontNamed:kFontDamnNoisyKids];
    scorePopup.fontSize = 20.0f;
    scorePopup.fontColor = pieceColor;
    [scorePopup setText:[NSString stringWithFormat:@"%i", score]];
    scorePopup.position = CGPointMake(piece.position.x, piece.position.y + yOffset);
    scorePopup.zPosition = 500;
    [_scene.gameBoard addChild:scorePopup];
    [scorePopup activate];
}

-(void)UpdateHUD
{
    /*
     scorelabelNode
     moveTitleLabelNode
     timerLabelNode
     moveCounterLabelNode
     targetGoalLabelNode
     */
    
    //_scene.scorelabelNode.text = [NSString stringWithFormat:@"Score: %i",_score];
    
    // Goals
    [self updateGoalInfoForLabel:_scene.targetGoalLabelNode goalType:_mainGoalType goalValue:_mainGoalValue goalItems:_mainGoalItems];
    if (_secondGoalType != _mainGoalType) {
        [self updateGoalInfoForLabel:_scene.secondGoalLabelNode goalType:_secondGoalType goalValue:_secondGoalValue goalItems:_secondGoalItems];
    }
    
    
    // limiters
    
    if(_goalLimiter == GoalLimiters_MOVE_LIMIT){
        
        _scene.limitTitleLabelNode.text = @"Moves";
        
        _scene.limiterLabelNode.fontSize = 35;
        _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%i",_limiterValue];
        
    }else if(_goalLimiter == GoalLimiters_TIME_LIMIT){
        
        _scene.limitTitleLabelNode.text = @"Time";
        
        float secondsLeft = _limiterValue;
        
        int minutes = floorf(secondsLeft/60);
        int seconds = secondsLeft - (minutes*60);
        
        _scene.limiterLabelNode.fontSize = 23;
        _scene.limiterLabelNode.text = [NSString stringWithFormat:@"%02i:%02i",minutes, seconds];
        
    }
    
}


// <<< Update Goal Info.
- (void)updateGoalInfoForLabel:(SGLabelNode *)goalLabel goalType:(GoalTypes)goalType goalValue:(int)goalValue goalItems:(NSMutableArray *)goalItems {
    if(goalType == GoalTypes_TOTALSCORE){ // I hope this is first.
        
        if(goalValue <= _score)
            goalLabel.text = [NSString stringWithFormat:@"Score Reached!"];
        else
            goalLabel.text = [NSString stringWithFormat:@"Score %i+", goalValue];
        
    }else if(goalType == GoalTypes_TYPECLEAR){
        
        DebugLog(@"Type Clear");
        
        NSString *goal = @"";
        NSString *item = @"";
        int value = 0;
        
        for (int counter = 0; counter < floor((double)[goalItems count] / 2); counter++) {
            int itemIndex = counter * 2;
            int valueIndex = itemIndex + 1;
            NSString *newItem = @"";
            
            // < Get the item name. >
            if ([goalItems[itemIndex] intValue] == 500) {
                goal = @"Break";
                newItem = @"Glass";
            }
            else {
                ItemType goalItem = (ItemType)[goalItems[itemIndex] intValue];
                if (goalItem == INGREDIENT_BANANA ||
                    goalItem == INGREDIENT_CHIPS ||
                    goalItem == INGREDIENT_EGG ||
                    goalItem == INGREDIENT_FLOUR ||
                    goalItem == INGREDIENT_SUGAR)
                {
                    goal = @"Drop";
                    newItem = @"Ingredient";
                }
            }
            
            // If there's multiple types, just call item "Things".
            if ([newItem isEqualToString:item] || [item length] <= 0) {
                item = newItem;
            }
            else {
                item = @"Item";
            }
            
            // < Get the item value. >
            value += [goalItems[valueIndex] intValue];
        }
        
        // Grammar Nazi.
        if (value > 1 && [item isEqualToString:@"Ingredient"]) {
            item = [NSString stringWithFormat:@"%@%@", item, @"s"];
        }
        
        
        
        // After the loop.
        if (value > 0) {
            if (![goal isEqualToString:@"Drop"])
            {
                goalLabel.text = [NSString stringWithFormat:@"%@ %i %@", goal, value, item];
            }
            else
            {
                goalLabel.text = [NSString stringWithFormat:@"%i %@", value, item];
            }
        }
        else if (value == 0) {
            goalLabel.text = @"COMPLETED!";
//            if ([goal isEqualToString:@"Drop"]) {
//                goalLabel.text = [NSString stringWithFormat:@"%@s Dropped!", item];
//            }
//            else if ([goal isEqualToString:@"Break"]) {
//                goalLabel.text = [NSString stringWithFormat:@"%@ Broken!", item];
//            }
        }
        else {
            goalLabel.text = [NSString stringWithFormat:@"%@ All %@", goal, item];
        }
    
        
        
        /*
         if(_mainGoalValue == -1){
         
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Remove all the types"];
         
         }else
         if(_mainGoalValue > _clearTypePoints)
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Remove %i",_mainGoalValue - _clearTypePoints];
         else
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Complete"];
         */
        
    }else if(goalType == GoalTypes_STARCOUNT){
        
        if(goalValue == 1){
            
            if(_score >= _score_bronze){
                
                goalLabel.text = [NSString stringWithFormat:@"Star Reached!"];
            }
            else
                goalLabel.text = [NSString stringWithFormat:@"Get a Bronze Star"];
            
        }else if(goalValue == 2){
            
            if(_score >= _score_silver){
                
                goalLabel.text = [NSString stringWithFormat:@"Star Reached!"];
                
            }else
                goalLabel.text = [NSString stringWithFormat:@"Get a Silver Star"];
            
            
        }else if(goalValue >= 3){
            
            if(_score >= _score_gold){
                
                goalLabel.text = [NSString stringWithFormat:@"Star Reached!"];
                
            }else
                goalLabel.text = [NSString stringWithFormat:@"Get a Gold Star"];
        }
        
    }else if(goalType == GoalTypes_INGREDIENT){
        
        DebugLog(@"Ingredient");
        
        /*
         if(_mainGoalValue == -1){
         
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Remove all ingredients"];
         
         }else
         if(_mainGoalValue > _clearTypePoints)
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Remove %i ingredients",_mainGoalValue - _clearTypePoints];
         else
         _scene.targetGoalLabelNode.text = [NSString stringWithFormat:@"Goal: Complete"];
         */
        
    }
}

#pragma mark - cookie animations calls

-(void)Player_Idle_tracking{
    
    _playerIdleSeconds--;
    
    if(_playerIdleSeconds == 0){
        
        [self Check_For_No_Possible_Combos];
        
        [self PICK_ME];
        
        _playerIdleSeconds = 3;
    }
    
}

-(void)PICK_ME{
    
    if(_possible_combo != nil)
    if(_possible_combo.count > 0){
        
        for (CDGameBoardSpriteNode* piece in _possible_combo) {
            
            [[CDCookieAnimationManager animationManager] PlayPickMeAnimation:piece];
            
        }
    }
    
}

-(void)Make_A_Random_Cookie_Do_Somthing{
    
    if(!_isTakingInput)
        return;
    //if(_playerIdleSeconds<4)
      //  return;
    
    // get a random index
    
    int index = arc4random() % _theGameGrid.count;
    
    CDGameBoardSpriteNode* piece = _theGameGrid[index];
    
    int loopCounter = 0;
    
    while (![piece isKindOfClass:[CDCookieSpriteNode class]] || piece.typeID == CLEAR_BLOCK) {
        
        loopCounter++;
        if(loopCounter >= 20)
            return;
        
        index = arc4random() % _theGameGrid.count;
        
        piece = _theGameGrid[index];
        
        if(piece.typeID == BLOCKER_COOKIEDOUGH){
            
            [_cookieDoughLord Ripple:piece];
            
            break;
        }
        
    }
    
    if(!piece.isVulnerable)
        return;
    if(piece.isHidden)
        return;
    if(piece == _scene.theSelectedPiece)
        return;
    if(piece == _scene.theOtherPiece)
        return;
    
    if(index % 2 == 1){
        [[CDCookieAnimationManager animationManager] PlayIdleAnimation:piece];
    }else{
        [[CDCookieAnimationManager animationManager] PlayCharacterAnimation:piece];
    }
    
}


#pragma mark - Inventory use methods

-(void)PowerGlove:(CDCookieSpriteNode*)cookie
{
    cookie.zPosition++;
    _isTakingInput = NO;
    
    SKSpriteNode* powerGlove = [_thePowerGlove copy];
    powerGlove.size = CGSizeMake(_columnWidth * 1.5, _RowHeight * 1.5);
    powerGlove.zPosition = cookie.zPosition+1;
    powerGlove.alpha = 0;
    
    powerGlove.position = [_scene convertPoint:cookie.position fromNode:_gameBoard];
    powerGlove.anchorPoint = CGPointMake(0.5, 0.3);
    
    SKCropNode* cropNode = [SKCropNode new];
    cropNode.position = powerGlove.position;
    cropNode.zPosition = cookie.zPosition-1;
    
    SKSpriteNode* background = [_thePowerGlove_background copy];
    background.alpha = 0;
    background.size = CGSizeMake(_columnWidth * 5, _RowHeight * 5);
    [cropNode addChild:background];
    
    SKSpriteNode *mask = [_thePowerGlove_CropMask copy];
    mask.size = background.size;
    cropNode.maskNode = mask;
    
    SKSpriteNode* shockWave = [_thePowerGlove_shockWave copy];
    shockWave.zPosition = cookie.zPosition + 2;
    shockWave.position = powerGlove.position;
    shockWave.alpha = 0;
    
    float widthCheck = _scene.size.width;
    float heightCheck = _scene.size.height;
    if(heightCheck > widthCheck){
        
        shockWave.size = CGSizeMake(heightCheck * 2, heightCheck * 2);
        
    }else{
        
        shockWave.size = CGSizeMake(widthCheck * 2, widthCheck * 2);
        
    }
    
    
    // glove small to a little bigger than tile
    
//    [_scene runAction:[SKAction sequence:@[[SKAction waitForDuration:0.15],_thePowerGlove_sound]]];
    double delayInSeconds = 0.15;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
    {
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerPunch" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    });
    
    [powerGlove runAction:[SKAction sequence:@[
                                               
                                               [SKAction scaleTo:0.1f duration:0],
                                               [SKAction fadeInWithDuration:0],
                                               [SKAction scaleTo:1 duration:0.15],
                                               [SKAction runBlock:^{
    
        [self HurtPlates:cookie Multiplier:1];
    }]
                                               
                                               ]]];
    
    [shockWave runAction:[SKAction sequence:@[
                                         
                                         [SKAction scaleTo:0.0 duration:0],
                                         [SKAction fadeInWithDuration:0],
                                         [SKAction waitForDuration:0.15],
                                         [SKAction scaleTo:1 duration:0.5]
                                         
                                         ]]];
    
    [mask runAction:[SKAction sequence:@[
                                         
                                         [SKAction scaleTo:0.225f duration:0],
                                         [SKAction runBlock:^{ background.alpha = 1; }],
                                         [SKAction waitForDuration:0.15],
                                         [SKAction scaleTo:1 duration:0.5]
                                         
                                         ]] completion:^{
        
        [self SuperSizeThatCookie:cookie];
        [self Add_to_Score:60 Piece:cookie];
        cookie.zPosition--;
        _isTakingInput = YES;
        [self UpdateHUD];
        
        [powerGlove removeFromParent];
        [shockWave removeFromParent];
        [cropNode removeFromParent];
    
    }];
    
    
    [_scene addChild:cropNode];
    [_scene addChild:powerGlove];
    [_scene addChild:shockWave];
    
    
    
}

#pragma mark - Cookie crumble methods

-(void)Cookie_Crumble
{
    
    _isTakingInput = NO;
    _score_multiplier = 1;
    
    // score values
    _score_Per_cookie = 10;
    _score_Per_super = 30;
    _score_Per_wrapped = 60;
    _score_Per_smore = 100;
    _score_Per_powerupVictim = 30;
    
    
    if(_timerNode != nil)
        [_timerNode removeAllActions];
    
    [self SetTheGameGrid];
    
    if(_SuperCookies.count > 0){
        
        NSArray* supers = [NSArray arrayWithArray:_SuperCookies];
        
        for (CDCookieSpriteNode* superCookie in supers) {
            if(arc4random() % 2 == 0)
                [self Super_Vertical:superCookie];
            else
                [self Super_Horizontal:superCookie];
        }
    }else
        if(_WrappedCookies.count > 0){
            
            NSArray* wraps = [NSArray arrayWithArray:_WrappedCookies];
            
            for (CDCookieSpriteNode* wrappedCookie in wraps) {
                [self SingleWrapper:wrappedCookie];
            }
            
            
        }else if([self Found_a_Smore]){
            
            // activated the smore
            
        }else
            if([self Found_a_SlotMachine]){
                
                // found a slotMachine
                
            }else if([self Found_a_Rad_sprinkle]){
                
                // found a sprinkle
                
            }else if(_goalLimiter == GoalLimiters_MOVE_LIMIT){
                
                if(_limiterValue > 0){
                    
                    if([self Can_make_Auto_Combo]){
                        
                        [self Add_to_Score:100 Piece:nil];
                        
                    }else{
                        
                        [self Add_to_Score:100 * _limiterValue Piece:nil];
                        
                        [self GameOver_isConditionGood:YES];
                    }
                    
                }else
                {
                    [self GameOver_isConditionGood:YES];
                }
                
                
            }else{ // not move Limit
                
                [self GameOver_isConditionGood:YES];
                
            }
    
    
}

-(void)MeteorShower
{
    _isTakingInput = NO;
    
    int movesLeft = 0;
    
    if(_timerNode != nil)
        [_timerNode removeAllActions];
    
    [self SetTheGameGrid];
    
    if(_goalLimiter == GoalLimiters_MOVE_LIMIT){
        
        if(_limiterValue > 0)
        {
            movesLeft = _limiterValue;
        }
    }
    
    
    
    if(_SuperCookies.count > 0){
        
        NSArray* supers = [NSArray arrayWithArray:_SuperCookies];
        
        for (CDCookieSpriteNode* superCookie in supers) {
            if(arc4random() % 2 == 0)
                [self Super_Vertical:superCookie];
            else
                [self Super_Horizontal:superCookie];
        }
    }else
        if(_WrappedCookies.count > 0){
            
            NSArray* wraps = [NSArray arrayWithArray:_WrappedCookies];
            
            for (CDCookieSpriteNode* wrappedCookie in wraps) {
                [self SingleWrapper:wrappedCookie];
            }
            
            
        }else if([self Found_a_Smore]){
            
            // activated the smore
            
        }else
            if([self Found_a_SlotMachine]){
                
                // found a slotMachine
                
            }else if([self Found_a_Rad_sprinkle]){
                
                // found a sprinkle
                
            }else if(_goalLimiter == GoalLimiters_MOVE_LIMIT){
                
                if(movesLeft > 0){
                    
                    int numberOfMeteors = 0;
                    NSMutableArray* spotBools = [NSMutableArray new];
                    
                    for(int i=0; i<_theGameGrid.count; i++) {
                        CDGameBoardSpriteNode* piece = _theGameGrid[i];
                        if(piece.typeID == CLEAR_BLOCK || piece.typeID == EMPTY_ITEM || piece.typeID == BLOCKER_ICECREAM || piece.typeID == BLOCKER_COOKIEDOUGH)
                            [spotBools addObject:[NSNumber numberWithInt:1]];
                        else
                            [spotBools addObject:[NSNumber numberWithInt:0]];
                    }
                    
//                    [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"MeteorL-R" withFileType:@".m4a"]];
                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"MeteorL-R" FileType:@"m4a" volume:1.0f];
                    
                    for (int i=0; i<_theGameGrid.count; i++) {
                        
                        CDGameBoardSpriteNode* piece = _theGameGrid[i];
                        if([piece isKindOfClass:[CDCookieSpriteNode class]] || [piece isKindOfClass:[CDIngredientSpriteNode class]]){// || piece.typeID == BLOCKER_ICECREAM){
                            
                            int newSpot;// = i;
                            newSpot = arc4random() % spotBools.count;
                            while ([spotBools[newSpot] intValue] == 1) {
                                
                                newSpot++;
                                
                                if (newSpot >= _theGameGrid.count) {
                                    newSpot = 0;
                                }
                            }
                            [spotBools replaceObjectAtIndex:newSpot withObject:[NSNumber numberWithInt:1]];
                            
                            piece = _theGameGrid[newSpot];
                        
                            [_powerUpVictims addObject:piece];
                            // we have our target
                            
                            // Launch the meteorite
                            {
                                
                                numberOfMeteors++;
                                
                                SKEmitterNode* ballOfFire = [_meteorite_fireball copy];
                                ballOfFire.particleSize = CGSizeMake(_cookieWidth*1.25, _cookieHeight*1.25);
                                ballOfFire.targetNode = _scene;
                                ballOfFire.particleZPosition = 4;
                                ballOfFire.position = CGPointMake(kScreenWidth + piece.position.x, kScreenHeight + piece.position.y);
                                
                                SKSpriteNode* burning_cookie = [_meteorite_cookie copy];
                                burning_cookie.zPosition = 5;
                                burning_cookie.size = CGSizeMake(_cookieWidth*0.8, _cookieHeight*0.8);
                                
                                float waitTime = (_limiterValue-movesLeft) * 0.2;
                                
                                [_scene runAction:[SKAction waitForDuration:waitTime + 0.8] completion:^{
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Meteor Explosion" FileType:@"caf" volume:1]; //@"m4a" volume:1];
                                }];
                                
                                [burning_cookie runAction:[SKAction waitForDuration:waitTime] completion:^{
                                    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"ShootingMeteor" FileType:@"caf" volume:1]; //@"m4a" volume:1];
                                }];
                                
                                [ballOfFire addChild:burning_cookie];
                                
                                [ballOfFire runAction:[SKAction sequence:@[
                                                                           [SKAction waitForDuration:waitTime],
                                                                           [SKAction moveTo:piece.position duration:1],
                                                                           [SKAction runBlock:^{
                                    ballOfFire.particleBirthRate = 0;
                                    burning_cookie.alpha = 0;
                                    
                                    
                                    //[self Put_a_milk_splash:piece.position Size:piece.size];
                                    
                                    SKEmitterNode* poof = [_meteorite_AshPoof copy];
                                    poof.position = piece.position;
                                    poof.numParticlesToEmit = 10;
                                    poof.particleZPosition = 5;
                                    poof.particleSize = ballOfFire.particleSize;
                                    poof.particleSpeed = _cookieWidth;
                                    
                                    [_gameBoard addChild:poof];
                                    
                                    [poof runAction:[SKAction waitForDuration:3] completion:^{
                                        
                                        [poof removeFromParent];
                                    }];
                                    
                                    [self Area_Effect:piece Multiplier:1];
                                    
                                    [self Add_to_Score:100 Piece:piece];
                                    
                                    _limiterValue--;
                                    
                                    [self UpdateHUD];
                                    
                                    [piece runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]]];
                                    
                                }], [SKAction waitForDuration:3],[SKAction removeFromParent]]]];
                                
                                [_gameBoard addChild:ballOfFire];
                            }
                            movesLeft--;
                        }
                        
                        if(movesLeft <= 0)
                            break;
                    }
                    
                    [self.gameBoard runAction:[SKAction waitForDuration:(numberOfMeteors * 0.2) + 2] completion:^{
                        
                        [self Powerup_deletion];
                        
                    }];
                    
                    return;
                }
                
                [self GameOver_isConditionGood:YES];
                
            }else{ // not move Limit
                
                [self GameOver_isConditionGood:YES];
                
            }

    
}

-(BOOL)Found_a_Smore
{
    for (int i=0; i<_theGameGrid.count; i++) {
        
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        if(piece.typeID == POWERUP_SMORE){
            
            int loopCounter = 0;
            BOOL isDone = NO;
            while (!isDone) {
                
                loopCounter++;
                
                if(loopCounter >= 20){
                    
                    ItemType target = COOKIE_CHIP;
                    int ranTarget = [_spawnableCookies[arc4random() % _spawnableCookies.count] intValue];
                    
                    switch (ranTarget) {
                        case COOKIE_CHIP:
                            target = COOKIE_CHIP;
                            break;
                            
                        case COOKIE_BLUE:
                            target = COOKIE_BLUE;
                            break;
                            
                        case COOKIE_GREEN:
                            target = COOKIE_GREEN;
                            break;
                            
                        case COOKIE_ORANGE:
                            target = COOKIE_ORANGE;
                            break;
                            
                        case COOKIE_PURPLE:
                            target = COOKIE_PURPLE;
                            break;
                            
                        case COOKIE_RED:
                            target = COOKIE_RED;
                            break;
                            
                        case COOKIE_YELLOW:
                            target = COOKIE_YELLOW;
                            break;
                    }
                    
                    [self SearchAndDestroy_target:target Smore:piece];
                    
                    break;
                }
                
                int which = arc4random() % 4;
                
                if(which == 0 && piece.row < _numRows-1){ // up
                    
                    CDGameBoardSpriteNode* target = _theGameGrid[((piece.row + 1) * _numColumns) + piece.column];
                    if([target isKindOfClass:[CDCookieSpriteNode class]] &&
                       target.typeID != BOOSTER_RADSPRINKLE &&
                       target.typeID != BOOSTER_SLOTMACHINE &&
                       target.typeID != POWERUP_SMORE){
                        
                        [self SearchAndDestroy_target:target.typeID Smore:piece];
                        isDone = YES;
                    }
                    
                }else if(which == 1 && piece.row > 0){ // down
                    
                    CDGameBoardSpriteNode* target = _theGameGrid[((piece.row - 1) * _numColumns) + piece.column];
                    if([target isKindOfClass:[CDCookieSpriteNode class]] &&
                       target.typeID != BOOSTER_RADSPRINKLE &&
                       target.typeID != BOOSTER_SLOTMACHINE &&
                       target.typeID != POWERUP_SMORE){
                        
                        [self SearchAndDestroy_target:target.typeID Smore:piece];
                        isDone = YES;
                    }
                }else if(which == 2 && piece.column > 0){ // left
                    
                    CDGameBoardSpriteNode* target = _theGameGrid[(piece.row * _numColumns) + (piece.column - 1)];
                    if([target isKindOfClass:[CDCookieSpriteNode class]] &&
                       target.typeID != BOOSTER_RADSPRINKLE &&
                       target.typeID != BOOSTER_SLOTMACHINE &&
                       target.typeID != POWERUP_SMORE){
                        
                        [self SearchAndDestroy_target:target.typeID Smore:piece];
                        isDone = YES;
                    }
                }else if(which == 3 && piece.column < _numColumns-1){ // right
                    
                    CDGameBoardSpriteNode* target = _theGameGrid[(piece.row * _numColumns) + (piece.column + 1)];
                    if([target isKindOfClass:[CDCookieSpriteNode class]] &&
                       target.typeID != BOOSTER_RADSPRINKLE &&
                       target.typeID != BOOSTER_SLOTMACHINE &&
                       target.typeID != POWERUP_SMORE){
                        
                        [self SearchAndDestroy_target:target.typeID Smore:piece];
                        isDone = YES;
                    }
                }
            }
            
            return YES;
            
            break;
        }
    }
    
    return NO;
}

-(BOOL)Found_a_SlotMachine
{
    
    for (int i=0; i<_theGameGrid.count; i++) {
        
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        if(piece.typeID == BOOSTER_SLOTMACHINE){
            
            [self StopThatSlotCookie:(CDCookieSpriteNode*)piece];
            
            return YES;
            
            break;
        }
    }
    
    return NO;
}

-(BOOL)Found_a_Rad_sprinkle
{
    for (int i=0; i<_theGameGrid.count; i++) {
        
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        if(piece.typeID == BOOSTER_RADSPRINKLE){
            
            
            if(piece.column <= _numColumns*0.5 && piece.row <= _numRows*0.5){
                
                if(arc4random()%2 == 0){
                    CDGameBoardSpriteNode* otherPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column + 1)];
                    [[CDCookieAnimationManager animationManager] Radiate_right:piece OtherPiece:otherPiece];
                    //[self Radiate_right:piece OtherPiece:otherPiece];
                }else
                {
                    CDGameBoardSpriteNode* otherPiece = _theGameGrid[((piece.row+1) * _numColumns) + piece.column];
                    [[CDCookieAnimationManager animationManager] Radiate_up:piece OtherPiece:otherPiece];
                    //[self Radiate_up:piece OtherPiece:otherPiece];
                }
                
            }else
                if(piece.column <= _numColumns*0.5 && piece.row >= _numRows*0.5){
                    
                    if(arc4random()%2 == 0){
                        CDGameBoardSpriteNode* otherPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column + 1)];
                        [[CDCookieAnimationManager animationManager] Radiate_right:piece OtherPiece:otherPiece];
                        //[self Radiate_right:piece OtherPiece:otherPiece];
                    }else
                    {
                        CDGameBoardSpriteNode* otherPiece = _theGameGrid[((piece.row-1) * _numColumns) + piece.column];
                        [[CDCookieAnimationManager animationManager] Radiate_down:piece OtherPiece:otherPiece];
                        //[self Radiate_down:piece OtherPiece:otherPiece];
                    }
                }else
                    if(piece.column >= _numColumns*0.5 && piece.row >= _numRows*0.5){
                        
                        if(arc4random()%2 == 0){
                            CDGameBoardSpriteNode* otherPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column - 1)];
                            [[CDCookieAnimationManager animationManager] Radiate_left:piece OtherPiece:otherPiece];
                            //[self Radiate_left:piece OtherPiece:otherPiece];
                        }else
                        {
                            CDGameBoardSpriteNode* otherPiece = _theGameGrid[((piece.row-1) * _numColumns) + piece.column];
                            [[CDCookieAnimationManager animationManager] Radiate_down:piece OtherPiece:otherPiece];
                            //[self Radiate_down:piece OtherPiece:otherPiece];
                        }
                    }else
                        if(piece.column >= _numColumns*0.5 && piece.row <= _numRows*0.5){
                            
                            if(arc4random()%2 == 0){
                                CDGameBoardSpriteNode* otherPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column - 1)];
                                [[CDCookieAnimationManager animationManager] Radiate_left:piece OtherPiece:otherPiece];
                                //[self Radiate_left:piece OtherPiece:otherPiece];
                            }else
                            {
                                CDGameBoardSpriteNode* otherPiece = _theGameGrid[((piece.row+1) * _numColumns) + piece.column];
                                [[CDCookieAnimationManager animationManager] Radiate_up:piece OtherPiece:otherPiece];
                                //[self Radiate_up:piece OtherPiece:otherPiece];
                            }
                        }
            
            
            
            return YES;
            
            break;
        }
    }
    
    return NO;
}

-(BOOL)Can_make_Auto_Combo{
    
    [self SetTheGameGrid];
    
    for(int i=0; i<_theGameGrid.count; i++)
    {
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        
        if([piece isKindOfClass:[CDCookieSpriteNode class]])
            if([self Is_there_an_auto_Combo_Here:piece]){
                return YES;
                break;
            }
    }
    
    return NO;
}

-(BOOL)Is_there_an_auto_Combo_Here:(CDGameBoardSpriteNode*)piece{
    
    if(piece.isLocked)
        return NO;
    
    if(piece.typeID == POWERUP_SMORE || piece.typeID == BOOSTER_SLOTMACHINE || piece.typeID == BOOSTER_RADSPRINKLE){
        
        return NO;
    }
    
    int numberOf_Reds = 0;
    int numberOf_Blues = 0;
    int numberOf_Greens = 0;
    int numberOf_Oranges = 0;
    int numberOf_Purples = 0;
    int numberOf_Yellows = 0;
    int numberOf_Browns = 0;
    
    
    // look up, down, left, right
    CDGameBoardSpriteNode* upPiece;CDGameBoardSpriteNode* downPiece;
    CDGameBoardSpriteNode* leftPiece;CDGameBoardSpriteNode* rightPiece;
    
    
    if(piece.row < _numRows-1)
        upPiece = _theGameGrid[((piece.row+1) * _numColumns) + piece.column];
    if(piece.row > 0)
        downPiece = _theGameGrid[((piece.row-1) * _numColumns) + piece.column];
    if(piece.column > 0)
        leftPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column-1)];
    if(piece.column < _numColumns-1)
        rightPiece = _theGameGrid[(piece.row * _numColumns) + (piece.column+1)];
    
    // check there types
    
    if(upPiece){
        int type = upPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
    }
    
    if(downPiece){
        int type = downPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
        
    }
    if(leftPiece){
        int type = leftPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
        
    }
    if(rightPiece){
        int type = rightPiece.typeID;
        switch (type) {
            case COOKIE_RED:
                numberOf_Reds++;
                break;
            case COOKIE_BLUE:
                numberOf_Blues++;
                break;
            case COOKIE_GREEN:
                numberOf_Greens++;
                break;
            case COOKIE_YELLOW:
                numberOf_Yellows++;
                break;
            case COOKIE_ORANGE:
                numberOf_Oranges++;
                break;
            case COOKIE_CHIP:
                numberOf_Browns++;
                break;
            case COOKIE_PURPLE:
                numberOf_Purples++;
                break;
        }
    }
    
    // check the numbers
    NSMutableArray* types_to_check_for = [NSMutableArray new];
    
    if(numberOf_Blues >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_BLUE]];
    }
    if(numberOf_Browns >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_CHIP]];
    }
    if(numberOf_Greens >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_GREEN]];
    }
    if(numberOf_Oranges >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_ORANGE]];
    }
    if(numberOf_Purples >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_PURPLE]];
    }
    if(numberOf_Reds >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_RED]];
    }
    if(numberOf_Yellows >= 2){
        [types_to_check_for addObject:[NSNumber numberWithInt:COOKIE_YELLOW]];
    }
    
    // check for possible combos
    
    if(types_to_check_for.count > 0)
        for (int i=0; i<types_to_check_for.count; i++) {
            
            int type = [types_to_check_for[i] intValue];
            NSMutableArray* pieces_up = [NSMutableArray new];
            NSMutableArray* pieces_down = [NSMutableArray new];
            NSMutableArray* pieces_left = [NSMutableArray new];
            NSMutableArray* pieces_right = [NSMutableArray new];
            
            if(upPiece){
                
                int checkType = upPiece.typeID;
                if(checkType == type){
                    
                    [pieces_up addObject:upPiece];
                    
                    
                    for(int row = upPiece.row+1; row<_numRows; row++)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(row * _numColumns) + piece.column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_up addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
            if(downPiece){
                
                int checkType = downPiece.typeID;
                if(checkType == type){
                    
                    [pieces_down addObject:downPiece];
                    
                    for(int row = downPiece.row-1; row >= 0; row--)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(row * _numColumns) + piece.column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_down addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
            
            if(leftPiece){
                
                int checkType = leftPiece.typeID;
                if(checkType == type){
                    
                    [pieces_left addObject:leftPiece];
                    
                    for(int column = leftPiece.column-1; column >= 0; column--)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(piece.row * _numColumns) + column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_left addObject:nextPiece];
                        else
                            break;
                    }
                }
            }
            
            
            if(rightPiece){
                
                int checkType = rightPiece.typeID;
                if(checkType == type){
                    
                    [pieces_right addObject:rightPiece];
                    
                    for(int column = rightPiece.column+1; column < _numColumns; column++)
                    {
                        CDGameBoardSpriteNode* nextPiece = _theGameGrid[(piece.row * _numColumns) + column];
                        
                        int checkType2 = nextPiece.typeID;
                        if(checkType2 == type)
                            [pieces_right addObject:nextPiece];
                        else
                            break;
                    }
                    
                }
            }
            
            // check how many was found
            
            /*
             order
             
             up right down
             up right left
             up down left
             right down left
             
            */
            
            if(pieces_up.count > 0 && pieces_right.count > 0 && pieces_down.count > 0)  // up right down
                if(!rightPiece.isLocked){
                    [self AfterMathSwap:piece Piece2:rightPiece];
                    return YES;
                }
            if(pieces_up.count > 0 && pieces_right.count > 0 && pieces_left.count > 0)  // up right left
                if(!upPiece.isLocked){
                    [self AfterMathSwap:piece Piece2:upPiece];
                    return YES;
                }
            if(pieces_up.count > 0 && pieces_down.count > 0 && pieces_left.count > 0)  // up down left
                if(!leftPiece.isLocked){
                    [self AfterMathSwap:piece Piece2:leftPiece];
                    return YES;
                }
            if(pieces_right.count > 0 && pieces_down.count > 0 && pieces_left.count > 0)  // right down left
                if(!downPiece.isLocked){
                    [self AfterMathSwap:piece Piece2:downPiece];
                    return YES;
                }
            
            /* order
             
             up down
             up right
             up left
             
             right left
             right down
             
             down left
             
             */
            
            if(pieces_up.count + pieces_down.count >= 3){  // up down
                
                if(upPiece.isLocked && downPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_down.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:upPiece];
                    
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_up.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:downPiece];
                    
                    return YES;
                }
            }
            
            if(pieces_up.count + pieces_right.count >= 3){  // up right
                
                if(upPiece.isLocked && rightPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_right.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:upPiece];
                    
                    return YES;
                    
                }else if(!rightPiece.isLocked && pieces_up.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:rightPiece];
                    
                    return YES;
                }
            }
            
            if(pieces_up.count + pieces_left.count >= 3){  // up left
                
                if(upPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!upPiece.isLocked && pieces_left.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:upPiece];
                    
                    return YES;
                    
                }else if(!leftPiece.isLocked && pieces_up.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:leftPiece];
                    
                    return YES;
                }
            }
            
            if(pieces_right.count + pieces_left.count >= 3){  // right left
                
                if(rightPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!rightPiece.isLocked && pieces_left.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:rightPiece];
                    
                    return YES;
                    
                }else if(!leftPiece.isLocked && pieces_right.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:leftPiece];
                    
                    return YES;
                }
            }
            
            if(pieces_right.count + pieces_down.count >= 3){  // right down
                
                if(rightPiece.isLocked && downPiece.isLocked){
                    
                }else if(!rightPiece.isLocked && pieces_down.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:rightPiece];
                    
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_right.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:downPiece];
                    
                    return YES;
                }
            }
            
            if(pieces_down.count + pieces_left.count >= 3){  // down left
                
                if(downPiece.isLocked && leftPiece.isLocked){
                    
                }else if(!leftPiece.isLocked && pieces_down.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:leftPiece];
                    
                    return YES;
                    
                }else if(!downPiece.isLocked && pieces_left.count > 1){
                    
                    [self AfterMathSwap:piece Piece2:downPiece];
                    
                    return YES;
                }
            }
        }
    
    return NO;
}

-(void)AfterMathSwap:(CDGameBoardSpriteNode*)piece1 Piece2:(CDGameBoardSpriteNode*)piece2{
    
    
    _scene.theSelectedPiece = piece1;
    _scene.theOtherPiece = piece2;
    
    //switch
    
    CGPoint newPoint1 = piece1.position;
    float row1 = piece1.row;
    float column1 = piece1.column;
    
    CGPoint newPoint2 = piece2.position;
    float row2 = piece2.row;
    float column2 = piece2.column;
    
    piece1.row = row2;
    piece1.column = column2;
    
    piece2.row = row1;
    piece2.column = column1;
    
    [piece1 removeAllActions];
    [piece2 removeAllActions];
    
    [self PlaySwitchAnimation:piece1];
    [self PlaySwitchAnimation:piece2];
    
    [piece1 runAction:[SKAction moveTo:newPoint2 duration:0.25] completion:^{
        
        piece1.position = newPoint2;
        
    }];
    [piece2 runAction:[SKAction moveTo:newPoint1 duration:0.25] completion:^{
        
        piece2.position = newPoint1;
        
    }];
    
    [_scene runAction:[SKAction waitForDuration:0.1] completion:^{
        
        [self Play_swipe_sound];
        
    }];
    
    [_scene runAction:[SKAction waitForDuration:0.5] completion:^{
        
        // this is where it needs to handle the rest of this method
        
        [self SetTheGameGrid];
        
        [self checkSwap:piece1 secondPiece:piece2];
    }];
    
    
}

#pragma mark - END Test Area New Board Pieces

#pragma mark - Asset Loading

- (void)loadAssets
{
    
    // Textures
    
    if(_cookieTextures.count == 0){
        
        self.smoreTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-smores%@",_deviceModel]];
        
        self.lockSprite = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-jail%@",_deviceModel]];
        
        self.radioactiveSprinkleTexture = [SKTexture textureWithImageNamed:@"cdd-boardpiece-radioactive-can@2x"];
        
        [self loadPowerGlove];
        [self loadSpatula];
        [self loadCookieTextures];
        [self loadWrappers];
        [self loadIngredientTextures];
        [self loadSlotSlides];
        [self loadLightning];
        [self loadMilkStream];
        [[CDCookieAnimationManager animationManager] loadCookieAnimations];
        [self loadIcecream];
        [self loadNuke];
        [self loadPlateTextures];
        [self loadSounds];
        [self loadSwirlFrames];
        [self loadBombStuff];
        
        self.thePortal = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-vortex%@",_deviceModel]];
        self.thePortal_rays = [SKSpriteNode spriteNodeWithImageNamed:@"particle-main-rays"];
        
        [self loadParticles];
        
        [self loadMeteorite];
    }
    
    [[CDCookieAnimationManager animationManager] SetupSuperLooks];
    
}

- (void)loadParticles {
    
    // Cookie Deletion
    
    _shockwaveParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"ShockwaveParticle"];
    
    _milkSplatParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"MilkSplatParticle"];
    
    _cookieGibletsParticle01 = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"CookieGibletsParticle-01"];
    
    _cookieGibletsParticle02 = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"CookieGibletsParticle-02"];
    
    _cookieGibletsParticle03 = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"CookieGibletsParticle-03"];
    
    _milkDropsParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"MilkDropsParticle"];
    
    
    // Supers
    
    _superShockwaveParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"SuperSpawn_Shockwave"];
    
    _superBoomParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"SuperSpawn_Boom"];
    
    
    
    _smokeParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"SmokeParticle"];
    
    _nukeCloudFireParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeCloudFireParticle"];
    
    _nukeCollumnFireParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeCollumnFireParticle"];
    
    _nukeShockwaveParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"NukeShockwaveParticle"];
    
    _ashParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"AshParticle"];
    
    _Lightning_Sparks = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"LightningSparks"];
    
    _Lightning_Sparks.particleTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"particle-lightning-spark%@",_deviceModel]];
    
    _portalSparkles = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"Portal_Sparkles"];
    
    _portalSparkles.particleTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"particle-sparkle%@",_deviceModel]];
    
    _glassParticle = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"Glass"];
    
    _glassParticle.particleTexture = [SKTexture textureWithImageNamed:@"cdd-boardpiece-glasscase-shard@2x"];
    
    _lockBreak_1 = [_cookieGibletsParticle02 copy];
    _lockBreak_1.particleTexture = [SKTexture textureWithImageNamed:@"cdd-particle-jail@2x"];
    
    _lockBreak_2 = [_cookieGibletsParticle02 copy];
    _lockBreak_2.particleTexture = [SKTexture textureWithImageNamed:@"cdd-particle-jail02@2x"];
    
    _lockBreak_3 = [_cookieGibletsParticle02 copy];
    _lockBreak_3.particleTexture = [SKTexture textureWithImageNamed:@"cdd-particle-jail03@2x"];
    
    //_lockBreak_2;
    //_lockBreak_3;
    
    
}

- (void)loadCookieTextures {
    
    self.cookieTextures = @[
                         
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-jj1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-reginald1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-luke1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-dustin1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-mikey1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-gerry1%@",_deviceModel]],
                           [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cookie-chip1%@",_deviceModel]]
                            
                            ];
}

- (void)loadIngredientTextures{
    
    _ingredientTextures = @[
                            
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-egg%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:@"cdd-main-board-item-banana"],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-chocchip%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:@"cdd-main-board-item-flour"],
                            [SKTexture textureWithImageNamed:@"cdd-main-board-item-sugar"]
                            
                            ];
    
}
-(void)loadPlateTextures{
    
    _plateTextures = @[
 
                       [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-boardpiece-glasscase-cracks%@",_deviceModel]],
                       [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-boardpiece-glasscase%@",_deviceModel]],
                       [SKTexture textureWithImageNamed:@"cdd-boardpiece-glasscaseb@2x"]
                       
                       ];
    
    
}

-(void)loadLightning{
    
    self.LightningCropNode = [SKCropNode new];
    self.LightningCropMask = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:CGSizeMake(0.0, 0.0)];
    
    NSArray* frames = @[
                        
                        [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-particle-lightning-rod-1%@",_deviceModel]],
                        [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-particle-lightning-rod-2%@",_deviceModel]],
                        [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-particle-lightning-rod-3%@",_deviceModel]]
                        
                        ];
    
    self.Lightning = [SKSpriteNode spriteNodeWithTexture:frames[0]];
    
    self.LightningAction = [SKAction group:@[[SKAction repeatAction:[SKAction animateWithTextures:frames timePerFrame:0.08]count:30],
                                             [SKAction sequence:@[
                                                                  [SKAction moveByX:0 y:_scene.size.height duration:10],
                                                                  [SKAction moveByX:0 y:-_scene.size.height duration:0]]]]];
    
    self.LightningBackFlashes = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-lightning%@",_deviceModel]];
    self.LightningBackFlashingAction = [SKAction repeatAction:[SKAction sequence:@[
                                                                                   
                                                                                   [SKAction fadeOutWithDuration:0.4],
                                                                                   [SKAction scaleXTo:-1 duration:0],
                                                                                   
                                                                                   [SKAction waitForDuration:0.15],
                                                                                   [SKAction fadeInWithDuration:0],
                                                                                   
                                                                                   [SKAction fadeOutWithDuration:0.4],
                                                                                   [SKAction scaleXTo:1 duration:0],
                                                                                   [SKAction scaleYTo:-1 duration:0],
                                                                                   
                                                                                   [SKAction waitForDuration:0.15],
                                                                                   [SKAction fadeInWithDuration:0],
                                                                                   
                                                                                   [SKAction fadeOutWithDuration:0.4],
                                                                                   [SKAction scaleXTo:-1 duration:0],
                                                                                   
                                                                                   [SKAction waitForDuration:0.15],
                                                                                   [SKAction fadeInWithDuration:0],
                                                                                   
                                                                                   [SKAction fadeOutWithDuration:0.4],
                                                                                   [SKAction scaleXTo:1 duration:0],
                                                                                   [SKAction scaleYTo:1 duration:0],
                                                                                   
                                                                                   [SKAction waitForDuration:0.15],
                                                                                   [SKAction fadeInWithDuration:0],
                                                                                   
                                                                                   ]]
                                                        count:30];
    
    
    
    _LightningCookieBack = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-blurred-circle%@",_deviceModel]];
    
    _LightningCookieFront = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-cookie-lightning%@",_deviceModel]];
    
    _LightningCookieFrontAction = [SKAction repeatAction:[SKAction sequence:@[
                                                                              
                                                                              [SKAction fadeOutWithDuration:0.4],
                                                                              [SKAction scaleXTo:-1 duration:0],
                                                                              
                                                                              [SKAction fadeInWithDuration:0],
                                                                              
                                                                              [SKAction fadeOutWithDuration:0.4],
                                                                              [SKAction scaleXTo:1 duration:0],
                                                                              [SKAction scaleYTo:-1 duration:0],
                                                                              
                                                                              [SKAction fadeInWithDuration:0],
                                                                              
                                                                              [SKAction fadeOutWithDuration:0.4],
                                                                              [SKAction scaleXTo:-1 duration:0],
                                                                              
                                                                              [SKAction fadeInWithDuration:0],
                                                                              
                                                                              [SKAction fadeOutWithDuration:0.4],
                                                                              [SKAction scaleXTo:1 duration:0],
                                                                              [SKAction scaleYTo:1 duration:0],
                                                                              
                                                                              [SKAction fadeInWithDuration:0],
                                                                              
                                                                              ]]
                                                   count:30];
    
}

-(void)loadSlotSlides{
    
//    self.slotDing = [SGAudioManager MakeSoundEffectAction:@"SlotDing" withFileType:@".m4a"];
    
    self.slotmachineSlides = @[

                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-smores%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-lightning%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-bomb%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-spatula%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-super%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-sprinkles%@",_deviceModel]],
                               
                               [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-wrapped%@",_deviceModel]]
                               
                               ];
}

-(void)loadMilkStream{
    
    SKTexture* texture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"particle-milk-stream%@",_deviceModel]];
    
    _milkstream = [SKSpriteNode spriteNodeWithTexture:texture];
    
    SKTexture* largeTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-particle-large-milk-stream%@",_deviceModel]];
    
    _wrappedMilkstream = [SKSpriteNode spriteNodeWithTexture:largeTexture];
    
    _milkstreamAction = [SKAction repeatAction:[SKAction sequence:@[[SKAction moveBy:CGVectorMake(0, _scene.size.height) duration:1],
                                                                    [SKAction moveBy:CGVectorMake(0, -_scene.size.height) duration:0]]] count:10];
    
}

-(void)loadSounds{
    
    _whichSwipeSound = 1;
//    _SwipeSounds = @[
//                     
//                     [SGAudioManager MakeSoundEffectAction:@"Swoosh 1" withFileType:@".m4a"],
//                     [SGAudioManager MakeSoundEffectAction:@"Swoosh 2" withFileType:@".m4a"],
//                     [SGAudioManager MakeSoundEffectAction:@"Swoosh 3" withFileType:@".m4a"],
//                     [SGAudioManager MakeSoundEffectAction:@"Swoosh 4" withFileType:@".m4a"]
//                     
//                     ];
    
//    _crunchSoundsArray = @[
//                           [SGAudioManager MakeSoundEffectAction:@"Crunch 7" withFileType:@".m4a"],
//                           [SGAudioManager MakeSoundEffectAction:@"Crunch 8" withFileType:@".m4a"],
//                           [SGAudioManager MakeSoundEffectAction:@"Crunch 5" withFileType:@".m4a"],
//                           //[SGAudioManager MakeSoundEffectAction:@"Crunch 2" withFileType:@".m4a"]
//                           ];
    
    _splatSoundsArray = @[
      
//      [SKAction playSoundFileNamed:@"MilkyHit1.m4a" waitForCompletion:NO],
//      [SKAction playSoundFileNamed:@"MilkyHit2.m4a" waitForCompletion:NO],
//      [SKAction playSoundFileNamed:@"MilkyHit3.m4a" waitForCompletion:NO]
      
      [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"MilkyHit1" FileType:@"caf"];}],
      [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"MilkyHit2" FileType:@"caf"];}],
      [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"MilkyHit3" FileType:@"caf"];}]
      
      ];
    
    //_wrapSound = [SKAction playSoundFileNamed:@"CookieWrap.m4a" waitForCompletion:NO];
    _wrapSound = [SKAction runBlock:^{[[SGAudioManager audioManager] playSoundEffectWithFilename:@"CookieWrap" FileType:@"caf"];}];
    
//    _PowerCrunch = [SGAudioManager MakeSoundEffectAction:@"PowerCrunch Swipe 1" withFileType:@".m4a"];
    
    
}


-(void)loadPowerGlove
{
    
    _thePowerGlove = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-powerup-effect-glove-icon%@",_deviceModel]];
    _thePowerGlove_CropMask = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-powerup-effect-explosion-graphic%@",_deviceModel]];
    _thePowerGlove_background = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-powerup-effect-dot-background%@",_deviceModel]];
    _thePowerGlove_shockWave =[SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-shock-wave%@",_deviceModel]];
    
//    _thePowerGlove_sound = [SGAudioManager MakeSoundEffectAction:@"PowerPunch" withFileType:@".m4a"];
}

-(void)loadSpatula
{
    
        _theSpatula = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-spatula%@",_deviceModel]];
        _theSpatula_Portal_in = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-spatula-arrows%@",_deviceModel]];
        _theSpatula_Portal_out = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-particle-spatula-arrows-reversed%@",_deviceModel]];
    
//    _theSpatula_sound = [SGAudioManager MakeSoundEffectAction:@"SuperSpatula" withFileType:@".m4a"];
    
    if(!IS_RETINA){
        [_theSpatula runAction:[SKAction scaleTo:0.5 duration:0]];
        [_theSpatula_Portal_in runAction:[SKAction scaleTo:0.5 duration:0]];
        [_theSpatula_Portal_out runAction:[SKAction scaleTo:0.5 duration:0]];
    }
}

-(void)loadIcecream
{
    _icreamTextures = @[
                
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-icecream"],
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-sundae-1"],
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-sundae-2"],
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-sundae-3"],
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-sundae-4"],
                        [SKTexture textureWithImageNamed:@"cdd-boardpiece-sundae-5"]
                        
                        ];
    
}

-(void)loadNuke
{
    // cdd-nuke0001
    
    DebugLog(@"loadNuke");

    NSArray* frames = @[
                        [SKTexture textureWithImageNamed:@"cdd-nuke0000"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0001"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0002"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0003"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0004"],
                        
                        [SKTexture textureWithImageNamed:@"cdd-nuke0005"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0006"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0007"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0008"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0009"],
                        
                        [SKTexture textureWithImageNamed:@"cdd-nuke0010"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0011"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0012"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0013"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0014"],
                        
                        [SKTexture textureWithImageNamed:@"cdd-nuke0015"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0016"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0017"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0018"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0019"],
                        
                        [SKTexture textureWithImageNamed:@"cdd-nuke0020"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0021"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0022"],
                        [SKTexture textureWithImageNamed:@"cdd-nuke0023"]
                        ];
    
    
    _nuke_Node = [SKSpriteNode spriteNodeWithTexture:frames[0]];
    
    _nuke_Node.anchorPoint = CGPointMake(0.475, 0);
    
    _nuke_falling_Node = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cdd-main-board-item-bomb%@",_deviceModel]];
    
    _nuke_animation = [SKAction animateWithTextures:frames timePerFrame:0.05f];
    
    _nuke_shockwave = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"nuke-shock-wave"]];
    
    SKTexture* texture = frames[0];
    
    _nuke_size = texture.size;
    
//    _nuke_Sound = [SGAudioManager MakeSoundEffectAction:@"AtomicBomb" withFileType:@".m4a"];

}

-(void)loadMeteorite
{
    _meteorite_fireball = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"Metorite_FireParticle"];
    _meteorite_AshPoof = [SKEmitterNode cdd_emiterNodeWithEmitterNamed:@"Metorite_Ash_Burst_Particle"];
    _meteorite_cookie = [SKSpriteNode spriteNodeWithImageNamed:[NSString stringWithFormat:@"cookieFace03%@",_deviceModel]];

    
//    _meteorite_Shooting_sound = [SGAudioManager MakeSoundEffectAction:@"ShootingMeteor" withFileType:@".m4a"];
//    
//    _meteorite_impact_sound = [SGAudioManager MakeSoundEffectAction:@"Meteor Explosion" withFileType:@".m4a"];

}

-(void)loadSwirlFrames
{
    
    self.pretzelTextures = @[
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm1%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm2%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm3%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm4%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm5%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm6%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm7%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm8%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-alien-gameboard-gummyworm9%@",_deviceModel]]
                             ];
    
}

-(void)loadBombStuff
{
    _bombTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bombs-greyscale-base%@", _deviceModel]];
    _bombShineTexture = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bombs-greyscale-poplight%@", _deviceModel]];
    
    _bombSpark = [SKAction repeatActionForever:[SKAction animateWithTextures:@[
                                                                               
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bombs-whick1%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bombs-whick2%@",_deviceModel]],
                             [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bombs-whick3%@",_deviceModel]]
                             
                             ] timePerFrame: 0.08f]];
    
    _bombSplode = [SKAction repeatActionForever:[SKAction animateWithTextures:@[
                                                                               
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete1%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete2%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete3%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete4%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete5%@",_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"cdd-main-bomb-delete6%@",_deviceModel]]
                                                                               
                            ] timePerFrame: 0.08f]];
    
}

#pragma mark - Cookie Custom stuff
/*
-(void)SetupSuperLooks{
    
    NSString* planetDefault = @"";
    
    if([_what_planet_am_I_on isEqualToString:@"Milkywa-ie Mountain"]){
        planetDefault = @"milkyway";
    }else
        if([_what_planet_am_I_on isEqualToString:@"Dunkopolis"]){
            planetDefault = @"dunkopolis";
        }else{
            planetDefault =  @"milkyway";
        }
    
    NSMutableArray *selectedSuperCookieCostumes = [self selectedCookieCostumes];
    
    // supers
    
    NSString* chipPref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].brownSuperLooks isEqualToString:@"default"]){
        chipPref = planetDefault;
    }else
        chipPref = [SGPlayerPreferencesManager preferenceManager].brownSuperLooks;
    
    NSArray* chipFrames = @[
                          
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side1%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side2%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side3%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side4%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side5%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side6%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side7%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side8%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side9%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side10%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side11%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side12%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side13%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-side14%@",chipPref,_deviceModel]],
                            
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up1%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up2%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up3%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up4%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up5%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up6%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up7%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up8%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up9%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up10%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up11%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up12%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up13%@",chipPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-chip-up14%@",chipPref,_deviceModel]]
                            
                            ];
    
    SKTexture* runSize = chipFrames[0];
    SKTexture* flySize = chipFrames[20];
    
    _superRunSize = runSize.size;
    _superFlySize = flySize.size;
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   chipFrames[0],
                                   chipFrames[1],
                                   chipFrames[2],
                                   chipFrames[3],
                                   chipFrames[4],
                                   chipFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             chipFrames[6],
                             chipFrames[7],
                             chipFrames[8],
                             chipFrames[9],
                             chipFrames[10],
                             chipFrames[11],
                             chipFrames[12],
                             chipFrames[13]
                             
                             ];
        
        _chip_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                    [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   chipFrames[14],
                                   chipFrames[15],
                                   chipFrames[16],
                                   chipFrames[17],
                                   chipFrames[18],
                                   chipFrames[19],
                                   chipFrames[20],
                                   chipFrames[21],
                                   chipFrames[22],
                                   chipFrames[23],
                                   chipFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             chipFrames[25],
                             chipFrames[26],
                             chipFrames[27]
                             
                             ];
        
        _chip_Animation_hero_fly= [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                        [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
    
    }

    
    NSString* dustinPref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].greenSuperLooks isEqualToString:@"default"]){
        dustinPref = planetDefault;
    }else
        dustinPref = [SGPlayerPreferencesManager preferenceManager].greenSuperLooks;

    NSArray* dustinFrames = @[
                            
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side1%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side2%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side3%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side4%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side5%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side6%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side7%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side8%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side9%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side10%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side11%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side12%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side13%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-side14%@",dustinPref,_deviceModel]],
                            
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up1%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up2%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up3%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up4%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up5%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up6%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up7%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up8%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up9%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up10%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up11%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up12%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up13%@",dustinPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-dustin-up14%@",dustinPref,_deviceModel]]
                            
                            ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   dustinFrames[0],
                                   dustinFrames[1],
                                   dustinFrames[2],
                                   dustinFrames[3],
                                   dustinFrames[4],
                                   dustinFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             dustinFrames[6],
                             dustinFrames[7],
                             dustinFrames[8],
                             dustinFrames[9],
                             dustinFrames[10],
                             dustinFrames[11],
                             dustinFrames[12],
                             dustinFrames[13]
                             
                             ];
        
        _dustin_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                        [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   dustinFrames[14],
                                   dustinFrames[15],
                                   dustinFrames[16],
                                   dustinFrames[17],
                                   dustinFrames[18],
                                   dustinFrames[19],
                                   dustinFrames[20],
                                   dustinFrames[21],
                                   dustinFrames[22],
                                   dustinFrames[23],
                                   dustinFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             dustinFrames[25],
                             dustinFrames[26],
                             dustinFrames[27]
                             
                             ];
        
        _dustin_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                        [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }

    NSString* jjPref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].redSuperLooks isEqualToString:@"default"]){
        jjPref = planetDefault;
    }else
        jjPref = [SGPlayerPreferencesManager preferenceManager].redSuperLooks;
    
    NSArray* jjFrames = @[
            
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side1%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side2%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side3%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side4%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side5%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side6%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side7%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side8%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side9%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side10%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side11%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side12%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side13%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-side14%@",jjPref,_deviceModel]],
                              
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up1%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up2%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up3%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up4%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up5%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up6%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up7%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up8%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up9%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up10%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up11%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up12%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up13%@",jjPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-jj-up14%@",jjPref,_deviceModel]]
                              
                              ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   jjFrames[0],
                                   jjFrames[1],
                                   jjFrames[2],
                                   jjFrames[3],
                                   jjFrames[4],
                                   jjFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             jjFrames[6],
                             jjFrames[7],
                             jjFrames[8],
                             jjFrames[9],
                             jjFrames[10],
                             jjFrames[11],
                             jjFrames[12],
                             jjFrames[13]
                             
                             ];
        
        _jj_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                          [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   jjFrames[14],
                                   jjFrames[15],
                                   jjFrames[16],
                                   jjFrames[17],
                                   jjFrames[18],
                                   jjFrames[19],
                                   jjFrames[20],
                                   jjFrames[21],
                                   jjFrames[22],
                                   jjFrames[23],
                                   jjFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             jjFrames[25],
                             jjFrames[26],
                             jjFrames[27]
                             
                             ];
        
        _jj_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                          [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }
    
    NSString* reginaldPref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].orangeSuperLooks isEqualToString:@"default"]){
        reginaldPref = planetDefault;
    }else
        reginaldPref = [SGPlayerPreferencesManager preferenceManager].orangeSuperLooks;
    
    NSArray* reginaldFrames = @[
                          
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side1%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side2%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side3%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side4%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side5%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side6%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side7%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side8%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side9%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side10%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side11%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side12%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side13%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-side14%@",reginaldPref,_deviceModel]],
                              
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up1%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up2%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up3%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up4%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up5%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up6%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up7%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up8%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up9%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up10%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up11%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up12%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up13%@",reginaldPref,_deviceModel]],
                              [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-reginald-up14%@",reginaldPref,_deviceModel]]
                          
                          ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   reginaldFrames[0],
                                   reginaldFrames[1],
                                   reginaldFrames[2],
                                   reginaldFrames[3],
                                   reginaldFrames[4],
                                   reginaldFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             reginaldFrames[6],
                             reginaldFrames[7],
                             reginaldFrames[8],
                             reginaldFrames[9],
                             reginaldFrames[10],
                             reginaldFrames[11],
                             reginaldFrames[12],
                             reginaldFrames[13]
                             
                             ];
        
        _reginald_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                      [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   reginaldFrames[14],
                                   reginaldFrames[15],
                                   reginaldFrames[16],
                                   reginaldFrames[17],
                                   reginaldFrames[18],
                                   reginaldFrames[19],
                                   reginaldFrames[20],
                                   reginaldFrames[21],
                                   reginaldFrames[22],
                                   reginaldFrames[23],
                                   reginaldFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             reginaldFrames[25],
                             reginaldFrames[26],
                             reginaldFrames[27]
                             
                             ];
        
        _reginald_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                      [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }
    
    NSString* lukePref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].yellowSuperLooks isEqualToString:@"default"]){
        lukePref = planetDefault;
    }else
        lukePref = [SGPlayerPreferencesManager preferenceManager].yellowSuperLooks;

    NSArray* lukeFrames = @[
                            
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side1%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side2%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side3%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side4%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side5%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side6%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side7%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side8%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side9%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side10%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side11%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side12%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side13%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-side14%@",lukePref,_deviceModel]],
                                
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up1%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up2%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up3%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up4%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up5%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up6%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up7%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up8%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up9%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up10%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up11%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up12%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up13%@",lukePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-luke-up14%@",lukePref,_deviceModel]]
                                
                                ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   lukeFrames[0],
                                   lukeFrames[1],
                                   lukeFrames[2],
                                   lukeFrames[3],
                                   lukeFrames[4],
                                   lukeFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             lukeFrames[6],
                             lukeFrames[7],
                             lukeFrames[8],
                             lukeFrames[9],
                             lukeFrames[10],
                             lukeFrames[11],
                             lukeFrames[12],
                             lukeFrames[13]
                             
                             ];
        
        _luke_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                            [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   lukeFrames[14],
                                   lukeFrames[15],
                                   lukeFrames[16],
                                   lukeFrames[17],
                                   lukeFrames[18],
                                   lukeFrames[19],
                                   lukeFrames[20],
                                   lukeFrames[21],
                                   lukeFrames[22],
                                   lukeFrames[23],
                                   lukeFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             lukeFrames[25],
                             lukeFrames[26],
                             lukeFrames[27]
                             
                             ];
        
        _luke_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                            [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }
    
    NSString* mikePref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].blueSuperLooks isEqualToString:@"default"]){
        mikePref = planetDefault;
    }else
        mikePref = [SGPlayerPreferencesManager preferenceManager].blueSuperLooks;
    
    NSArray* mikeFrames = @[
                            
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side1%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side2%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side3%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side4%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side5%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side6%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side7%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side8%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side9%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side10%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side11%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side12%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side13%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-side14%@",mikePref,_deviceModel]],
                                
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up1%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up2%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up3%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up4%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up5%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up6%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up7%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up8%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up9%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up10%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up11%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up12%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up13%@",mikePref,_deviceModel]],
                                [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-mike-up14%@",mikePref,_deviceModel]]
                            
                            ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   mikeFrames[0],
                                   mikeFrames[1],
                                   mikeFrames[2],
                                   mikeFrames[3],
                                   mikeFrames[4],
                                   mikeFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             mikeFrames[6],
                             mikeFrames[7],
                             mikeFrames[8],
                             mikeFrames[9],
                             mikeFrames[10],
                             mikeFrames[11],
                             mikeFrames[12],
                             mikeFrames[13]
                             
                             ];
        
        _mikey_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                        [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   mikeFrames[14],
                                   mikeFrames[15],
                                   mikeFrames[16],
                                   mikeFrames[17],
                                   mikeFrames[18],
                                   mikeFrames[19],
                                   mikeFrames[20],
                                   mikeFrames[21],
                                   mikeFrames[22],
                                   mikeFrames[23],
                                   mikeFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             mikeFrames[25],
                             mikeFrames[26],
                             mikeFrames[27]
                             
                             ];
        
        _mikey_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                        [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }
    
    NSString* garryPref = @"";
    if([[SGPlayerPreferencesManager preferenceManager].purpleSuperLooks isEqualToString:@"default"]){
        garryPref = planetDefault;
    }else
        garryPref = [SGPlayerPreferencesManager preferenceManager].purpleSuperLooks;
    
    NSArray* garryFrames = @[
               
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side1%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side2%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side3%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side4%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side5%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side6%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side7%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side8%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side9%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side10%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side11%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side12%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side13%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-side14%@",garryPref,_deviceModel]],
                            
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up1%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up2%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up3%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up4%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up5%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up6%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up7%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up8%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up9%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up10%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up11%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up12%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up13%@",garryPref,_deviceModel]],
                            [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"%@-hero-garry-up14%@",garryPref,_deviceModel]]
                            
                            ];
    
    // animation
    {
        
        NSArray* runTransition = @[
                                   garryFrames[0],
                                   garryFrames[1],
                                   garryFrames[2],
                                   garryFrames[3],
                                   garryFrames[4],
                                   garryFrames[5]
                                   
                                   ];
        NSArray* runLoop = @[
                             
                             garryFrames[6],
                             garryFrames[7],
                             garryFrames[8],
                             garryFrames[9],
                             garryFrames[10],
                             garryFrames[11],
                             garryFrames[12],
                             garryFrames[13]
                             
                             ];
        
        _gerry_Animation_hero_run = [SKAction sequence:@[[SKAction animateWithTextures:runTransition timePerFrame:0.06],
                                                         [SKAction repeatActionForever:[SKAction animateWithTextures:runLoop timePerFrame:0.06]]]];
        NSArray* flyTransition = @[
                                   garryFrames[14],
                                   garryFrames[15],
                                   garryFrames[16],
                                   garryFrames[17],
                                   garryFrames[18],
                                   garryFrames[19],
                                   garryFrames[20],
                                   garryFrames[21],
                                   garryFrames[22],
                                   garryFrames[23],
                                   garryFrames[24]
                                   
                                   ];
        NSArray* flyLoop = @[
                             
                             garryFrames[25],
                             garryFrames[26],
                             garryFrames[27]
                             
                             ];
        
        _gerry_Animation_hero_fly = [SKAction sequence:@[[SKAction animateWithTextures:flyTransition timePerFrame:0.06],
                                                         [SKAction repeatActionForever:[SKAction animateWithTextures:flyLoop timePerFrame:0.06]]]];
        
    }

    
    self.superCookieTextures = @[
                                 
                                 jjFrames[0],
                                 reginaldFrames[0],
                                 lukeFrames[0],
                                 dustinFrames[0],
                                 mikeFrames[0],
                                 garryFrames[0],
                                 chipFrames[0]
                                 
                                 ];
    
}
*/



-(void)loadWrappers{
    
    //WrappedCookieTextures
    
    self.WrappedCookieTextures = @[ // WrappedCookies

                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedred"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedorange"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedyellow"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedgreen"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedblue"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedpurple"],
                                   [SKTexture textureWithImageNamed:@"cdd-main-board-item-wrappedbrown"]
                                   
                                   ];
}

-(void)setGoalType:(GoalTypes)goalType
         WithValue:(int)goalValue
        WithBronze:(int)bronzeValue
        WithSilver:(int)silverValue
          WithGold:(int)goldValue
         WithItems:(NSArray*)items
 SecondaryGoalType:(GoalTypes)secondGoalType
 SecondaryGoalValue:(int)secondGoalValue
 SecondaryGoalItems:(NSArray*)secondGoalItems
{
    
    _mainGoalType = goalType;
    _mainGoalValue = goalValue;
    _secondGoalType = secondGoalType;
    _secondGoalValue = secondGoalValue;
    _score_bronze = bronzeValue;
    _score_silver = silverValue;
    _score_gold = goldValue;
    
    
//    DebugLog(@"\n Gold %i",_score_gold);
//    DebugLog(@"\n Silver %i",_score_silver);
//    DebugLog(@"\n Bronze %i\n",_score_bronze);
    
    if(items != nil){
        NSMutableArray* tempGoalItems = [NSMutableArray new];
        
        for (int i = 0; i<items.count;i+=2) {
            
            NSString* itemName = items[i];
            
            // Step through and place everything in the proper categories.
            if ([itemName rangeOfString:@"PLATES"].location != NSNotFound) {
                
                [tempGoalItems addObject:[NSNumber numberWithInt:500]];
                
                int target = [[[NSNumberFormatter new] numberFromString:items[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
                
            }
            else if ([itemName rangeOfString:@"COOKIE_"].location != NSNotFound) {
                
                [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemName]] ToArray:tempGoalItems];
                
                int target = [[[NSNumberFormatter new] numberFromString:items[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
                
            }
            else if ([itemName rangeOfString:@"INGREDIENT_"].location != NSNotFound) {
                
                [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemName]] ToArray:tempGoalItems];
                
                int target = [[[NSNumberFormatter new] numberFromString:items[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
            }
        }
        
        _mainGoalItems = tempGoalItems;
        
        _initial_mainGoalItems = [NSMutableArray new];
        for(int i=0; i<tempGoalItems.count; i++){
            
            int value = [tempGoalItems[i] intValue];
            [_initial_mainGoalItems addObject:[NSNumber numberWithInt:value]];
            
        }
    }
    
    
    if(_mainGoalType == GoalTypes_INGREDIENT){
        
        _mainGoalItems = [NSMutableArray arrayWithArray:@[
                       
                       [NSNumber numberWithInt:INGREDIENT_BANANA],
                       [NSNumber numberWithInt:0],
                       [NSNumber numberWithInt:INGREDIENT_CHIPS],
                       [NSNumber numberWithInt:0],
                       [NSNumber numberWithInt:INGREDIENT_EGG],
                       [NSNumber numberWithInt:0],
                       [NSNumber numberWithInt:INGREDIENT_SUGAR],
                       [NSNumber numberWithInt:0],
                       [NSNumber numberWithInt:INGREDIENT_FLOUR],
                       [NSNumber numberWithInt:0]
                       
                       ]];
    }

    
    if(secondGoalItems != nil){
        NSMutableArray* tempGoalItems = [NSMutableArray new];
        
        for (int i = 0; i<secondGoalItems.count;i+=2) {
            
            NSString* itemName = secondGoalItems[i];
            
            // Step through and place everything in the proper categories.
            if ([itemName rangeOfString:@"PLATES"].location != NSNotFound) {
                
                [tempGoalItems addObject:[NSNumber numberWithInt:500]];
                
                int target = [[[NSNumberFormatter new] numberFromString:secondGoalItems[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
                
            }
            else if ([itemName rangeOfString:@"COOKIE_"].location != NSNotFound) {
                
                [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemName]] ToArray:tempGoalItems];
                
                int target = [[[NSNumberFormatter new] numberFromString:secondGoalItems[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
                
            }
            else if ([itemName rangeOfString:@"INGREDIENT_"].location != NSNotFound) {
                
                [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemName]] ToArray:tempGoalItems];
                
                int target = [[[NSNumberFormatter new] numberFromString:secondGoalItems[i+1]] intValue];
                
                if(target == 0){
                    [tempGoalItems addObject:[NSNumber numberWithInt:-1]];
                }else
                    [tempGoalItems addObject:[NSNumber numberWithInt:target]];
            }
        }
        
        _secondGoalItems = tempGoalItems;
        
        _initial_secondGoalItems = [NSMutableArray new];
        for(int i=0; i<tempGoalItems.count; i++){
            
            int value = [tempGoalItems[i] intValue];
            [_initial_secondGoalItems addObject:[NSNumber numberWithInt:value]];
            
        }
        
    }
    
    
    if(secondGoalType == GoalTypes_INGREDIENT){
        
        _secondGoalItems = [NSMutableArray arrayWithArray:@[
                           
                           [NSNumber numberWithInt:INGREDIENT_BANANA],
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:INGREDIENT_CHIPS],
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:INGREDIENT_EGG],
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:INGREDIENT_SUGAR],
                           [NSNumber numberWithInt:0],
                           [NSNumber numberWithInt:INGREDIENT_FLOUR],
                           [NSNumber numberWithInt:0]
                           
                           ]];
    }

}

-(void)setLimiterValueTo:(GoalLimiters)limiterType
               WithValue:(int)limiterValue
{
    _goalLimiter = limiterType;
    _limiterValue = limiterValue;
    
    _initial_limiterValue = limiterValue;
    
    
    if(limiterValue == 0){ // unlimited
        
        _limiterValue = -1;
        
    }
    else{
        
        if(limiterType == GoalLimiters_MOVE_LIMIT){
            DebugLog(@"Moves limited :%i",limiterValue);
            
        }else if(limiterType == GoalLimiters_TIME_LIMIT){
            
            DebugLog(@"Time limited to seconds: %i", limiterValue);
            //[self Make_A_Timer_Node];
            
        }
        
    }
    
}

- (void)setSpawnableItemsWithArray:(NSArray *)spawnableItems {
    //DebugLog(@"Spawnable items array = %@", spawnableItems);
    
    NSMutableArray *tempArray = [NSMutableArray new];
    NSMutableArray *tempCookieArray = [NSMutableArray new];
    NSMutableArray *tempIngredienArray = [NSMutableArray new];
    
    _masterItemTypesArray = [[SGFileManager fileManager] loadArrayWithFileName:@"itemtypes-master-list" OfType:@"plist"];
    _masterTexturesArray = [[SGFileManager fileManager] loadArrayWithFileName:@"itemtypes-textures-master-list" OfType:@"plist"];
    
    
    
    for (int i=0; i<spawnableItems.count; i++) {
        
        NSDictionary* spawnItem;
        NSString* itemTYPE;
        int spawnChance;
        
        if([spawnableItems[i] isKindOfClass:[NSDictionary class]]){
            
            spawnItem = spawnableItems[i];
            
            itemTYPE = spawnItem[@"itemType"];
            spawnChance = [spawnItem[@"spawnChance"] intValue];
            
        }else{
            
            itemTYPE = spawnableItems[i];
            spawnChance = 100;
            
        }
        
        // Step through and place everything in the proper categories.
        if ([itemTYPE rangeOfString:@"COOKIE_"].location != NSNotFound) {
            //DebugLog(@"Found a cookie!");
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempCookieArray];
        }
        else if ([itemTYPE rangeOfString:@"INGREDIENT_"].location != NSNotFound) {
            //DebugLog(@"Found an Ingredient!");
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempIngredienArray];
        }
        else if ([itemTYPE rangeOfString:@"POWERUP_"].location != NSNotFound) {

            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
        }
        else if ([itemTYPE rangeOfString:@"BOOSTER_"].location != NSNotFound) {
            //DebugLog(@"Found a powerup!");
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
            
        }else if ([itemTYPE rangeOfString:@"BLOCKER_PRETZEL"].location != NSNotFound) {
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
            
        }else if ([itemTYPE rangeOfString:@"BOMB"].location != NSNotFound) {
            [self addTypeID:[NSNumber numberWithInt:(int) [_masterItemTypesArray indexOfObject:itemTYPE]] ToArray:tempArray];
            [self addTypeID:[NSNumber numberWithInt:spawnChance] ToArray:tempArray];
            
        }
        else {
            DebugLog(@"Error: Unrecognized spawnable item named '%@'.", itemTYPE);
        }
    }
    
    _spawnablePieces = tempArray;
    _spawnableCookies = tempCookieArray;
    _spawnableIngredients = tempIngredienArray;
    
    [self SetTheSpawnPot];
}

// This adds an item's typeID to an array, along with the texture assosiated with it.
// Note that typeID will not be a reliable index value.  Don't do it, man!

- (void)addTypeID:(NSNumber *)typeID ToArray:(NSMutableArray *)itemArray {
    //DebugLog(@"Adding item of type '%@' to array %@", typeID, itemArray);
    // Check to make sure we don't have duplicates.
    
    [itemArray addObject:typeID];
    
}


#pragma mark - Helper Methods

- (SKTextureAtlas *)textureAtlasNamed:(NSString *)fileName
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        /*
         if (IS_IPHONE_5) {
         // iPhone Retina 4-inch
         fileName = [NSString stringWithFormat:@"%@-568", fileName];
         } else {
         // iPhone Retina 3.5-inch
         fileName = fileName;
         }
         */
    }
    else
    {
        fileName = [NSString stringWithFormat:@"%@-ipad", fileName];
    }
    
    SKTextureAtlas *textureAtlas = [SKTextureAtlas atlasNamed:fileName];
    
    return textureAtlas;
}


// NOTE:
// Distance Formula
// d = (x2 - x1) + (y2 - y1)

- (double)distanceBetweenPointA:(CGPoint)pointA fromPointB:(CGPoint)pointB
{
    double distance = 0.0f;
    
    distance = sqrt(pow((pointB.x - pointA.x), 2.0) + pow((pointB.y - pointA.y), 2.0));
    
    int reformatDistance = abs(distance);
    
    return reformatDistance;
}


#pragma mark - Power Up applications

-(void)SuperSizeThatCookie:(CDCookieSpriteNode*)cookie
{
    
    if(cookie.isLocked){
        
        [self LockBreak:cookie];
        
    }
    
    if([cookie isMemberOfClass:[CDBombSpriteNode class]]){
        
        [_allBombs removeObject:cookie];
        [cookie removeAllChildren];
    }
    
    [cookie removeAllActions];
    
    int cookieTypeID = cookie.typeID;
    SKTexture* superTexture;
    UIColor *color;// = [UIColor new];
    
    switch (cookieTypeID)
    {
        case COOKIE_RED:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:0];
            color = [UIColor colorWithRed:0.973 green:0.496 blue:0.597 alpha:1.000];
            break;
        case COOKIE_ORANGE:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:1];
            color = [UIColor colorWithRed:0.960 green:0.687 blue:0.494 alpha:1.000];
            break;
        case COOKIE_YELLOW:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:2];
            color = [UIColor colorWithRed:0.971 green:0.867 blue:0.458 alpha:1.000];
            break;
        case COOKIE_GREEN:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:3];
            color = [UIColor colorWithRed:0.597 green:1.000 blue:0.542 alpha:1.000];
            break;
        case COOKIE_BLUE:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:4];
            color = [UIColor colorWithRed:0.517 green:0.694 blue:0.975 alpha:1.000];
            break;
        case COOKIE_PURPLE:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:5];
            color = [UIColor colorWithRed:0.767 green:0.439 blue:0.975 alpha:1.000];
            break;
        case COOKIE_CHIP:
            superTexture = [[CDCookieAnimationManager animationManager].superCookieTextures objectAtIndex:6];
            color = [UIColor colorWithRed:0.972 green:0.800 blue:0.621 alpha:1.000];
            break;
            
        default:
            color = [UIColor whiteColor];
            break;
    }
    
    [self createSuperBurstForCookie:cookie Color:color];
    [self createSuperGlowForCookie:cookie Color:color];
    
    cookie.texture = superTexture;
    
    [[CDCookieAnimationManager animationManager] SuperSizing:cookie];
    
    [self.SuperCookies addObject:cookie];
}

- (void)createSuperGlowForCookie:(CDCookieSpriteNode *)cookie Color:(UIColor *)color {
    SKEmitterNode *superGlow = [[SKEmitterNode alloc] init];
    [superGlow setParticleTexture:[SKTexture textureWithImageNamed:@"cdd-particle-softpuff"]];
    
    [superGlow setParticleBirthRate:3];
    [superGlow setParticleLifetime:0.4f];
    
    [superGlow setScale:0.4];
    [superGlow setParticleScaleSpeed:2.5f];
    
    [superGlow setParticleBlendMode:SKBlendModeAlpha];
    [superGlow setParticleColor:color];
    [superGlow setParticleColorBlendFactor:1.0f];
    
    [superGlow setParticleAlpha:0.6f];
    [superGlow setParticleAlphaSpeed:-1.25f];
    
    [superGlow setPosition:CGPointMake(0.0f, 0.0f)];
    superGlow.zPosition = -1;
    [cookie addChild:superGlow];
}

- (void)createSuperBurstForCookie:(CDCookieSpriteNode *)cookie Color:(UIColor *)color {
    //DebugLog(@"New super cookie = %@", cookie);
    
    // Shockwave
    // (If I don't do this through code, then we can't change the color.)
    _superShockwaveParticle = [[SKEmitterNode alloc] init];
    [_superShockwaveParticle setParticleTexture:[SKTexture textureWithImageNamed:@"white_shockwave_circle"]];
    
    [_superShockwaveParticle setParticleBirthRate:400];
    [_superShockwaveParticle setNumParticlesToEmit:1];
    [_superShockwaveParticle setParticleLifetime:0.3f];
    
    [_superShockwaveParticle setScale:0.5];
    [_superShockwaveParticle setParticleScaleSpeed:4.0f];
    
    [_superShockwaveParticle setParticleRotation:0.0f];
    [_superShockwaveParticle setParticleRotationRange:359.0f];
    [_superShockwaveParticle setParticleRotationSpeed:171.0f];
    
    [_superShockwaveParticle setParticleBlendMode:SKBlendModeAlpha];
    [_superShockwaveParticle setParticleColor:color];
    [_superShockwaveParticle setParticleColorBlendFactor:1.0f];
    
    [_superShockwaveParticle setParticleAlpha:0.55f];
    [_superShockwaveParticle setParticleAlphaSpeed:-0.15f];
    
    [_superShockwaveParticle setPosition:CGPointMake(0.0f, 0.0f)];
    _superShockwaveParticle.zPosition = cookie.zPosition - 1;
    [cookie addChild:_superShockwaveParticle];
    
    SKAction* shockwaveDelete = [SKAction sequence:@[[SKAction waitForDuration:_superShockwaveParticle.particleLifetime], [SKAction removeFromParent]]];
    [_superShockwaveParticle runAction:shockwaveDelete];
    
    
    // Little Boom
    SKEmitterNode *superLittleBoomParticle = [[SKEmitterNode alloc] init];
    [superLittleBoomParticle setParticleTexture:[SKTexture textureWithImageNamed:@"particle-sparkle"]];
    [superLittleBoomParticle setTargetNode:_gameBoard];
    [superLittleBoomParticle setScale:0.5];
    
    
    [superLittleBoomParticle setParticleBirthRate:600];
    [superLittleBoomParticle setNumParticlesToEmit:10];
    [superLittleBoomParticle setParticleLifetime:0.4f];
    
    [superLittleBoomParticle setParticleScale:0.1f];
    [superLittleBoomParticle setParticleScaleRange:0.1f];
    [superLittleBoomParticle setParticleScaleSpeed:0.2f];
    
    [superLittleBoomParticle setParticlePositionRange:CGVectorMake(60, 60)];
    [superLittleBoomParticle setParticleSpeed:40.0f];
    [superLittleBoomParticle setParticleSpeedRange:20.0f];
    
    [superLittleBoomParticle setEmissionAngle:0.0f];
    [superLittleBoomParticle setEmissionAngleRange:359.0f];
    
    [superLittleBoomParticle setParticleRotation:0.0f];
    [superLittleBoomParticle setParticleRotationRange:359.0f];
    [superLittleBoomParticle setParticleRotationSpeed:100.0f];
    
    [superLittleBoomParticle setParticleBlendMode:SKBlendModeScreen];
    [superLittleBoomParticle setParticleColor:color];
    [superLittleBoomParticle setParticleColorBlendFactor:1.0f];
    
    [superLittleBoomParticle setParticleAlpha:0.9f];
    [superLittleBoomParticle setParticleAlphaRange:0.3f];
    [superLittleBoomParticle setParticleAlphaSpeed:-0.10f];
    
    [superLittleBoomParticle setPosition:CGPointMake(0.0f, 0.0f)];
    superLittleBoomParticle.zPosition = cookie.zPosition + 1;
    [cookie addChild:superLittleBoomParticle];
    
    SKAction* littleBoomDelete = [SKAction sequence:@[[SKAction waitForDuration:superLittleBoomParticle.particleLifetime], [SKAction removeFromParent]]];
    [superLittleBoomParticle runAction:littleBoomDelete];
    
    
    // Big Boom
    _superBoomParticle = [[SKEmitterNode alloc] init];
    [_superBoomParticle setParticleTexture:[SKTexture textureWithImageNamed:@"particle-sparkle"]];
    [_superBoomParticle setTargetNode:_gameBoard];
    [_superBoomParticle setScale:0.5];
    
    
    [_superBoomParticle setParticleBirthRate:600];
    [_superBoomParticle setNumParticlesToEmit:15];
    [_superBoomParticle setParticleLifetime:0.6f];
    
    [_superBoomParticle setParticleScale:0.1f];
    [_superBoomParticle setParticleScaleRange:0.1f];
    [_superBoomParticle setParticleScaleSpeed:0.2f];
    
    [_superBoomParticle setParticlePositionRange:CGVectorMake(60, 60)];
    [_superBoomParticle setParticleSpeed:500.0f];
    [_superBoomParticle setParticleSpeedRange:300.0f];
    
    [_superBoomParticle setEmissionAngle:0.0f];
    [_superBoomParticle setEmissionAngleRange:359];
    
    [_superBoomParticle setParticleRotation:0.0f];
    [_superBoomParticle setParticleRotationRange:359.0f];
    [_superBoomParticle setParticleRotationSpeed:200.0f];
    
    [_superBoomParticle setParticleBlendMode:SKBlendModeScreen];
    [_superBoomParticle setParticleColor:color];
    [_superBoomParticle setParticleColorBlendFactor:1.0f];
    
    [_superBoomParticle setParticleAlpha:0.7f];
    [_superBoomParticle setParticleAlphaRange:0.3f];
    [_superBoomParticle setParticleAlphaSpeed:-0.15f];
    
    [_superBoomParticle setPosition:CGPointMake(0.0f, 0.0f)];
    _superBoomParticle.zPosition = cookie.zPosition + 1;
    [cookie addChild:_superBoomParticle];
    
    SKAction* bigBoomDelete = [SKAction sequence:@[[SKAction waitForDuration:_superBoomParticle.particleLifetime], [SKAction removeFromParent]]];
    [_superBoomParticle runAction:bigBoomDelete];
    
    
}

-(void)Wrap_that_cookie:(CDCookieSpriteNode *)cookie
{
    
    if(cookie.isLocked){
        
        [self LockBreak:cookie];
        
    }
    
    if([cookie isMemberOfClass:[CDBombSpriteNode class]]){
        
        [_allBombs removeObject:cookie];
        [cookie removeAllChildren];
    }
    
    [cookie removeAllActions];
    
    if(!_isPlaying_CookieWrap){
        
        [_scene runAction:_wrapSound];
     
        _isPlaying_CookieWrap = YES;
        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
            
            _isPlaying_CookieWrap = NO;
            
        }];
    }
    
    int cookieTypeID = cookie.typeID;
    SKTexture* wrapperTexture;
    
    switch (cookieTypeID) {
        case COOKIE_RED:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:0];
            break;
        case COOKIE_ORANGE:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:1];
            break;
        case COOKIE_YELLOW:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:2];
            break;
        case COOKIE_GREEN:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:3];
            break;
        case COOKIE_BLUE:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:4];
            break;
        case COOKIE_PURPLE:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:5];
            break;
        case COOKIE_CHIP:
            wrapperTexture = [self.wrappedCookieTextures objectAtIndex:6];
            break;
            
        default:
            break;
    }
    
    cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
    cookie.texture = wrapperTexture;
    
    [self.WrappedCookies addObject:cookie];
    
}

-(void)Smore_that_cookie:(CDCookieSpriteNode*)cookie
{
    
    if(cookie.isLocked){
        
        [self LockBreak:cookie];
        
    }
    
    if([cookie isMemberOfClass:[CDBombSpriteNode class]]){
        
        [_allBombs removeObject:cookie];
        [cookie removeAllChildren];
    }
    
    [cookie removeAllActions];
    cookie.isVulnerable = NO;
    
    cookie.typeID = POWERUP_SMORE;
    
    cookie.texture = self.smoreTexture;
    cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
    
    [self createSmoreBurstAtPosition:cookie.position InNode:_gameBoard];
    [cookie runAction:[SKAction repeatActionForever:[self smoreWarpAction]] withKey:@"smoreWarpAction"];
    
}

-(BOOL)RadiateThatCookie:(CDCookieSpriteNode*)cookie{
    
    if([cookie isMemberOfClass:[CDBombSpriteNode class]]){
        
        [_allBombs removeObject:cookie];
        [cookie removeAllChildren];
    }
    
    if([cookie isKindOfClass:[CDCookieSpriteNode class]] &&
       cookie.typeID != BOOSTER_RADSPRINKLE &&
       cookie.typeID != BOOSTER_SLOTMACHINE &&
       cookie.typeID != POWERUP_SMORE)
    {
        
        if (![self.WrappedCookies containsObject:cookie] && ![self.SuperCookies containsObject:cookie])
        {
            
            if(cookie.isLocked){
                
                [self LockBreak:cookie];
                
            }
            
            [cookie removeAllActions];
            
            cookie.isVulnerable = NO;
            
            cookie.typeID = BOOSTER_RADSPRINKLE;
            
            cookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
            cookie.texture = self.radioactiveSprinkleTexture;
            
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - Power Up effects

-(void)Super_Horizontal:(CDCookieSpriteNode*)theSuper{
    
    if(theSuper.isLocked){
            
        [self LockBreak:theSuper];
        
    }
    
//    if(!_isPlaying_cdd_milky_wave_distorted){
//        
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_milky_wave_distorted" FileType:@"caf" volume:1]; //@"m4a" volume:1];
////        [_scene runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_milky_wave_distorted" withFileType:@".m4a"]];
//        
//        _isPlaying_cdd_milky_wave_distorted = YES;
//        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
//        
//            _isPlaying_cdd_milky_wave_distorted = NO;
//        
//        }];
//    }
    
    
    [[CDCookieAnimationManager animationManager] SuperHorizontal:theSuper];
    
    NSString* costume = KeyThemeDefault;
    int kind = theSuper.typeID;
    
    switch (kind) {
        case COOKIE_CHIP:{
            costume = [SGPlayerPreferencesManager preferenceManager].brownSuperLooks;
            
            break;
        }
        case COOKIE_BLUE:{
            costume = [SGPlayerPreferencesManager preferenceManager].blueSuperLooks;
            
            break;
        }
        case COOKIE_ORANGE:{
            costume = [SGPlayerPreferencesManager preferenceManager].orangeSuperLooks;
            
            break;
        }
        case COOKIE_YELLOW:{
            costume = [SGPlayerPreferencesManager preferenceManager].yellowSuperLooks;
            
            break;
        }
        case COOKIE_GREEN:{
            costume = [SGPlayerPreferencesManager preferenceManager].greenSuperLooks;
            
            break;
        }
        case COOKIE_PURPLE:{
            costume = [SGPlayerPreferencesManager preferenceManager].purpleSuperLooks;
            
            break;
        }
        case COOKIE_RED:{
            costume = [SGPlayerPreferencesManager preferenceManager].redSuperLooks;
            
            break;
        }
        default:
            break;
    }
    
    if([costume isEqualToString:KeyThemeDefault]) {
        
        // milkstream
        
        CGPoint milkPoint = CGPointMake(0,theSuper.position.y);
        milkPoint = [_scene convertPoint:milkPoint fromNode:_gameBoard];
        milkPoint.x = _scene.size.width * 0.5f;
        
        [self Milkstream:_milkstream Position:milkPoint WidthScale:_columnWidth/2.0f Angle:90.0f * 0.01745329f Zpos:1 Duration:1.5f + 0.24f];
        
    }
       
}

-(void)Super_Vertical:(CDCookieSpriteNode*)theSuper{
    
    if(theSuper.isLocked){
        
        [self LockBreak:theSuper];
        
    }
    
//    if(!_isPlaying_cdd_milky_wave_distorted){
//        
//        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_milky_wave_distorted" FileType:@"caf" volume:1]; //@"m4a" volume:1];
////        [_scene runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_milky_wave_distorted" withFileType:@".m4a"]];
//        
//        _isPlaying_cdd_milky_wave_distorted = YES;
//        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
//            
//            _isPlaying_cdd_milky_wave_distorted = NO;
//            
//        }];
//    }
    
    
    [[CDCookieAnimationManager animationManager] SuperVertical:theSuper];

    NSString* costume = KeyThemeDefault;
    int kind = theSuper.typeID;
    
    switch (kind) {
        case COOKIE_CHIP:{
            costume = [SGPlayerPreferencesManager preferenceManager].brownSuperLooks;
            
            break;
        }
        case COOKIE_BLUE:{
            costume = [SGPlayerPreferencesManager preferenceManager].blueSuperLooks;
            
            break;
        }
        case COOKIE_ORANGE:{
            costume = [SGPlayerPreferencesManager preferenceManager].orangeSuperLooks;
            
            break;
        }
        case COOKIE_YELLOW:{
            costume = [SGPlayerPreferencesManager preferenceManager].yellowSuperLooks;
            
            break;
        }
        case COOKIE_GREEN:{
            costume = [SGPlayerPreferencesManager preferenceManager].greenSuperLooks;
            
            break;
        }
        case COOKIE_PURPLE:{
            costume = [SGPlayerPreferencesManager preferenceManager].purpleSuperLooks;
            
            break;
        }
        case COOKIE_RED:{
            costume = [SGPlayerPreferencesManager preferenceManager].redSuperLooks;
            
            break;
        }
        default:
            break;
    }
    
    if ([costume isEqualToString:KeyThemeDefault]) {
        
        // milkstream
        
        CGPoint milkPoint = CGPointMake(theSuper.position.x,0);
        milkPoint = [_scene convertPoint:milkPoint fromNode:_gameBoard];
        milkPoint.y = _scene.size.height * 0.5;
        
        [self Milkstream:_milkstream Position:milkPoint WidthScale:_columnWidth/2.0f Angle:0 Zpos:1 Duration:1.5f + 0.24f];

    }
    
}


-(void)SingleWrapper:(CDGameBoardSpriteNode*)piece{
    
//    [_scene runAction:_PowerCrunch];
    
    if(!_isPlaying_PowerCrunch){
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerCrunch Swipe 1" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    
        _isPlaying_PowerCrunch = YES;
        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
            
            _isPlaying_PowerCrunch = NO;
            
        }];
        
    }
    
    piece.isVulnerable = NO;
    piece.shouldMilkSplash = NO;
    
    float duration = 1.5f;
    
    float firstPartDuration = duration*0.25;
    float secondPartDuration = duration*0.75;
    
    CGRect portal_Rect;
    portal_Rect.origin = piece.position;
    portal_Rect.size = CGSizeMake(_columnWidth * 3, _columnWidth * 3);
    
    [self Portal:portal_Rect Duration_OUT:firstPartDuration Duration_IN:secondPartDuration];
    
    NSMutableArray* list = [NSMutableArray new];
    
    [list addObject:piece];
    
    for (int column=piece.column - 1; column<=piece.column+1; column++)
        for(int row=piece.row - 1; row<=piece.row+1; row++)
            if(column < _numColumns && column > -1 && row < _numRows && row > -1)
            {
                
                CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns) + column];
                
                if(checkPiece.isLocked){
                    
                    [self LockBreak:checkPiece];
                    
                }else
                if(checkPiece.isVulnerable){
                    if([checkPiece isKindOfClass:[CDCookieSpriteNode class]]){
                        if([_SuperCookies containsObject:checkPiece]){
                            
                            [_SuperCookies removeObject:checkPiece];
                            
                            [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                
                                if(arc4random() % 2 == 0){
                                    [self Super_Horizontal:(CDCookieSpriteNode*)checkPiece];
                                }else{
                                    [self Super_Vertical:(CDCookieSpriteNode*)checkPiece];
                                }
                                
                            }];
                            
                        }else
                            if([_WrappedCookies containsObject:checkPiece]){
                                
                                [_WrappedCookies removeObject:checkPiece];
                                [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                    
                                    [self SingleWrapper:checkPiece];
                                    
                                }];
                                
                            }
                            else{
                                
                                [list addObject:checkPiece];
                                
                                checkPiece.isVulnerable = NO;
                                checkPiece.shouldMilkSplash = NO;
                                
                            }
                    }
                }else if(checkPiece.typeID == BLOCKER_ICECREAM){
                    
                    [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:1];
                    
                }else if (checkPiece.typeID == BLOCKER_COOKIEDOUGH){
                    
                    [self HurtCookiedough:checkPiece Multiplier:1];
                    
                }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                    
                    [self HurtPretzel:checkPiece Multiplier:1];
                    
                }

            }
    
    
    
    //[list removeObjectsInArray:locks];
    
    // make them move
    
    float radius = _columnWidth;
    
    for(CDGameBoardSpriteNode* portalVictim in list) {
        
        
        float distance = sqrtf(powf((portalVictim.position.x - piece.position.x),2) + powf((portalVictim.position.y - piece.position.y),2));
        
        float waitTime = (distance/radius) * firstPartDuration;
        float travelTime = duration - waitTime;
        
        portalVictim.shouldMilkSplash = NO;
        
        
        SKAction* movement_and_scaling = [SKAction group:@[[SKAction moveTo:piece.position duration:travelTime * 0.75],
                                                           [SKAction scaleTo:0 duration:travelTime]
                                                           ]];
        
        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                    [SKAction runBlock:^{
            
            [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:portalVictim];
            
            [self Area_Effect:portalVictim Multiplier:1];
            
            if(portalVictim == piece){
                [self Add_to_Score:_score_Per_wrapped * piece.scoreMultiplier Piece:piece];
            }
            else
                [self Add_to_Score:_score_Per_powerupVictim Piece:portalVictim];
            
        }],
                                                    movement_and_scaling]];
        
        [portalVictim runAction:piecedeath];
        
        
    }
    
    
    if(list.count > 0){
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        _numActivePowerUps++;
        
        [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.1] completion:^{
            
            _numActivePowerUps--;
            
            if(_numActivePowerUps <= 0)
            {
                _numActivePowerUps = 0;
                
                [self Powerup_deletion];
            }
            
        }];
        
    }else{
        
    }
    
}


-(void)SearchAndDestroy_target:(ItemType)type Smore:(CDGameBoardSpriteNode*)theSmore
{
    
    if(!_isPlaying_PowerCrunch){
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerCrunch Swipe 1" FileType:@"caf" volume:1]; //@"m4a" volume:1];
        
        _isPlaying_PowerCrunch = YES;
        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
            
            _isPlaying_PowerCrunch = NO;
            
        }];
    }
    
    theSmore.isVulnerable = NO;
    
    float duration = 2.0f;
    
    NSMutableArray* list = [NSMutableArray new];
    NSMutableArray* locks = [NSMutableArray new];
    NSMutableArray* lightning_links = [NSMutableArray new];
    
    for(int column=_numColumns-1; column>-1; column--)
        for(int row=_numRows-1; row>-1; row--)
        {
            
            CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns)+column];
            
            if(checkPiece.typeID == type){
                
                [lightning_links addObject:checkPiece];
                checkPiece.isVulnerable = NO;
                
                if(checkPiece.isLocked){
                    [locks addObject:checkPiece];
                }else{
                    [list addObject:checkPiece];
                }
                
            }
            else
                if(theSmore == checkPiece){
                    
                    [list addObject:checkPiece];
                    [lightning_links addObject:checkPiece];
                }
        }
    
    // lightning
    SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction removeFromParent]]];
    SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:duration+1],[SKAction removeFromParent]]];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_smore_effect" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//    [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_smore_effect" withFileType:@".m4a"]];
    
    
    for (int i=0; i<lightning_links.count; i++)
    {
        
        CDGameBoardSpriteNode* currentPiece = [lightning_links objectAtIndex:i];
        CDGameBoardSpriteNode* previousPiece;
        
        if(i == 0)
            previousPiece = [lightning_links objectAtIndex:lightning_links.count-1];
        else
            previousPiece = [lightning_links objectAtIndex:i-1];
        
        
        CGVector lookDirection = CGVectorMake(previousPiece.position.x - currentPiece.position.x, previousPiece.position.y - currentPiece.position.y);
        
        float Distance = sqrtf( powf(lookDirection.dx, 2) + powf(lookDirection.dy, 2));
        
        float angle = atan2f(lookDirection.dy - 0.0f, lookDirection.dx - 1.0f);
        
        angle -= 90.0f * 0.01745329;
        
        CGPoint Midway = CGPointMake((previousPiece.position.x + currentPiece.position.x)*0.5, (previousPiece.position.y + currentPiece.position.y)*0.5);
        
        Midway = [self.scene convertPoint:Midway fromNode:self.gameBoard];
        
        SKNode * link = [self Lightning:Midway Length:Distance Angle:angle ZPos:currentPiece.zPosition+2 PlayAudio:NO];
        
        [link runAction:lightning_removal];
        
        currentPiece.zPosition += 4;
        
        // sparks
        {
            SKEmitterNode* sparks = [_Lightning_Sparks copy];
            
            sparks.position = link.position;
            sparks.zRotation = angle;
            sparks.zPosition = currentPiece.zPosition-2;
            
            sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
            sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
            sparks.particleSpeedRange = _cookieWidth * 10;
            
            sparks.numParticlesToEmit = sparks.particleBirthRate * duration;
            
            [self.scene addChild:sparks];
            
            [sparks runAction:sparks_removal];
        }
        
        // the piece's electric glow
        {
            SKSpriteNode* frontPiece = [_LightningCookieFront copy];
            SKSpriteNode* backPiece = [_LightningCookieBack copy];
            
            [_scene addChild:frontPiece];
            [_scene addChild:backPiece];
            
            CGPoint piecePos = [_scene convertPoint:currentPiece.position fromNode:_gameBoard];
            
            frontPiece.position = piecePos;
            backPiece.position = piecePos;
            
            frontPiece.zPosition = currentPiece.zPosition+1;
            backPiece.zPosition = currentPiece.zPosition-1;
            
            frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
            backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
            
            [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
            [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:duration], lightning_removal]]];
            
            
        }
       
    }
    
    for (CDGameBoardSpriteNode* piece in locks) {
    
        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
        
            [self LockBreak:piece];
        
        }]]];
        
        [piece runAction:piecedeath];
    }
    
    // make them go away
    
    for (CDGameBoardSpriteNode* piece in list) {
        
        piece.shouldMilkSplash = NO;
        piece.isVulnerable = NO;
        
        if([_SuperCookies containsObject:piece]){
            
            [_SuperCookies removeObject:piece];
            
            [piece runAction:[SKAction waitForDuration:duration] completion:^{
                
                if(arc4random() % 2 == 0){
                    [self Super_Horizontal:(CDCookieSpriteNode*)piece];
                }else{
                    [self Super_Vertical:(CDCookieSpriteNode*)piece];
                }
                
            }];
            
        }else
            if([_WrappedCookies containsObject:piece]){
                
                [_WrappedCookies removeObject:piece];
                
                [piece runAction:[SKAction waitForDuration:duration] completion:^{
                    
                    [self SingleWrapper:piece];
                    
                }];
                
            }else{
        
                SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
                    [self PlaySwitchAnimation:piece];
                }],[SKAction waitForDuration:duration-0.24],
                                                           [SKAction runBlock:^{
                    [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:piece];
                    
                }]]], // group
                    [SKAction sequence:@[
                                         [SKAction waitForDuration:0.12],
                                         [SKAction repeatAction:[SKAction sequence:@[
                                                                                     [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:piece];}],
                                                                                     [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                     
                                                                                     ]] count:(int) ((duration - 0.36)/0.2) + 1]
                                         ]]
                    ]];
                
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
                    
                    [self Put_a_milk_splash:piece.position Size:piece.size];
                    
                    // hurt plates
                    [self Area_Effect:piece Multiplier:1];
                    
                    if(piece == theSmore){
                        [self Add_to_Score:_score_Per_smore Piece:piece];
                    }else{
                        [self Add_to_Score:_score_Per_powerupVictim Piece:piece];
                    }
                    
                }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                
                [piece removeAllActions];
                
                [piece runAction:piecedeath];
                [piece runAction:pieceface];
        
            }
    }
    
    
    if(list.count > 0){
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        _numActivePowerUps++;
        
        [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.1] completion:^{
            
            _numActivePowerUps--;
            
            if(_numActivePowerUps <= 0)
            {
                _numActivePowerUps = 0;
                
                [self Powerup_deletion];
            }
            
        }];
        
    }else{
        
    }
    
}

-(void)Use_Radioactive_Sprinkle:(CDGameBoardSpriteNode*)sprinklePiece OtherPiece:(CDGameBoardSpriteNode*)piece Direction:(int)dir{
    
    if(!_isPlaying_PowerCrunch){
        
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"PowerCrunch Swipe 1" FileType:@"caf" volume:1]; //@"m4a" volume:1];
        
        _isPlaying_PowerCrunch = YES;
        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
            
            _isPlaying_PowerCrunch = NO;
            
        }];
    }
    
    //[self generateRadiation];
    
    // up down left right
    
    if(dir == 0){ // up
        
        [[CDCookieAnimationManager animationManager] Radiate_up:sprinklePiece OtherPiece:piece];
        //[self Radiate_up:sprinklePiece OtherPiece:piece];
        
    }else
        if(dir == 1){//down
            
            [[CDCookieAnimationManager animationManager] Radiate_down:sprinklePiece OtherPiece:piece];
            //[self Radiate_down:sprinklePiece OtherPiece:piece];
            
        }else
            if(dir == 2){ // left
                
                [[CDCookieAnimationManager animationManager] Radiate_left:sprinklePiece OtherPiece:piece];
                //[self Radiate_left:sprinklePiece OtherPiece:piece];
                
            }else
                if(dir == 3){ // right
                    
                    [[CDCookieAnimationManager animationManager] Radiate_right:sprinklePiece OtherPiece:piece];
                    //[self Radiate_right:sprinklePiece OtherPiece:piece];
                    
                }
    
    [_powerUpVictims addObject:sprinklePiece];
    
    _numActivePowerUps++;
    
    [self.gameBoard runAction:[SKAction waitForDuration: 0.5f] completion:^{
        
        _numActivePowerUps--;
        
        if(_numActivePowerUps <= 0)
        {
            _numActivePowerUps = 0;
            
            [self Powerup_deletion];
        }
        
    }];

    
    
}

- (void)generateRadiation {
    // THIS THING!!!!
//    SKEmitterNode *sprinkleEmitter = [SKEmitterNode new];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"radioactive_sprinkles" ofType:@"sks"];
    SKEmitterNode *sprinkleEmitter = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    sprinkleEmitter.position = CGPointMake(_scene.size.width * 0.5, _scene.size.height * 0.5);
    float birthSeconds = 2.0f;
    sprinkleEmitter.numParticlesToEmit = sprinkleEmitter.particleBirthRate * birthSeconds;
    [_scene addChild:sprinkleEmitter];
    
    SKAction *deathRow = [SKAction waitForDuration:birthSeconds + sprinkleEmitter.particleLifetime + sprinkleEmitter.particleLifetimeRange];
    [sprinkleEmitter runAction:deathRow completion:^{
        [sprinkleEmitter removeFromParent];
    }];
}

-(void)SmashThatCookie:(CDCookieSpriteNode*)victim
{
    
    for(CDBombSpriteNode* bomb in _allBombs){
        bomb.justDropped = YES;
    }
    
    _playerIdleSeconds = 20;
    
    float duration = 0.75;
    
    SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction removeFromParent]]];
    SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:duration+1],[SKAction removeFromParent]]];
    
    CGPoint piece_scenePos = [_scene convertPoint:victim.position fromNode:_gameBoard];
    
    float Distance = _scene.size.height - piece_scenePos.y;
    
    float angle = 0;
    
    //angle -= 90.0f * 0.01745329;
    
    CGPoint Midway = CGPointMake((piece_scenePos.x + piece_scenePos.x)*0.5, (piece_scenePos.y + _scene.size.height)*0.5);
    
    SKNode * link = [self Lightning:Midway Length:Distance Angle:angle ZPos:victim.zPosition+2];
    
    [link runAction:lightning_removal];
    
    // sparks
    {
        SKEmitterNode* sparks = [_Lightning_Sparks copy];
        
        sparks.position = link.position;
        sparks.zRotation = angle;
        sparks.zPosition = victim.zPosition+2;
        
        sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
        sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
        sparks.particleSpeedRange = _cookieWidth * 10;
        
        sparks.numParticlesToEmit = sparks.particleBirthRate * duration;
        
        [self.scene addChild:sparks];
        
        [sparks runAction:sparks_removal];
    }
    
    
    // the piece's electric glow
    {
        SKSpriteNode* frontPiece = [_LightningCookieFront copy];
        SKSpriteNode* backPiece = [_LightningCookieBack copy];
        
        [_scene addChild:frontPiece];
        [_scene addChild:backPiece];
        
        frontPiece.position = piece_scenePos;
        backPiece.position = piece_scenePos;
        
        frontPiece.zPosition = victim.zPosition+5;
        backPiece.zPosition = victim.zPosition+3;
        
        frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
        backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
        
        [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
        [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:duration], lightning_removal]]];
        
        
    }
    
    if(victim.isLocked){
        
        
        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
            
            [self LockBreak:victim];
            
        }]]];

        [victim runAction:piecedeath];
        
    }else
    {
        
        [_powerUpVictims addObject:victim];
        
        victim.zPosition += 4;
        victim.shouldMilkSplash = NO;
        victim.isVulnerable = NO;
        
        SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
            [self PlaySwitchAnimation:victim];
        }],[SKAction waitForDuration:duration-0.24],
                                                                     [SKAction runBlock:^{
            [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
            
        }]]], // group
                                                [SKAction sequence:@[
                                                                     [SKAction waitForDuration:0.12],
                                                                     [SKAction repeatAction:[SKAction sequence:@[
                                                                                                                 [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:victim];}],
                                                                                                                 [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                                                 
                                                                                                                 ]] count:(int) ((duration - 0.36)/0.2) + 1]
                                                                     ]]
                                                ]];
        
        
        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
            
            [self Put_a_milk_splash:victim.position Size:victim.size];
            
            // hurt plates
            [self Area_Effect:victim Multiplier:1];
            
            [self Add_to_Score:_score_Per_powerupVictim Piece:victim];
    
            
        }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
        
        [victim removeAllActions];
        
        [victim runAction:piecedeath];
        [victim runAction:pieceface];
        
    }
    
    [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.1] completion:^{
        
        [self Powerup_deletion];
        
    }];
    
    
}

-(void)Drop_The_Nuke{
    
    _cookieDoughLord.isHurt = YES;
    
    _playerIdleSeconds = 20;
    
    float duration = 1.0f;
    
    _isTakingInput = NO;
    
    _isNukeAfterMath = YES;
    
    [self SetTheGameGrid];
    
    float radius = 100.0f;
    
    float theBoardWidth = (_numColumns * _columnWidth) + (_columnWidth);
    float theBoardHeight = (_numRows * _RowHeight) + (_RowHeight);
    
    CGPoint pointZero = CGPointMake(theBoardWidth*0.5f, _RowHeight);
    
    if(_numColumns >= _numRows){
        radius = theBoardWidth;
    }
    else{
        radius = theBoardHeight;
    }
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"AtomicBomb" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//    [_gameBoard runAction:_nuke_Sound];
    
    [self Nuke_Splode];
    
    float nuke_time = 24.0f * 0.05f;
    float tenPercent = _theGameGrid.count;
    tenPercent *= 0.1f;
    
    [_gameBoard runAction:[SKAction sequence:@[[SKAction waitForDuration:(nuke_time*0.75f)+4.5f], [SKAction runBlock:^{
    
        for(int i=0; i<_theGameGrid.count;i++){
            
            CDGameBoardSpriteNode* piece = [_theGameGrid objectAtIndex:i];
            
            if(piece.isLocked){
                
                float waitTime = sqrtf(powf((piece.position.x - pointZero.x),2) + powf((piece.position.y - pointZero.y),2));
                
                waitTime = (waitTime/radius) * duration;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                    
                    [self LockBreak:piece];
                    
                }]]];
                
                [piece runAction:piecedeath];
                
            }else
            if(piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM && [piece isKindOfClass:[CDCookieSpriteNode class]]){
                
                float waitTime = sqrtf(powf((piece.position.x - pointZero.x),2) + powf((piece.position.y - pointZero.y),2));
                
                waitTime = (waitTime/radius) * duration;
                
                [_powerUpVictims addObject:piece];
                
                piece.shouldMilkSplash = NO;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                    
                    [self Put_a_milk_splash:piece.position Size:piece.size];
                    
                    // hurt plates
                    [self HurtPlates:piece Multiplier:1];
                    
                    [self Add_to_Score:_score_Per_powerupVictim Piece:piece];
                    
                }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                
                [piece runAction:piecedeath];
                
                
            }else if(piece.typeID == BLOCKER_ICECREAM){
                
                float waitTime = sqrtf(powf((piece.position.x - pointZero.x),2) + powf((piece.position.y - pointZero.y),2));
                
                waitTime = (waitTime/radius) * duration;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                    [self HurtIcecream:(CDIcecreamSpriteNode*)piece Multiplier:1];
                }]]];
                
                [piece runAction:piecedeath];
                
            }else if (piece.typeID == BLOCKER_COOKIEDOUGH){
                
                float waitTime = sqrtf(powf((piece.position.x - pointZero.x),2) + powf((piece.position.y - pointZero.y),2));
                
                waitTime = (waitTime/radius) * duration;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                    [self HurtCookiedough:piece Multiplier:1];
                }]]];
                
                [piece runAction:piecedeath];
                
            }else if(piece.typeID == BLOCKER_PRETZEL && piece.shouldMilkSplash){
                
                piece.shouldMilkSplash = NO;
                
                float waitTime = sqrtf(powf((piece.position.x - pointZero.x),2) + powf((piece.position.y - pointZero.y),2));
                
                waitTime = (waitTime/radius) * duration;
                
                SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                    piece.shouldMilkSplash = YES;
                    [self HurtPretzel:piece Multiplier:1];
                }]]];
                
                [piece runAction:piecedeath];
                
            }

            
        }
        
        [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.5] completion:^{
            
            [self Powerup_deletion];
            
        }];
        
    }]]]];
}

-(void)NukeAfterMath
{
    [self SetTheGameGrid];

    int tenPercent = (int)_theVisiblePieces.count/10;
    
    for (int i=0; i<tenPercent; i++) {
        
        int index = arc4random() % _theVisiblePieces.count;
        CDGameBoardSpriteNode* piece = (CDGameBoardSpriteNode*) _theGameGrid[index];
        int counter = 0;
        BOOL isValid = NO;
        while (!isValid) {
            
            counter++;
            if(counter == 50){
                isValid = YES;
                break;
            }
            
            if([piece isKindOfClass:[CDCookieSpriteNode class]] &&
               ![_SuperCookies containsObject:piece] &&
               piece.typeID != BOOSTER_RADSPRINKLE &&
               piece.typeID != BOOSTER_SLOTMACHINE &&
               piece.typeID != POWERUP_SMORE
               ){
                
                [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                
                isValid = YES;
                
            }else{
                
                index = arc4random() % _theVisiblePieces.count;
                piece = (CDGameBoardSpriteNode*) _theGameGrid[index];
                
            }
        }
        
        
    }

    [_gameBoard runAction:[SKAction waitForDuration:0.25] completion:^{
    
        [self Scan_and_clear_the_grid_of_combos];
    
    }];
    
}

-(void)LosingDeletion{
    
    float to_the_top_duration = 1.0f;
    float to_the_sides_duration = 0.5f;
    
    _isTakingInput = NO;
    
    [self SetTheGameGrid];
    
    float halfTheBoardWidth = ((_numColumns * _columnWidth)*0.5) + (_columnWidth * 0.5);
    float numberOfRowsFloat = _numRows;
    
    for(int i=0; i<_theGameGrid.count;i++){
        
        CDGameBoardSpriteNode* piece = [_theGameGrid objectAtIndex:i];
        
        if(piece.typeID != CLEAR_BLOCK && piece.typeID != EMPTY_ITEM){
            
            piece.shouldMilkSplash = NO;
            
            float Row = piece.row;
            
            float waitTime = ((Row/numberOfRowsFloat)*to_the_top_duration);
            
            if(piece.position.x >= halfTheBoardWidth){
                
                waitTime += ((piece.position.x - halfTheBoardWidth)/halfTheBoardWidth) * to_the_sides_duration;
                
            }else{
                
                waitTime += ((halfTheBoardWidth - piece.position.x)/halfTheBoardWidth) * to_the_sides_duration;
                
            }
            
            SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],[SKAction runBlock:^{
                
                [self Put_a_milk_splash_inscene:[_scene convertPoint:piece.position fromNode:_gameBoard]Size:piece.size];

            }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
            
            [piece runAction:piecedeath];
            
        }
        
    }
}

-(void)Put_a_milk_splash_inscene:(CGPoint)point Size:(CGSize)size
{
    int randomHit = arc4random() % 3;//_splatSoundsArray.count;
    [_scene runAction:_splatSoundsArray[randomHit]];
    
    // Shockwave
    SKEmitterNode* shockwave = [_shockwaveParticle copy];
    shockwave.position = point;
    [shockwave setScale:0.5f];
    shockwave.zPosition = 2;
    [_scene addChild:shockwave];
    
    SKAction* deleteShockwave = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    [shockwave runAction:deleteShockwave];
    
    // Giblets 01
    SKEmitterNode* giblets01 = [_cookieGibletsParticle01 copy];
    giblets01.position = point;
    [giblets01 setScale:0.8f];
    giblets01.zPosition = 2;
    [_scene addChild:giblets01];
    
    SKAction* deleteGiblets01 = [SKAction sequence:@[[SKAction waitForDuration:giblets01.particleLifetime], [SKAction removeFromParent]]];
    [giblets01 runAction:deleteGiblets01];
    
    // Giblets 02
    SKEmitterNode* giblets02 = [_cookieGibletsParticle02 copy];
    giblets02.position = point;
    [giblets02 setScale:1.0f];
    giblets02.zPosition = 2;
    [_scene addChild:giblets02];
    
    SKAction* deleteGiblets02 = [SKAction sequence:@[[SKAction waitForDuration:giblets02.particleLifetime], [SKAction removeFromParent]]];
    [giblets02 runAction:deleteGiblets02];
    
    // Giblets 03
    SKEmitterNode* giblets03 = [_cookieGibletsParticle03 copy];
    giblets03.position = point;
    [giblets03 setScale:1.0f];
    giblets03.zPosition = 2;
    [_scene addChild:giblets03];
    
    SKAction* deleteGiblets03 = [SKAction sequence:@[[SKAction waitForDuration:giblets03.particleLifetime], [SKAction removeFromParent]]];
    [giblets03 runAction:deleteGiblets03];
    
    // Milk Drops
    SKEmitterNode* drops = [_milkDropsParticle copy];
    drops.position = point;
    [drops setScale:0.25f];
    drops.zPosition = 2;
    [_scene addChild:drops];
    
    SKAction* deleteDrops = [SKAction sequence:@[[SKAction waitForDuration:drops.particleLifetime], [SKAction removeFromParent]]];
    [drops runAction:deleteDrops];
    
    // Milk Splat
    SKEmitterNode* milksplat = [_milkSplatParticle copy];
    milksplat.position = point;
    [milksplat setScale:0.8f];
    milksplat.zPosition = 2;
    [_scene addChild:milksplat];
    
    SKAction* deleteMilkSplat = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    [milksplat runAction:deleteMilkSplat];
}

-(void)Board_Shuffle_second_attempt{
    
    _numFallingPieces = 0;
    
    _isTakingInput = NO;
    
    [self SetTheGameGrid];
    
    NSMutableArray* spotBools = [NSMutableArray new];
    
    for(int i=0; i<_theGameGrid.count; i++) {
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        if([piece isKindOfClass:[CDCookieSpriteNode class]] && !piece.isLocked)
            [spotBools addObject:[NSNumber numberWithInt:0]];
        else
            [spotBools addObject:[NSNumber numberWithInt:1]];
    }
    
    
    float gravity = _RowHeight * -150.0f;
    float framesPerSecond = 15.0f;
    float timePerFrame = 1.0f/framesPerSecond;
    
    // move them
    
    for(int i=0; i<_theGameGrid.count; i++){
        
        CDGameBoardSpriteNode* piece = _theGameGrid[i];
        
        if([piece isKindOfClass:[CDCookieSpriteNode class]] && !piece.isLocked){
            // find its new spot
            
            _numFallingPieces++;
            
            int newSpot = newSpot = arc4random() % spotBools.count;
            while ([spotBools[newSpot] intValue] == 1) {
                
                newSpot++;
                
                if (newSpot >= _theGameGrid.count) {
                    newSpot = 0;
                }
            }
            
            [spotBools replaceObjectAtIndex:newSpot withObject:[NSNumber numberWithInt:1]];
                
            
            float initialSpeed = _RowHeight * 40;
            
            float newRow = floorf(newSpot/_numColumns);
            float newColumn = newSpot-(newRow * _numColumns);
            CGPoint newPos = CGPointMake((newColumn * _columnWidth) +_columnWidth, (newRow * _RowHeight)+ _RowHeight);
            
            //CGPoint topPoint = CGPointMake((piece.position.x + newPos.x)* 0.5, topheight);
            
            //  float upDistance = topPoint.y - piece.position.y;
            //  float downDistance = topPoint.y - newPos.y;
            //  float totalDistance = upDistance + downDistance;
            
            //  float upDuration = upDistance/totalDistance;
            //  float downDuration = downDistance/totalDistance;
            
            //   upDuration *= duration;
            //   downDuration *= duration;
            
            piece.finalTarget = newPos;
            
            float XDisplacement = 0.0f;
            
            if((int)newColumn == piece.column){
                XDisplacement = 0.0f;
            }
            else
                if(newPos.x > piece.position.x){
                    XDisplacement = newPos.x - piece.position.x;
                }else{
                    XDisplacement = piece.position.x - newPos.x;
                }
            
            float YDisplacement = newPos.y - piece.position.y;
            
            
            while (![BLINDED_Math PHYSICS_CanHitPoint_X:XDisplacement Y:YDisplacement Velocity:initialSpeed Gravity:gravity])
            {
                initialSpeed += _RowHeight * 10;
                
            }
            
            float angle = 0.0f;
            
            if(newColumn == piece.column)
                angle = 0.0f;
            else
                angle = [BLINDED_Math PHYSICS_Find_Needed_Angle1_radians_X:XDisplacement Y:YDisplacement Velocity:initialSpeed Gravity:gravity];
            
            CGVector angleVect;
            
            if((int)newColumn == piece.column)
                angleVect = CGVectorMake(0, 1);
            else
                angleVect = [BLINDED_Math AngleToVector_radians:angle];
            
            if(newPos.x < piece.position.x){
                angleVect.dx *= -1.0f;
            }
            
            //float angle2 = [self FindAngle2_X:XDisplacement Y:YDisplacement Velocity:initialSpeed Gravity:gravity];
            
            piece.fakePhysics = CGVectorMake(0, 0);
            piece.fakePhysics = CGVectorMake(angleVect.dx * initialSpeed, angleVect.dy * initialSpeed);
            
            [self SpatulaMovePiece:piece Gravity:gravity timePerFrame:timePerFrame StepCounter:0];
            
        }
    }
    
}
             
-(void)SpatulaMovePiece:(CDGameBoardSpriteNode*)piece Gravity:(float)gravity timePerFrame:(float)duration StepCounter:(int)stepCounter{
    
    
    if(stepCounter >= 30){
        
        DebugLog(@"\n\t %f : %f \n\t", piece.finalTarget.x, piece.finalTarget.y);
        
        piece.hidden = NO;
        piece.alpha = 1;
        
        piece.position = piece.finalTarget;
            
        _numFallingPieces--;
        
        if(_numFallingPieces <= 0)
            [self Scan_and_clear_the_grid_of_combos];
        
    
        return;
    }
    
 
    CGVector movementVect = CGVectorMake(piece.fakePhysics.dx * duration, piece.fakePhysics.dy * duration);
    
    float distance = sqrtf(powf((piece.position.x - piece.finalTarget.x),2.0f) + powf((piece.position.y - piece.finalTarget.y),2.0f));
    float magnitude = sqrtf(powf(movementVect.dx, 2.0f) + powf(movementVect.dy, 2.0f));
    
    if(piece.position.x <= 0 || piece.position.x >= (_numColumns+1) * _columnWidth) { // left, right
        
        [piece runAction:[SKAction moveTo:piece.finalTarget duration:duration] completion:^{
            
            _numFallingPieces--;
            
            if(_numFallingPieces <= 0)
                [self Scan_and_clear_the_grid_of_combos];
            
        }];
        
    }else if(distance <= magnitude && piece.fakePhysics.dy <= 0){ // you are there
        
        [piece runAction:[SKAction moveTo:piece.finalTarget duration:duration] completion:^{
        
            _numFallingPieces--;
            
            if(_numFallingPieces <= 0)
               [self Scan_and_clear_the_grid_of_combos];
        
        }];
        
    }else if(piece.fakePhysics.dy <= 0 && piece.position.y <= piece.finalTarget.y){ // below target
        
        [piece runAction:[SKAction moveTo:piece.finalTarget duration:duration] completion:^{
            
            _numFallingPieces--;
            
            if(_numFallingPieces <= 0)
                [self Scan_and_clear_the_grid_of_combos];
            
        }];
        
    }else{
    
        [piece runAction:[SKAction sequence:@[[SKAction moveBy:movementVect duration:duration],[SKAction runBlock:^{
            
            piece.fakePhysics = CGVectorMake(piece.fakePhysics.dx, piece.fakePhysics.dy - (-gravity * duration));
        
            [self SpatulaMovePiece:piece Gravity:gravity timePerFrame:duration StepCounter:stepCounter+1];
        
        }]]]];
    }
    
}

-(void)Spatula{
    
    for(CDBombSpriteNode* bomb in _allBombs){
        bomb.justDropped = YES;
    }
    
    _playerIdleSeconds = 20;
    
    _isTakingInput = NO;
    
    _cookieDoughLord.isHurt = YES;
    
    //[self Spatula_Wand];
    
    [self Spatula_Wand_second_attempt];
    
}


#pragma mark - Power Up combo effects

-(void)Super_on_Super:(CDGameBoardSpriteNode*)firstPiece SecondPiece:(CDGameBoardSpriteNode*)secondPiece
{
//    [_scene runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_milky_wave_distorted" withFileType:@".m4a"]];
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_milky_wave_distorted" FileType:@"caf" volume:1]; //@"m4a" volume:1];
    
    firstPiece.isVulnerable = NO;
    secondPiece.isVulnerable = NO;
    
    secondPiece.position = firstPiece.position;
    
    // new
    
    int holding_row = secondPiece.row;
    int holding_column = secondPiece.column;

    secondPiece.row = firstPiece.row;
    secondPiece.column = firstPiece.column;
    
    [[CDCookieAnimationManager animationManager] SuperVertical:firstPiece];
    [[CDCookieAnimationManager animationManager] SuperHorizontal:secondPiece];
    
    
    
    if([[self checkForMilkStreamWithPiece:firstPiece] isEqualToString:KeyThemeDefault])
    {
        CGPoint milkPoint2 = CGPointMake(firstPiece.position.x,0);
        milkPoint2 = [_scene convertPoint:milkPoint2 fromNode:_gameBoard];
        milkPoint2.y = _scene.size.height * 0.5;
        
        [self Milkstream:_milkstream Position:milkPoint2 WidthScale:_columnWidth/2.0f Angle:0 Zpos:1 Duration:1.5f + 0.24f];
        
    }
    if ([[self checkForMilkStreamWithPiece:secondPiece] isEqualToString:KeyThemeDefault])
    {
        CGPoint milkPoint = CGPointMake(0,firstPiece.position.y);
        milkPoint = [_scene convertPoint:milkPoint fromNode:_gameBoard];
        milkPoint.x = _scene.size.width * 0.5f;
        
        [self Milkstream:_milkstream Position:milkPoint WidthScale:_columnWidth/2.0f Angle:90.0f * 0.01745329f Zpos:1 Duration:1.5f + 0.24f];
    }
    secondPiece.row = holding_row;
    secondPiece.column = holding_column;
}

- (NSString *)checkForMilkStreamWithPiece:(CDGameBoardSpriteNode *)piece
{
    NSString *theme = KeyThemeDefault;
    int pieceType = piece.typeID;
    
    switch (pieceType)
    {
        case COOKIE_CHIP:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].brownSuperLooks;
            break;
        }
        case COOKIE_BLUE:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].blueSuperLooks;
            break;
        }
        case COOKIE_ORANGE:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].orangeSuperLooks;
            break;
        }
        case COOKIE_YELLOW:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].yellowSuperLooks;
            break;
        }
        case COOKIE_GREEN:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].greenSuperLooks;
            break;
        }
        case COOKIE_PURPLE:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].purpleSuperLooks;
            break;
        }
        case COOKIE_RED:
        {
            theme = [SGPlayerPreferencesManager preferenceManager].redSuperLooks;
            break;
        }
        default:
            break;
    }
    return theme;
}

-(void)Super_on_Wrapper:(CDGameBoardSpriteNode*)piece SecondPiece:(CDGameBoardSpriteNode*)secondpiece
{
    
    float duration = 2.0f;
    
    float firstPartDuration = duration*0.25;
    float secondPartDuration = duration*0.75;
    
    CGRect portal_Rect;
    portal_Rect.origin = piece.position;
    portal_Rect.size = CGSizeMake(_columnWidth * 7, _columnWidth * 7);
    
    [self Portal:portal_Rect Duration_OUT:firstPartDuration Duration_IN:secondPartDuration];
    
    
    NSMutableArray* list = [NSMutableArray new];
    
    piece.isVulnerable = NO;
    piece.shouldMilkSplash = NO;
    secondpiece.isVulnerable = NO;
    secondpiece.shouldMilkSplash = NO;
    
    [list addObject:piece];
    [list addObject:secondpiece];
    
    CDGameBoardSpriteNode* superPiece;
    
    if([_SuperCookies containsObject:piece])
        superPiece = piece;
    else
        superPiece = secondpiece;
    
    CGPoint horMilkPoint = CGPointMake(0,piece.position.y);
    horMilkPoint = [_scene convertPoint:horMilkPoint fromNode:[SGGameManager gameManager].gameBoard];
    horMilkPoint.x = _scene.size.width * 0.5f;
    
    [self Milkstream:_wrappedMilkstream Position:horMilkPoint WidthScale:_columnWidth * 3.0f Angle:90.0f * 0.01745329f Zpos:0 Duration:1.5f + 0.24f];
    
    CGPoint vertMilkPoint = CGPointMake(piece.position.x,0);
    vertMilkPoint = [_scene convertPoint:vertMilkPoint fromNode:[SGGameManager gameManager].gameBoard];
    vertMilkPoint.y = _scene.size.height * 0.5;
    
    [self Milkstream:_wrappedMilkstream Position:vertMilkPoint WidthScale:_columnWidth * 3.0f Angle:0 Zpos:0 Duration:1.5f + 0.24f];
    
    NSMutableArray* counted = [NSMutableArray new];
    
    for (int column=piece.column - 1; column<=piece.column+1; column++)
        for(int row=_numRows-1; row>-1; row--)
            if(column < _numColumns && column > -1 && row < _numRows && row > -1)
            {
                CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns) + column];
                
                [counted addObject:checkPiece];
                
                if(checkPiece.isLocked)
                {
                    [self LockBreak:checkPiece];
                    
                }else
                if(checkPiece.isVulnerable){
                    
                    if([checkPiece isKindOfClass:[CDCookieSpriteNode class]]){
                        
                        checkPiece.isVulnerable = NO;
                        
                        if([_SuperCookies containsObject:checkPiece]){
                            
                            [_SuperCookies removeObject:checkPiece];
                            [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                
                                if(arc4random() % 2 == 0){
                                    [self Super_Horizontal:(CDCookieSpriteNode*)checkPiece];
                                }else{
                                    [self Super_Vertical:(CDCookieSpriteNode*)checkPiece];
                                }
                                
                            }];
                            
                        }else
                            if([_WrappedCookies containsObject:checkPiece]){
                                
                                [_WrappedCookies removeObject:checkPiece];
                                [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                    
                                    [self SingleWrapper:checkPiece];
                                    
                                }];
                                
                            }else{
                                
                                checkPiece.shouldMilkSplash = NO;
                                
                                [list addObject:checkPiece];
                                
                            }
                    }
                }else if(checkPiece.typeID == BLOCKER_ICECREAM){
                    
                    [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:1];
                    
                }else if (checkPiece.typeID == BLOCKER_COOKIEDOUGH){
                    
                    [self HurtCookiedough:checkPiece Multiplier:1];
                    
                }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                    
                    [self HurtPretzel:checkPiece Multiplier:1];
                    
                }
            }
    
    for (int column=0; column<_numColumns; column++)
        for(int row=piece.row +1; row >= piece.row-1; row--)
            if(column < _numColumns && column > -1 && row < _numRows && row > -1)
            {
                
                CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns) + column];
                
                if([counted containsObject:checkPiece])
                {
                    // do nothing
                }else
                if(checkPiece.isLocked){
                    
                    [self LockBreak:checkPiece];
                    
                }else
                if(checkPiece.isVulnerable){
                    
                    
                    if([checkPiece isKindOfClass:[CDCookieSpriteNode class]]){
                        
                        checkPiece.isVulnerable = NO;
                        
                        if([_SuperCookies containsObject:checkPiece]){
                            
                            [_SuperCookies removeObject:checkPiece];
                            [checkPiece runAction:[SKAction waitForDuration:0.25] completion:^{
                                
                                if(arc4random() % 2 == 0){
                                    [self Super_Horizontal:(CDCookieSpriteNode*)checkPiece];
                                }else{
                                    [self Super_Vertical:(CDCookieSpriteNode*)checkPiece];
                                }
                                
                            }];
                            
                        }else
                            if([_WrappedCookies containsObject:checkPiece]){
                                
                                [_WrappedCookies removeObject:checkPiece];
                                [checkPiece runAction:[SKAction waitForDuration:0.25] completion:^{
                                    
                                    [self SingleWrapper:checkPiece];
                                    
                                }];
                                
                            }else
                            {
                                
                                checkPiece.shouldMilkSplash = NO;
                                
                                [list addObject:checkPiece];
                                
                            }
                    }
                }else if(checkPiece.typeID == BLOCKER_ICECREAM){
                    
                    [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:1];
                    
                }else if (checkPiece.typeID == BLOCKER_COOKIEDOUGH){
                    
                    [self HurtCookiedough:checkPiece Multiplier:1];
                    
                }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                    
                    [self HurtPretzel:checkPiece Multiplier:1];
                
                }
            }

    // make the super Fly
    
    [[CDCookieAnimationManager animationManager] SuperVertical:superPiece];
    
    // make them move
    
    float radius = 0;
    
    float halfTheBoardWidth = (_numColumns * _columnWidth);
    float halfTheBoardHeight = (_numRows * _RowHeight);
    
    if(_numColumns >= _numRows){
        
        radius = halfTheBoardWidth;
        
    }
    else{
        
        radius = halfTheBoardHeight;
        
    }
    
    for(CDGameBoardSpriteNode* portalVictim in list) {
        
        if(portalVictim != superPiece){
        
            float distance = sqrtf(powf((portalVictim.position.x - piece.position.x),2) + powf((portalVictim.position.y - piece.position.y),2));
            
            float waitTime = (distance/radius) * firstPartDuration;
            float travelTime = duration - waitTime;
            
            portalVictim.shouldMilkSplash = NO;
            
            SKAction* movement_and_scaling = [SKAction group:@[[SKAction moveTo:piece.position duration:travelTime*0.75],
                                                               [SKAction scaleTo:0 duration:travelTime]
                                                               ]];
            
            SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                        [SKAction runBlock:^{
                
                [self Area_Effect:portalVictim Multiplier:1];
                
                [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:portalVictim];
                
                if([_WrappedCookies containsObject:portalVictim]){
                    [self Add_to_Score:_score_Per_wrapped Piece:portalVictim];
                }
                else
                    [self Add_to_Score:_score_Per_powerupVictim Piece:portalVictim];
                
            }],movement_and_scaling]];
            
            [portalVictim runAction:piecedeath];
        
        }
    }
    
    
    if(list.count > 0){
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        _numActivePowerUps++;
        
        [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.1] completion:^{
            
            _numActivePowerUps--;
            
            if(_numActivePowerUps <= 0)
            {
                _numActivePowerUps = 0;
                
                [self Powerup_deletion];
            }
        }];
        
    }else{
        
    }
    
}

-(void)Wrapper_on_Wrapper:(CDGameBoardSpriteNode*)piece secondPiece:(CDGameBoardSpriteNode*)secondPiece
{
    
    float duration = 2.0f;
    
    float firstPartDuration = duration*0.25;
    float secondPartDuration = duration*0.75;
    
    
    CGRect portal_Rect;
    portal_Rect.origin = piece.position;
    portal_Rect.size = CGSizeMake(_columnWidth * 6, _columnWidth * 6);
    
    [self Portal:portal_Rect Duration_OUT:firstPartDuration Duration_IN:secondPartDuration];
    
    
    NSMutableArray* list = [NSMutableArray new];
    
    [list addObject:piece];
    [list addObject:secondPiece];
    
    piece.isVulnerable = NO;
    piece.shouldMilkSplash = NO;
    secondPiece.isVulnerable = NO;
    secondPiece.shouldMilkSplash = NO;
    
    
    for (int column=piece.column - 2; column<=piece.column+2; column++)
        for(int row=piece.row + 2; row>=piece.row-2; row--)
            if(column < _numColumns && column > -1 && row < _numRows && row > -1)
            {
                
                CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns) + column];
                
                if(checkPiece.isLocked){
                    
                    [self LockBreak:checkPiece];
                    
                }else if(checkPiece.isVulnerable){
                    
                    if([checkPiece isKindOfClass:[CDCookieSpriteNode class]]){
                        
                        checkPiece.isVulnerable = NO;
                        
                        if([_SuperCookies containsObject:checkPiece]){
                            
                            [_SuperCookies removeObject:checkPiece];
                            [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                
                                if(arc4random() % 2 == 0){
                                    [self Super_Horizontal:(CDCookieSpriteNode*)checkPiece];
                                }else{
                                    [self Super_Vertical:(CDCookieSpriteNode*)checkPiece];
                                }
                                
                            }];
                            
                        }else
                            if([_WrappedCookies containsObject:checkPiece]){
                                
                                [_WrappedCookies removeObject:checkPiece];
                                [checkPiece runAction:[SKAction waitForDuration:0.5] completion:^{
                                    
                                    [self SingleWrapper:checkPiece];
                                    
                                }];
                                
                            }
                            else{
                                
                                [list addObject:checkPiece];
                                
                            }
                    }
                }else if(checkPiece.typeID == BLOCKER_ICECREAM){
                    
                    [self HurtIcecream:(CDIcecreamSpriteNode*)checkPiece Multiplier:1];
                    
                }else if (checkPiece.typeID == BLOCKER_COOKIEDOUGH){
                    
                    [self HurtCookiedough:checkPiece Multiplier:1];
                    
                }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                    
                    [self HurtPretzel:checkPiece Multiplier:1];
                    
                }
            }
    
    // make them move
    
    float radius = 3 * _columnWidth;
    
    for(CDGameBoardSpriteNode* portalVictim in list) {
        
        float distance = sqrtf(powf((portalVictim.position.x - piece.position.x),2) + powf((portalVictim.position.y - piece.position.y),2));
        
        float waitTime = (distance/radius) * firstPartDuration;
        float travelTime = duration - waitTime;
        
        portalVictim.shouldMilkSplash = NO;
        
        SKAction* movement_and_scaling = [SKAction group:@[[SKAction moveTo:piece.position duration:travelTime*0.75],
                                                           [SKAction scaleTo:0 duration:travelTime]
                                                           ]];
        
        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:waitTime],
                                                    [SKAction runBlock:^{
            [self Area_Effect:portalVictim Multiplier:1];
            [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:portalVictim];
            
            if(portalVictim == piece || portalVictim == secondPiece){
                [self Add_to_Score:_score_Per_wrapped Piece:portalVictim];
            }
            else
                [self Add_to_Score:_score_Per_powerupVictim Piece:portalVictim];
            
        }],
                                                    movement_and_scaling]];
        
        [portalVictim runAction:piecedeath];
        
        
    }
    
    if(list.count > 0){
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        _numActivePowerUps++;
        
        [self.gameBoard runAction:[SKAction waitForDuration:duration + 0.1] completion:^{
            
            _numActivePowerUps--;
            
            if(_numActivePowerUps <= 0)
            {
                _numActivePowerUps = 0;
                
                [self Powerup_deletion];
            }
        }];
        
    }else{
        
    }
    
}

-(void)Smore_on_Super:(CDGameBoardSpriteNode*)theSmore Target:(CDGameBoardSpriteNode*)target
{
    
    theSmore.isVulnerable = NO;
    
    float duration = 1.0f;
    
    ItemType type = target.typeID;
    
    NSMutableArray* list = [NSMutableArray new];
    
    for(int column=_numColumns-1; column>-1; column--)
        for(int row=_numRows-1; row>-1; row--)
        {
            
            CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns)+column];
            
            if(checkPiece.typeID == type){
                
                [list addObject:checkPiece];
                checkPiece.isVulnerable = NO;
                
            }
            else
                if(theSmore == checkPiece){
                    
                    [list addObject:checkPiece];
                }
        }
    
    // lightning
    SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction removeFromParent]]];
    SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:duration+1],[SKAction removeFromParent]]];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_smore_effect" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//    [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_smore_effect" withFileType:@".m4a"]];
    
    for (int i=0; i<list.count; i++)
    {
        
        CDGameBoardSpriteNode* currentPiece = [list objectAtIndex:i];
        CDGameBoardSpriteNode* previousPiece;
        
        if(i == 0)
            previousPiece = [list objectAtIndex:list.count-1];
        else
            previousPiece = [list objectAtIndex:i-1];
        
        
        CGVector lookDirection = CGVectorMake(previousPiece.position.x - currentPiece.position.x, previousPiece.position.y - currentPiece.position.y);
        
        float Distance = sqrtf( powf(lookDirection.dx, 2) + powf(lookDirection.dy, 2));
        
        float angle = atan2f(lookDirection.dy - 0.0f, lookDirection.dx - 1.0f);
        
        angle -= 90.0f * 0.01745329;
        
        CGPoint Midway = CGPointMake((previousPiece.position.x + currentPiece.position.x)*0.5, (previousPiece.position.y + currentPiece.position.y)*0.5);
        
        Midway = [self.scene convertPoint:Midway fromNode:self.gameBoard];
        
        SKNode * link = [self Lightning:Midway Length:Distance Angle:angle ZPos:currentPiece.zPosition+2 PlayAudio:NO];
        
        [link runAction:lightning_removal];
        
        // sparks
        {
            SKEmitterNode* sparks = [_Lightning_Sparks copy];
            
            sparks.position = link.position;
            sparks.zRotation = angle;
            sparks.zPosition = currentPiece.zPosition+2;
            
            sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
            sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
            sparks.particleSpeedRange = _cookieWidth * 10;
            
            sparks.numParticlesToEmit = sparks.particleBirthRate * duration;
            
            [self.scene addChild:sparks];
            
            [sparks runAction:sparks_removal];
        }
        
        currentPiece.zPosition += 4;
        
        // the piece's electric glow
        {
            SKSpriteNode* frontPiece = [_LightningCookieFront copy];
            SKSpriteNode* backPiece = [_LightningCookieBack copy];
            
            [_scene addChild:frontPiece];
            [_scene addChild:backPiece];
            
            CGPoint piecePos = [_scene convertPoint:currentPiece.position fromNode:_gameBoard];
            
            frontPiece.position = piecePos;
            backPiece.position = piecePos;
            
            frontPiece.zPosition = currentPiece.zPosition+1;
            backPiece.zPosition = currentPiece.zPosition-1;
            
            frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
            backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
            
            [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
            [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:duration], lightning_removal]]];
            
            
        }
    }
    
    // make them go away
    
    for (CDGameBoardSpriteNode* piece in list) {
        
        piece.shouldMilkSplash = NO;
        piece.isVulnerable = NO;
        [piece removeAllActions];

        if([_WrappedCookies containsObject:piece]){
            
            [_WrappedCookies removeObject:piece];
            
            [piece runAction:[SKAction waitForDuration:duration] completion:^{
                
                [self SingleWrapper:piece];
                
            }];
            
        }else{
            
            SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
                [self PlaySwitchAnimation:piece];
            }],[SKAction waitForDuration:duration-0.24],
                                                                         [SKAction runBlock:^{
                [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:piece];
                
            }]]], // group
                                                    [SKAction sequence:@[
                                                                         [SKAction waitForDuration:0.12],
                                                                         [SKAction repeatAction:[SKAction sequence:@[
                                                                                                                     [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:piece];}],
                                                                                                                     [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                                                     
                                                                                                                     ]] count:(int) ((duration - 0.36)/0.2) + 1]
                                                                         ]]
                                                    ]];
            
            
            SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
                
                if(piece == theSmore){
                
                    [self Put_a_milk_splash:piece.position Size:piece.size];
                    
                    // hurt plates
                    [self Area_Effect:piece Multiplier:1];
                    
                    [self Add_to_Score:_score_Per_smore Piece:piece];
                    
                    [piece runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]]];
                    
                }else{
                    
                    [_gameBoard runAction:[SKAction sequence:@[[SKAction runBlock:^{
                    
                        [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                        
                        [_SuperCookies removeObject:piece];
                    
                    }],[SKAction waitForDuration:0.25],[SKAction runBlock:^{
                        
                        if(arc4random() % 2 == 0){
                            
                            [self Super_Horizontal:(CDCookieSpriteNode*)piece];
                        }else{
                            [self Super_Vertical:(CDCookieSpriteNode*)piece];
                        }

                    
                    }]]]];
                }
                
            }]]];
            
            [piece removeAllActions];
            
            [piece runAction:piecedeath];
            [piece runAction:pieceface];
            
        }
    }
    
    [_powerUpVictims addObject:theSmore];
    
}

-(void)Smore_on_Wrapper:(CDGameBoardSpriteNode*)theSmore Target:(CDGameBoardSpriteNode*)target
{
    
    theSmore.isVulnerable = NO;
    
    float duration = 1.0f;
    
    ItemType type = target.typeID;
    
    NSMutableArray* list = [NSMutableArray new];
    
    for(int column=_numColumns-1; column>-1; column--)
        for(int row=_numRows-1; row>-1; row--)
        {
            
            CDGameBoardSpriteNode* checkPiece = [_theGameGrid objectAtIndex:(row * _numColumns)+column];
            
            if(checkPiece.typeID == type){
                
                [list addObject:checkPiece];
                checkPiece.isVulnerable = NO;
                
            }
            else
                if(theSmore == checkPiece){
                    
                    [list addObject:checkPiece];
                }
        }
    
    // lightning
    SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction removeFromParent]]];
    SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:duration+1],[SKAction removeFromParent]]];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_smore_effect" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//    [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_smore_effect" withFileType:@".m4a"]];
    
    for (int i=0; i<list.count; i++)
    {
        
        CDGameBoardSpriteNode* currentPiece = [list objectAtIndex:i];
        CDGameBoardSpriteNode* previousPiece;
        
        if(i == 0)
            previousPiece = [list objectAtIndex:list.count-1];
        else
            previousPiece = [list objectAtIndex:i-1];
        
        
        CGVector lookDirection = CGVectorMake(previousPiece.position.x - currentPiece.position.x, previousPiece.position.y - currentPiece.position.y);
        
        float Distance = sqrtf( powf(lookDirection.dx, 2) + powf(lookDirection.dy, 2));
        
        float angle = atan2f(lookDirection.dy - 0.0f, lookDirection.dx - 1.0f);
        
        angle -= 90.0f * 0.01745329;
        
        CGPoint Midway = CGPointMake((previousPiece.position.x + currentPiece.position.x)*0.5, (previousPiece.position.y + currentPiece.position.y)*0.5);
        
        Midway = [self.scene convertPoint:Midway fromNode:self.gameBoard];
        
        SKNode * link = [self Lightning:Midway Length:Distance Angle:angle ZPos:currentPiece.zPosition+2 PlayAudio:NO];
        
        [link runAction:lightning_removal];
        
        // sparks
        {
            SKEmitterNode* sparks = [_Lightning_Sparks copy];
            
            sparks.position = link.position;
            sparks.zRotation = angle;
            sparks.zPosition = currentPiece.zPosition+2;
            
            sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
            sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
            sparks.particleSpeedRange = _cookieWidth * 10;
            
            sparks.numParticlesToEmit = sparks.particleBirthRate * duration;
            
            [self.scene addChild:sparks];
            
            [sparks runAction:sparks_removal];
        }
        
        currentPiece.zPosition += 4;
        
        // the piece's electric glow
        {
            SKSpriteNode* frontPiece = [_LightningCookieFront copy];
            SKSpriteNode* backPiece = [_LightningCookieBack copy];
            
            [_scene addChild:frontPiece];
            [_scene addChild:backPiece];
            
            CGPoint piecePos = [_scene convertPoint:currentPiece.position fromNode:_gameBoard];
            
            frontPiece.position = piecePos;
            backPiece.position = piecePos;
            
            frontPiece.zPosition = currentPiece.zPosition+1;
            backPiece.zPosition = currentPiece.zPosition-1;
            
            frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
            backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
            
            [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
            [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:duration], lightning_removal]]];
            
            
        }
    }
    
    // make them go away
    
    for (CDGameBoardSpriteNode* piece in list) {
        
        piece.shouldMilkSplash = NO;
        piece.isVulnerable = NO;
        [piece removeAllActions];
        
        if([_SuperCookies containsObject:piece]){
            
            [_SuperCookies removeObject:piece];
            
            [piece runAction:[SKAction waitForDuration:duration] completion:^{
                
                [self SuperSizeThatCookie:(CDCookieSpriteNode*)piece];
                
            }];
            
        }else{
            
            SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
                [self PlaySwitchAnimation:piece];
            }],[SKAction waitForDuration:duration-0.24],
                                                                         [SKAction runBlock:^{
                [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:piece];
                
            }]]], // group
                                                    [SKAction sequence:@[
                                                                         [SKAction waitForDuration:0.12],
                                                                         [SKAction repeatAction:[SKAction sequence:@[
                                                                                                                     [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:piece];}],
                                                                                                                     [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                                                     
                                                                                                                     ]] count:(int) ((duration - 0.36)/0.2) + 1]
                                                                         ]]
                                                    ]];
            
            
            SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:duration],[SKAction runBlock:^{
                
                if(piece == theSmore){
                    
                    [self Put_a_milk_splash:piece.position Size:piece.size];
                    
                    // hurt plates
                    [self Area_Effect:piece Multiplier:1];
                    
                    [self Add_to_Score:_score_Per_smore Piece:piece];
                    
                    [piece runAction:[SKAction sequence:@[[SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]]];
                    
                }else{
                    
                    [_gameBoard runAction:[SKAction sequence:@[[SKAction runBlock:^{
                        
                        [self Wrap_that_cookie:(CDCookieSpriteNode*)piece];
                        
                        [_WrappedCookies removeObject:piece];
                        
                    }],[SKAction waitForDuration:0.25],[SKAction runBlock:^{
                        
                        [self SingleWrapper:piece];
                        
                    }]]]];
                }
                
            }]]];
            
            [piece removeAllActions];
            
            [piece runAction:piecedeath];
            [piece runAction:pieceface];
            
        }
    }
    
    [_powerUpVictims addObject:theSmore];
    
}

-(void)Smore_on_Smore:(CDGameBoardSpriteNode*)smoreOne SecondSmore:(CDGameBoardSpriteNode*)secondSmore
{
    
    NSMutableArray* list = [NSMutableArray new];
    
    float columnDuration = 2.0f;
    
    int theGreatestDistance = smoreOne.column;
    int valueTwo = (_numColumns-1) - smoreOne.column;
    
    if(theGreatestDistance < valueTwo+1){
        theGreatestDistance = valueTwo+1;
    }
    
    theGreatestDistance++;
    
    for(int i=0; i<theGreatestDistance; i++){
        
        NSMutableArray* column_of_cookies = [NSMutableArray new];
        for(int row=0; row<_numRows; row++){
            int column = smoreOne.column + i;
            if(column > -1 && column < _numColumns){
                CDGameBoardSpriteNode* checkPiece = _theGameGrid[(row * _numColumns) + column];
                
                if(checkPiece.isLocked){
                    
                    [checkPiece runAction:[SKAction sequence:@[[SKAction waitForDuration:i*(columnDuration * 0.25)],
                                                               [SKAction runBlock:^{
                    
                        [self LockBreak:checkPiece];
                    
                    }]]]];
                    
                }else
                if(checkPiece.isVulnerable){
                    if([checkPiece isKindOfClass:[CDCookieSpriteNode class]] && ![_SuperCookies containsObject:checkPiece] && ![_WrappedCookies containsObject:checkPiece]){
                        
                        [column_of_cookies addObject:checkPiece];
            
                    }
                }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                    
                    checkPiece.shouldMilkSplash = NO;
                    [column_of_cookies addObject:checkPiece];
                    
                }else if(checkPiece == smoreOne || checkPiece == secondSmore){
                    
                    [column_of_cookies addObject:checkPiece];
                    
                }
            }
        }
        
        SKAction* lightUp_the_column = [SKAction sequence:@[
                                                            [SKAction waitForDuration:i*(columnDuration * 0.25)],
                                                            
        [SKAction runBlock:^{
            
            SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:columnDuration],[SKAction removeFromParent]]];
            SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:columnDuration+1],[SKAction removeFromParent]]];
            
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_smore_effect" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//            [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_smore_effect" withFileType:@".m4a"]];
            
            // lightning
            
            if(column_of_cookies.count > 1){
                
                CDGameBoardSpriteNode* currentPiece = column_of_cookies[0];
                CDGameBoardSpriteNode* previousPiece = column_of_cookies[column_of_cookies.count-1];
                
                CGVector lookDirection = CGVectorMake(previousPiece.position.x - currentPiece.position.x, previousPiece.position.y - currentPiece.position.y);
                
                float Distance = sqrtf( powf(lookDirection.dx, 2) + powf(lookDirection.dy, 2));

                
                CGPoint Midway = CGPointMake((previousPiece.position.x + currentPiece.position.x)*0.5, (previousPiece.position.y + currentPiece.position.y)*0.5);
                
                Midway = [self.scene convertPoint:Midway fromNode:self.gameBoard];
                
                SKNode * link = [self Lightning:Midway Length:Distance Angle:0 ZPos:currentPiece.zPosition+2];
                
                [link runAction:lightning_removal];
                
                // sparks
                {
                    SKEmitterNode* sparks = [_Lightning_Sparks copy];
                    
                    sparks.position = link.position;
                    sparks.zRotation = 0;
                    sparks.zPosition = currentPiece.zPosition+2;
                    
                    sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
                    sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
                    sparks.particleSpeedRange = _cookieWidth * 10;
                    
                    sparks.numParticlesToEmit = sparks.particleBirthRate * columnDuration;
                    
                    [self.scene addChild:sparks];
                    
                    [sparks runAction:sparks_removal];
                }
            }
            
            // pieces
            
            [list addObjectsFromArray:column_of_cookies];
            
            for (int rowCookie=0; rowCookie<column_of_cookies.count; rowCookie++) {
                
                CDGameBoardSpriteNode* currentPiece = column_of_cookies[rowCookie];
                
                currentPiece.zPosition += 4;
                currentPiece.isVulnerable = NO;
                currentPiece.shouldMilkSplash = NO;
                
                // piece death
                {
                    
                    SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
                        [self PlaySwitchAnimation:currentPiece];
                    }],[SKAction waitForDuration:columnDuration-0.24],
                                                                                 [SKAction runBlock:^{
                        [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:currentPiece];
                        
                    }]]], // group
                                                            [SKAction sequence:@[
                                                                                 [SKAction waitForDuration:0.12],
                                                                                 [SKAction repeatAction:[SKAction sequence:@[
                                                                                                                             [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:currentPiece];}],
                                                                                                                             [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                                                             
                                                                                                                             ]] count:(int) ((columnDuration - 0.36)/0.2) + 1]
                                                                                 ]]
                                                            ]];
                    
                    
                    SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:columnDuration],[SKAction runBlock:^{
                        
                        
                        if(currentPiece.isLocked)
                            [self LockBreak:currentPiece];
                        
                        // hurt plates
                        if(currentPiece.typeID != BLOCKER_PRETZEL){
                            [self Area_Effect:currentPiece Multiplier:1];
                            [self Put_a_milk_splash:currentPiece.position Size:currentPiece.size];
                            
                            if(currentPiece == smoreOne || currentPiece == secondSmore){
                                [self Add_to_Score:_score_Per_smore Piece:currentPiece];
                            }else{
                                [self Add_to_Score:_score_Per_powerupVictim Piece:currentPiece];
                            }
                            
                        }else{
                            currentPiece.shouldMilkSplash = YES;
                            [self HurtPretzel:currentPiece Multiplier:1];
                        }
                        
                        
                    }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                    
                    [currentPiece removeAllActions];
                    
                    [currentPiece runAction:piecedeath];
                    [currentPiece runAction:pieceface];
                    
                }
                
                // the piece's electric glow
                {
                    SKSpriteNode* frontPiece = [_LightningCookieFront copy];
                    SKSpriteNode* backPiece = [_LightningCookieBack copy];
                    
                    [_scene addChild:frontPiece];
                    [_scene addChild:backPiece];
                    
                    CGPoint piecePos = [_scene convertPoint:currentPiece.position fromNode:_gameBoard];
                    
                    frontPiece.position = piecePos;
                    backPiece.position = piecePos;
                    
                    frontPiece.zPosition = currentPiece.zPosition+1;
                    backPiece.zPosition = currentPiece.zPosition-1;
                    
                    frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
                    backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
                    
                    [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
                    [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:columnDuration], lightning_removal]]];
                    
                    
                }
            }
            
        
        }]]]; // lightUp_the_column
        
        
        [_gameBoard runAction:lightUp_the_column];
        
        
        if(i > 0){
            NSMutableArray* other_column = [NSMutableArray new];
            for(int row=0; row<_numRows; row++){
                int column = smoreOne.column - i;
                if(column > -1 && column < _numColumns){
                    CDGameBoardSpriteNode* checkPiece = _theGameGrid[(row * _numColumns) + column];
                    if(checkPiece.isLocked){
                        
                        [checkPiece runAction:[SKAction sequence:@[[SKAction waitForDuration:i*(columnDuration * 0.25)],
                                                                   [SKAction runBlock:^{
                            
                            [self LockBreak:checkPiece];
                            
                        }]]]];
                        
                    }else
                    if(checkPiece.isVulnerable){
                        if([checkPiece isKindOfClass:[CDCookieSpriteNode class]] && ![_SuperCookies containsObject:checkPiece] && ![_WrappedCookies containsObject:checkPiece]){
                            
                            [other_column addObject:checkPiece];
                        }
                    }else if(checkPiece.typeID == BLOCKER_PRETZEL && checkPiece.shouldMilkSplash){
                        
                        checkPiece.shouldMilkSplash = NO;
                        [other_column addObject:checkPiece];
                        
                    }else if(checkPiece == smoreOne || checkPiece == secondSmore){
                        
                        [other_column addObject:checkPiece];
                        
                    }
                }
            }
            
            SKAction* lightUp_the_other_column = [SKAction sequence:@[
                                                                [SKAction waitForDuration:i*(columnDuration * 0.25)],
                                                                
                                                                [SKAction runBlock:^{
                
                SKAction* lightning_removal = [SKAction sequence:@[[SKAction waitForDuration:columnDuration],[SKAction removeFromParent]]];
                SKAction* sparks_removal = [SKAction sequence:@[[SKAction waitForDuration:columnDuration+1],[SKAction removeFromParent]]];
                
                [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_smore_effect" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//                [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_smore_effect" withFileType:@".m4a"]];
                
                // lightning
                
                if(other_column.count > 1){
                    
                    CDGameBoardSpriteNode* currentPiece = other_column[0];
                    CDGameBoardSpriteNode* previousPiece = other_column[other_column.count-1];
                    
                    CGVector lookDirection = CGVectorMake(previousPiece.position.x - currentPiece.position.x, previousPiece.position.y - currentPiece.position.y);
                    
                    float Distance = sqrtf( powf(lookDirection.dx, 2) + powf(lookDirection.dy, 2));
                    
                    
                    CGPoint Midway = CGPointMake((previousPiece.position.x + currentPiece.position.x)*0.5, (previousPiece.position.y + currentPiece.position.y)*0.5);
                    
                    Midway = [self.scene convertPoint:Midway fromNode:self.gameBoard];
                    
                    SKNode * link = [self Lightning:Midway Length:Distance Angle:0 ZPos:currentPiece.zPosition+2];
                    
                    [link runAction:lightning_removal];
                    
                    // sparks
                    {
                        SKEmitterNode* sparks = [_Lightning_Sparks copy];
                        
                        sparks.position = link.position;
                        sparks.zRotation = 0;
                        sparks.zPosition = currentPiece.zPosition+2;
                        
                        sparks.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
                        sparks.particlePositionRange = CGVectorMake(_cookieWidth, Distance);
                        sparks.particleSpeedRange = _cookieWidth * 10;
                        
                        sparks.numParticlesToEmit = sparks.particleBirthRate * columnDuration;
                        
                        [self.scene addChild:sparks];
                        
                        [sparks runAction:sparks_removal];
                    }
                }
                
                // pieces
                
                [list addObjectsFromArray:other_column];
                
                for (int rowCookie=0; rowCookie<other_column.count; rowCookie++) {
                    
                    CDGameBoardSpriteNode* currentPiece = other_column[rowCookie];
                    
                    currentPiece.zPosition += 4;
                    currentPiece.isVulnerable = NO;
                    currentPiece.shouldMilkSplash = NO;
                    
                    // piece death
                    {
                        
                        SKAction* pieceface = [SKAction group:@[[SKAction sequence:@[[SKAction runBlock:^{
                            [self PlaySwitchAnimation:currentPiece];
                        }],[SKAction waitForDuration:columnDuration-0.24],
                                                                                     [SKAction runBlock:^{
                            [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:currentPiece];
                            
                        }]]], // group
                                                                [SKAction sequence:@[
                                                                                     [SKAction waitForDuration:0.12],
                                                                                     [SKAction repeatAction:[SKAction sequence:@[
                                                                                                                                 [SKAction runBlock:^{[[CDCookieAnimationManager animationManager] PlayShockerAnimation:currentPiece];}],
                                                                                                                                 [SKAction waitForDuration:0.3 withRange:0.2]
                                                                                                                                 
                                                                                                                                 ]] count:(int) ((columnDuration - 0.36)/0.2) + 1]
                                                                                     ]]
                                                                ]];
                        
                        
                        SKAction* piecedeath = [SKAction sequence:@[[SKAction waitForDuration:columnDuration],[SKAction runBlock:^{
                            
                            if(currentPiece.isLocked)
                                [self LockBreak:currentPiece];
                            
                            // hurt plates
                            if(currentPiece.typeID != BLOCKER_PRETZEL){
                                [self Area_Effect:currentPiece Multiplier:1];
                                [self Put_a_milk_splash:currentPiece.position Size:currentPiece.size];
                                
                                if(currentPiece == smoreOne || currentPiece == secondSmore){
                                    [self Add_to_Score:_score_Per_smore Piece:currentPiece];
                                }else{
                                    [self Add_to_Score:_score_Per_powerupVictim Piece:currentPiece];
                                }
                                
                            }else{
                                currentPiece.shouldMilkSplash = YES;
                                [self HurtPretzel:currentPiece Multiplier:1];
                            }

                            
                        }], [SKAction waitForDuration:0.1f],[SKAction fadeAlphaTo:0 duration:0]]];
                        
                        [currentPiece removeAllActions];
                        
                        [currentPiece runAction:piecedeath];
                        [currentPiece runAction:pieceface];
                        
                    }
                    
                    // the piece's electric glow
                    {
                        SKSpriteNode* frontPiece = [_LightningCookieFront copy];
                        SKSpriteNode* backPiece = [_LightningCookieBack copy];
                        
                        [_scene addChild:frontPiece];
                        [_scene addChild:backPiece];
                        
                        CGPoint piecePos = [_scene convertPoint:currentPiece.position fromNode:_gameBoard];
                        
                        frontPiece.position = piecePos;
                        backPiece.position = piecePos;
                        
                        frontPiece.zPosition = currentPiece.zPosition+1;
                        backPiece.zPosition = currentPiece.zPosition-1;
                        
                        frontPiece.size = CGSizeMake(_cookieWidth * 2, _cookieHeight * 2);
                        backPiece.size = CGSizeMake(_cookieWidth, _cookieHeight);
                        
                        [frontPiece runAction:[SKAction group:@[_LightningCookieFrontAction,[SKAction rotateByAngle:-6.2831844f duration:10], lightning_removal]]];
                        [backPiece runAction:[SKAction group:@[[SKAction scaleTo:2.5 duration:columnDuration], lightning_removal]]];
                        
                        
                    }
                }
                
                
            }]]]; // lightUp_the_column
            
            [_gameBoard runAction:lightUp_the_other_column];
            
        }// (i > 0)
    }

    [self.powerUpVictims addObjectsFromArray:list];
    
    [self.gameBoard runAction:[SKAction waitForDuration:((theGreatestDistance * (columnDuration * 0.25)) + columnDuration) + 0.1] completion:^{
        
        [self.powerUpVictims addObjectsFromArray:list];
        
        [self Powerup_deletion];
        
    }];

    
}

#pragma mark - slotmachine

-(void)SlotThatCookie:(CDCookieSpriteNode*)cookie
{
    _playerIdleSeconds = 20;
    
    [cookie removeAllChildren];
    cookie.isVulnerable = NO;
    cookie.typeID = BOOSTER_SLOTMACHINE;
    CGSize cookieSize = CGSizeMake(_cookieWidth, _cookieHeight);
    
    cookie.size = cookieSize;
    
    // crop node
    SKCropNode *cropNode = [SKCropNode node];
    
    // crop mask
    SKSpriteNode *mask = [SKSpriteNode spriteNodeWithImageNamed:@"SlotMachine_mask"];
    mask.size = cookieSize;
    mask.position = CGPointMake(0.0f,0.0f);
    cropNode.maskNode = mask;
    
    // slot background
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithColor:[SKColor whiteColor] size:cookieSize];
    sprite.name = @"background";
    [cropNode addChild:sprite];
    
    // add cropNode to the cookie
    [cookie addChild:cropNode];
    
    float speed = 3.0f;
    
    for(int i=0; i<self.slotmachineSlides.count; i++)
    {
        SKSpriteNode* slide = [SKSpriteNode spriteNodeWithTexture:[self.slotmachineSlides objectAtIndex:i] size:cookieSize];
        
        slide.position = CGPointMake(0, (i+1) * cookieSize.height);
        
        [cropNode addChild:slide];
        
        // initial movement
        SKAction * initialMovemevent = [SKAction sequence:@[[SKAction moveToY:-cookieSize.height duration:(slide.position.y/cookieSize.height)/speed], [SKAction runBlock:^{
            
            slide.position = CGPointMake(0.0f, (self.slotmachineSlides.count) * cookieSize.height);
            
        }]]];
        
        SKAction * repeatedMovemevent = [SKAction sequence:@[[SKAction moveToY:-cookieSize.height duration:(self.slotmachineSlides.count)/speed], [SKAction runBlock:^{
            
            slide.position = CGPointMake(0.0f, (self.slotmachineSlides.count) * cookieSize.height);
            
        }]]];
        
        [slide runAction:[SKAction sequence:@[initialMovemevent, [SKAction repeatActionForever:repeatedMovemevent]]]];
    }
    
    
    // the top layer of the slot machine
    SKSpriteNode* frame = [SKSpriteNode spriteNodeWithImageNamed:@"SlotMachine"];
    frame.size = cookieSize;
    
    [cookie addChild:frame];
    
    self.numActiveSlotMachines += 1;
    if (!_slotRollSoundIsPlaying) {
        self.slotRollSoundIsPlaying = YES;
        self.slotMachineRollPlayer = [[SGAudioManager audioManager] playSoundEffectWithFilename:@"SlotRoll" FileType:@"caf" volume:1.0f numberOfLoopes:-1];
    }
    
}

-(void)StopThatSlotCookie:(CDCookieSpriteNode*)slotCookie
{
    
    for(CDBombSpriteNode* bomb in _allBombs){
        bomb.justDropped = YES;
    }

    _cookieDoughLord.isHurt = YES;
    
    _isTakingInput = NO;
    
    SKCropNode* roller = [slotCookie.children objectAtIndex:0];
    
    SKSpriteNode* winner = nil;
    
    // the quick stop gitter
    for(int i=1;i<roller.children.count; i++)
    {
        SKSpriteNode* currentSlide = [roller.children objectAtIndex:i];
        
        if(currentSlide.position.y <= (currentSlide.size.height*0.75f) && currentSlide.position.y >= -(currentSlide.size.height * 0.75f)){
            winner = currentSlide;
            
        }
        
        [currentSlide removeAllActions];
        [currentSlide  runAction:[SKAction sequence:@[
                                                      [SKAction moveByX:0.0f y:-(currentSlide.size.height*0.1f) duration:0.1f],
                                                      [SKAction moveByX:0.0f y:(currentSlide.size.height*0.1f) duration:0.25f]
                                                      ]]];
    }
    
    // puts the winner in the center
    
    float winner_displacement = winner.position.y * -1.0f;
    
    for(int i=1;i<roller.children.count; i++)
    {
        SKSpriteNode* currentSlide = [roller.children objectAtIndex:i];
        
        [currentSlide  runAction:[SKAction sequence:@[
                                                      [SKAction waitForDuration:0.35f],
                                                      [SKAction moveByX:0.0f y:winner_displacement duration:0.25f]
                                                      ]]];
        
    }
    
    // apply winner
    [slotCookie runAction:[SKAction sequence:@[[SKAction waitForDuration:0.6f],
                                               [SKAction runBlock:^{
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"SlotDing" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//        [_scene runAction:_slotDing];
        
        self.numActiveSlotMachines -= 1;
        if (_numActiveSlotMachines < 0) {
            _numActiveSlotMachines = 0;
        }
        
        if (_numActiveSlotMachines < 1) {
            [self.slotMachineRollPlayer stop];
            self.slotRollSoundIsPlaying = NO;
        }
        
        
        
        
        switch ([self.slotmachineSlides indexOfObject:winner.texture]) {
            case 0:{
                
                [self Smore_that_cookie:slotCookie];
                
                [slotCookie removeAllChildren];
                
                [self Scan_and_clear_the_grid_of_combos];
            }
                break;
            case 1:{
                
                [self WonLightning:slotCookie];
            }
                break;
            case 2:{
                [self Drop_The_Nuke];
                //slotCookie.shouldMilkSplash = NO;
                //slotCookie.alpha = 0;
            }
                break;
            case 3:{
                [slotCookie runAction:[SKAction waitForDuration:1.0f] completion:^{
                    
                    [self Randomize_this_Cookie:slotCookie];
                    [slotCookie removeAllChildren];
                }];
                
                [self Spatula]; // TODO Spatula
            }
                break;
            case 4:{
                
                [self Randomize_this_Cookie:slotCookie];
                
                [slotCookie removeAllChildren];
                [self SuperSizeThatCookie:slotCookie];
                
                [slotCookie runAction:[SKAction waitForDuration:0.5] completion:^{
                    
                    [self Scan_and_clear_the_grid_of_combos];
                }];
            }
                break;
            case 5:{
                
                slotCookie.isVulnerable = NO;
                
                slotCookie.typeID = BOOSTER_RADSPRINKLE;
                
                slotCookie.size = CGSizeMake(_cookieWidth, _cookieHeight);
                slotCookie.texture = _radioactiveSprinkleTexture;
                
                
                [slotCookie removeAllChildren];
                [slotCookie runAction:[SKAction waitForDuration:0.5] completion:^{
                    
                    [self Scan_and_clear_the_grid_of_combos];
                }];
                
            }
                break;
            case 6:{
                [self Randomize_this_Cookie:slotCookie];
                [slotCookie removeAllChildren];
                [self Wrap_that_cookie:slotCookie];
                
                [slotCookie runAction:[SKAction waitForDuration:0.5] completion:^{
                    
                    [self Scan_and_clear_the_grid_of_combos];
                }];
                
            }
                break;
                
            default:{
                [self Randomize_this_Cookie:slotCookie];
                [slotCookie removeAllChildren];
                DebugLog(@"\n\n\tSomething is wrong\n\n\n");
                [slotCookie runAction:[SKAction waitForDuration:0.5] completion:^{
                    
                    [self Scan_and_clear_the_grid_of_combos];
                }];
            }
                break;
        }
        
    }]]]];
    
    /*
     -smores
     -lightning
     -bomb
     -spatula
     -super
     -sprinkles
     -wrapped
     */
    
}

-(void)WonLightning:(CDGameBoardSpriteNode*)piece{
    
    _isTakingInput = NO;
    
    [_powerUpVictims addObject:piece];
    
    BOOL foundCookie = NO;
    int counter = 0;
    
    while (!foundCookie) {
        
        counter++;
        
        if(counter >= 100){
            [self Powerup_deletion];
            break;
        }
        
        int index = arc4random() % _theVisiblePieces.count;
        
        CDGameBoardSpriteNode* victim = _theVisiblePieces[index];
        
        if([victim isKindOfClass:[CDCookieSpriteNode class]] && victim.isVulnerable){
            
            [self SmashThatCookie:(CDCookieSpriteNode*)victim];
            foundCookie = YES;
            break;
        }
        
    }
    
}

#pragma mark - visual effects

-(void)Milkstream:(SKSpriteNode *)milkStream Position:(CGPoint)pos WidthScale:(float)widthScale Angle:(float)angle Zpos:(int)zPos Duration:(float)duration{
    
    
    SKNode* streamParent = [SKNode new];
    streamParent.position = pos;
    streamParent.zRotation = angle;
    streamParent.zPosition = zPos;
    streamParent.alpha = 0;
    
    CGSize theSize = CGSizeMake(widthScale, kScreenHeight);
    
    SKSpriteNode* firstMilkStream = [milkStream copy];
    firstMilkStream.size = theSize;
    [firstMilkStream runAction:_milkstreamAction];
    
    SKSpriteNode* secondMilkStream = [milkStream copy];
    secondMilkStream.size = theSize;
    secondMilkStream.position = CGPointMake(0, -kScreenHeight);
    [secondMilkStream runAction:_milkstreamAction];
    
    [streamParent addChild:firstMilkStream];
    [streamParent addChild:secondMilkStream];
    
    
    [streamParent runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:duration * 0.1],[SKAction waitForDuration:duration * 0.4],[SKAction fadeOutWithDuration:duration*0.5],[SKAction removeFromParent]]]];
    
    [_scene addChild:streamParent];
    
}

-(void)Portal:(CGRect)rect Duration_OUT:(float)duration_Out Duration_IN:(float)duration_In
{
    
    if(!_isPlaying_cdd_milky_vortex){
    
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"cdd_milky_vortex" FileType:@"caf" volume:1]; //@"m4a" volume:1];
//        [_gameBoard runAction:[SGAudioManager MakeSoundEffectAction:@"cdd_milky_vortex" withFileType:@".m4a"]];
        
        _isPlaying_cdd_milky_vortex = YES;
        
        [_gameBoard runAction:[SKAction waitForDuration:0.1f] completion:^{
            
            _isPlaying_cdd_milky_vortex = NO;
            
        }];
    }
    
    SKNode *thePortal = [SKNode new];
    thePortal.position = rect.origin;
    
    thePortal.zPosition = 1;
    
    [_gameBoard addChild:thePortal];
    
    
    //> Opening Shockwave
    SKSpriteNode *openShockwave = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-shock-wave"];
    [openShockwave setScale:0.0f];
    [thePortal addChild:openShockwave];
    SKAction *scaleShockwaveUp = [SKAction scaleTo:1.0f duration:0.5f];
    SKAction *fadeShockwave = [SKAction fadeAlphaTo:0.0f duration:0.5f];
    SKAction *shockwaveSequence = [SKAction group:@[scaleShockwaveUp, fadeShockwave]];
    [openShockwave runAction:shockwaveSequence];
    
    
    //> Main Body
    SKSpriteNode *vortexBody = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-vortex"];
    vortexBody.alpha = 0.55;
    [vortexBody setScale:0.35];
    [thePortal addChild:vortexBody];
    
    // Spin
    SKAction *spinBody = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:1.0]];
    
    // Wait and Delete
    SKAction *waitBody = [SKAction waitForDuration:1.95];
    SKAction *suckBody = [SKAction scaleTo:0.0 duration:0.23];
    SKAction *waitAndSuckBody = [SKAction sequence:@[waitBody, suckBody]];
    SKAction *vortexBodyAction = [SKAction group:@[spinBody, waitAndSuckBody]];
    [vortexBody runAction:vortexBodyAction];
    
    
    //> Outer Core
    SKSpriteNode *vortexOuterCore = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-vortex"];
    vortexOuterCore.alpha = 0.6;
    [vortexOuterCore setScale:0.25];
    [thePortal addChild:vortexOuterCore];
    
    // Spin
    SKAction *spinOuterCore = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:0.8]];
    
    // Wait and Delete
    SKAction *waitOuterCore = [SKAction waitForDuration:1.90];
    SKAction *suckOuterCore = [SKAction scaleTo:0.0 duration:0.26];
    SKAction *waitAndSuckOuterCore = [SKAction sequence:@[waitOuterCore, suckOuterCore]];
    SKAction *vortexOuterCoreAction = [SKAction group:@[spinOuterCore, waitAndSuckOuterCore]];
    [vortexOuterCore runAction:vortexOuterCoreAction];
    
    
    //> Inner Core
    SKSpriteNode *vortexInnerCore = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-vortex"];
    vortexInnerCore.alpha = 0.8;
    [vortexInnerCore setScale:0.186];
//    SKAction *scaleCoreUp = [SKAction scaleTo:0.23 duration:0.1];
//    SKAction *scaleCoreDown = [SKAction scaleTo:0.186 duration:0.1];
//    SKAction *pulseCore = [SKAction sequence:@[scaleCoreUp, scaleCoreDown]];
//    [vortexInnerCore runAction:[SKAction repeatActionForever:pulseCore]];
    [thePortal addChild:vortexInnerCore];
    
    // Spin
    SKAction *spinInnerCore = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:0.3]];
    
    // Wait and Delete
    SKAction *waitInnerCore = [SKAction waitForDuration:1.8];
    SKAction *suckInnerCore = [SKAction scaleTo:0.0 duration:0.35];
    SKAction *waitAndSuckInnerCore = [SKAction sequence:@[waitInnerCore, suckInnerCore]];
    SKAction *vortexInnerCoreAction = [SKAction group:@[spinInnerCore, waitAndSuckInnerCore]];
    [vortexInnerCore runAction:vortexInnerCoreAction];
    
    
    
    //> Clockwise Lightrays
    SKSpriteNode *raysCW = [SKSpriteNode spriteNodeWithImageNamed:@"particle-main-rays"];
    raysCW.alpha = 0.6;
    [raysCW setScale:0.45];
    [thePortal addChild:raysCW];
    
    // Spin
    SKAction *spinRaysCW = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:6.0]];
    
    // Wait and Delete
    SKAction *waitRaysCW = [SKAction waitForDuration:1.75];
    SKAction *suckRaysCW = [SKAction scaleTo:0.0 duration:0.35];
    SKAction *waitAndSuckRaysCW = [SKAction sequence:@[waitRaysCW, suckRaysCW]];
    SKAction *raysCWAction = [SKAction group:@[spinRaysCW, waitAndSuckRaysCW]];
    [raysCW runAction:raysCWAction];
    
    
    
    //> Counter Clockwise Lightrays
    SKSpriteNode *raysCCW = [SKSpriteNode spriteNodeWithImageNamed:@"particle-main-rays"];
    raysCCW.alpha = 0.5;
    [raysCCW setScale:0.45];
    [thePortal addChild:raysCCW];
    
    // Spin
    SKAction *spinRaysCCW = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:5.0]];
    
    // Wait and Delete
    SKAction *waitRaysCCW = [SKAction waitForDuration:1.75];
    SKAction *suckRaysCCW = [SKAction scaleTo:0.0 duration:0.35];
    SKAction *waitAndSuckRaysCCW = [SKAction sequence:@[waitRaysCCW, suckRaysCCW]];
    SKAction *raysCCWAction = [SKAction group:@[spinRaysCCW, waitAndSuckRaysCCW]];
    [raysCCW runAction:raysCCWAction];
    
    [thePortal setScale:0.0f];
    SKAction *openVortex = [SKAction scaleTo:1.0f duration:0.5];
    SKAction *waitAction = [SKAction waitForDuration:2.4];
    SKAction *deleteAction = [SKAction removeFromParent];
    SKAction *waitAndDelete = [SKAction sequence:@[openVortex, waitAction, deleteAction]];
    [thePortal runAction:waitAndDelete];
    
    
//    SKSpriteNode* the_portal = [self.thePortal copy];
//    the_portal.alpha = 0;
//    the_portal.size = CGSizeMake(rect.size.width, rect.size.height);
//    the_portal.position = [_scene convertPoint:rect.origin fromNode:_gameBoard];
//    
//    SKAction * scaling = [SKAction sequence:@[[SKAction scaleTo:0 duration:0],[SKAction fadeInWithDuration:0],[SKAction scaleTo:1 duration:duration_Out],[SKAction scaleTo:0 duration:duration_In]]];
//    
//    SKAction *portalAction = [SKAction group:@[[SKAction rotateByAngle:-100 duration:16],
//                                               scaling,
//                                               [SKAction sequence:@[[SKAction waitForDuration:duration_Out+duration_In], [SKAction removeFromParent]]]
//                                               ]];
//    SKAction *portalAction2 = [SKAction group:@[[SKAction rotateByAngle:-100 duration:8],
//                                                scaling,
//                                                [SKAction sequence:@[[SKAction waitForDuration:duration_Out+duration_In], [SKAction removeFromParent]]]
//                                                ]];
//    
//    
//    // portal image2
//    
//    SKSpriteNode* portalLayer2 = [the_portal copy];
//    [portalLayer2 runAction:portalAction2];
//    
//    [the_portal runAction:portalAction];
//    
//    // the rays
//    SKSpriteNode* theRays = [_thePortal_rays copy];
//    theRays.position = the_portal.position;
//    theRays.zPosition = the_portal.zPosition;
//    theRays.alpha = 0;
//    theRays.size = the_portal.size;
//    
//    [theRays runAction:portalAction];
//    
//    
//    [self.scene addChild:the_portal];
//    [_scene addChild:portalLayer2];
//    [_scene addChild:theRays];
//    
//    // sparkles
//    
//    SKEmitterNode* sparkles = [_portalSparkles copy];
//    sparkles.particleSize = CGSizeMake(_cookieWidth, _cookieHeight);
//    sparkles.particleSpeed = rect.size.width/(duration_In+duration_Out);
//    sparkles.position = the_portal.position;
//    sparkles.zPosition = 3;
//    
//    sparkles.numParticlesToEmit = (duration_In+duration_Out)*sparkles.particleBirthRate;
//    
//    [sparkles runAction:[SKAction group:@[[SKAction rotateByAngle:0.01745329 * -720 duration:10],
//                                          [SKAction sequence:@[[SKAction waitForDuration:duration_In+duration_Out * 2],
//                                                               [SKAction removeFromParent]]]]]];
//    
//    //[SKAction rotateByAngle:0.01745329 * 720 duration:10]];
//    
//    [_scene addChild:sparkles];
    
}

-(SKNode*)Lightning:(CGPoint)point Length:(float)length Angle:(float)angle ZPos:(int)z {
    SKNode *returnNode = [self Lightning:point Length:length Angle:angle ZPos:z PlayAudio:YES];
    return returnNode;
}

-(SKNode*)Lightning:(CGPoint)point Length:(float)length Angle:(float)angle ZPos:(int)z PlayAudio:(BOOL)shouldPlayAudio
{
    
    SKCropNode *cropNode = [self.LightningCropNode copy];
    cropNode.zPosition = z;
    cropNode.position = point;
    cropNode.zRotation = angle;
    
    
    
    SKSpriteNode *mask = [self.LightningCropMask copy];
    mask.size = CGSizeMake(_columnWidth * 3, length);
    mask.position = CGPointMake(0.0f,0.0f);
    cropNode.maskNode = mask;
    
    [self.scene addChild:cropNode];
    
    SKSpriteNode * lighting = [self.Lightning copy];
    
    if (shouldPlayAudio) {
        SKAction *delayLighting = [SKAction waitForDuration:0.05f];
        [self.scene runAction:delayLighting completion:^{
            [[SGAudioManager audioManager] playSoundEffectWithFilename:@"Lightning" FileType:@"caf"]; //@"m4a"];
        }];
    }
    
    
    lighting.size = CGSizeMake(_cookieWidth * 3, _scene.size.height);
    
    [cropNode addChild:lighting];
    
    SKSpriteNode * secondStrike = [lighting copy];
    secondStrike.position = CGPointMake(0, -_scene.size.height);
    
    [cropNode addChild:secondStrike];
    
    [lighting runAction:[SKAction repeatActionForever:self.LightningAction]];
    [secondStrike runAction:[SKAction repeatActionForever:self.LightningAction]];
    
    
    SKSpriteNode* backFlashing = [_LightningBackFlashes copy];
    
    backFlashing.size = lighting.size;
    backFlashing.zPosition = z-2;
    [cropNode addChild:backFlashing];
    
    [backFlashing runAction:_LightningBackFlashingAction];
    
    
    
    return cropNode;
    
}


- (void)createSmoreBurstAtPosition:(CGPoint)position InNode:(SKNode *)parentNode {
    float animationDuration = 2.5;
    
    SKNode *smoreBurst = [SKNode new];
    [parentNode addChild:smoreBurst];
    
    
    //> Spinning giblets
    SKSpriteNode *spinningGiblets = [SKSpriteNode spriteNodeWithImageNamed:@"cdd-particle-smore-crumbs"];
    spinningGiblets.position = position;
    spinningGiblets.alpha = 1;
    [spinningGiblets setScale:0.5];
    [spinningGiblets setZPosition:2];
    [smoreBurst addChild:spinningGiblets];
    
    // Spin
    SKAction *spinBody = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:1.0]];
    
    // Wait and Delete
    SKAction *waitBody = [SKAction waitForDuration:0.1];
    SKAction *suckBody = [SKAction scaleTo:0.0 duration:0.3];
    SKAction *waitAndSuckBody = [SKAction sequence:@[waitBody, suckBody]];
    SKAction *vortexBodyAction = [SKAction group:@[spinBody, waitAndSuckBody]];
    [spinningGiblets runAction:vortexBodyAction];
    
    ////////////////////////////////
    
    // Milk Drops
    SKEmitterNode* drops = [_milkDropsParticle copy];
    drops.position = position;
    [drops setScale:0.25f];
    drops.zPosition = 2;
    [_gameBoard addChild:drops];
    
    // Wait and Delete
    SKAction *waitOuterCore = [SKAction waitForDuration:1];
    SKAction *suckOuterCore = [SKAction scaleTo:0.0 duration:0.23];
    SKAction *waitAndSuckOuterCore = [SKAction sequence:@[waitOuterCore, suckOuterCore]];
    SKAction *vortexOuterCoreAction = [SKAction group:@[ waitAndSuckOuterCore]];
    [drops runAction:vortexOuterCoreAction];
    
    ////////////////////////////////
    
    //
    //
    //
    //> Inner Core
    
    // Shockwave
    SKEmitterNode* shockwave = [_shockwaveParticle copy];
    shockwave.position = position;
    shockwave.alpha = 0.8f;
    [shockwave setScale:1.0f];
    shockwave.zPosition = 2;
    [_gameBoard addChild:shockwave];
    
    ////////////////////////////////
    
    
    //> Clockwise Lightrays
    SKSpriteNode *raysCW = [SKSpriteNode spriteNodeWithImageNamed:@"particle-main-rays"];
    raysCW.position = position;
    raysCW.alpha = 0.8;
    [raysCW setScale:0.2];
    [smoreBurst addChild:raysCW];
    
    // Spin
    SKAction *spinRaysCW = [SKAction repeatActionForever:[SKAction rotateByAngle:360 * (M_PI/180) duration:3.0]];
    
    // Wait and Delete
    SKAction *waitRaysCW = [SKAction waitForDuration:0.3];
    SKAction *suckRaysCW = [SKAction scaleTo:0.0 duration:0.2];
    SKAction *waitAndSuckRaysCW = [SKAction sequence:@[waitRaysCW, suckRaysCW]];
    SKAction *raysCWAction = [SKAction group:@[spinRaysCW, waitAndSuckRaysCW]];
    [raysCW runAction:raysCWAction];
    
    ////////////////////////////////
    
    //> Counter Clockwise Lightrays
    SKSpriteNode *raysCCW = [SKSpriteNode spriteNodeWithImageNamed:@"particle-main-rays"];
    raysCCW.position = position;
    raysCCW.alpha = 0.8;
    [raysCCW setScale:0.2];
    [smoreBurst addChild:raysCCW];
    
    // Spin
    SKAction *spinRaysCCW = [SKAction repeatActionForever:[SKAction rotateByAngle:-360 * (M_PI/180) duration:3.0]];
    
    // Wait and Delete
    SKAction *waitRaysCCW = [SKAction waitForDuration:0.3];
    SKAction *suckRaysCCW = [SKAction scaleTo:0.0 duration:0.2];
    SKAction *waitAndSuckRaysCCW = [SKAction sequence:@[waitRaysCCW, suckRaysCCW]];
    SKAction *raysCCWAction = [SKAction group:@[spinRaysCCW, waitAndSuckRaysCCW]];
    [raysCCW runAction:raysCCWAction];
    
    
    
    SKAction *waitAction = [SKAction waitForDuration:animationDuration];
    SKAction *deleteAction = [SKAction removeFromParent];
    SKAction *waitAndDelete = [SKAction sequence:@[waitAction, deleteAction]];
    [smoreBurst runAction:waitAndDelete];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:@"IngredientDrop" FileType:@"caf" volume:0.5f];
}


// Smore warping
- (SKAction *)smoreWarpAction {
    float animationDuration = 0.85f;
    SKAction *squishAction = [SKAction scaleXTo:0.95f y:1.0f duration:animationDuration];
    squishAction.timingMode = SKActionTimingEaseInEaseOut;
    SKAction *stretchAction = [SKAction scaleXTo:1.0f y:0.95f duration:animationDuration];
    stretchAction.timingMode = SKActionTimingEaseInEaseOut;
    
    SKAction *squishAndStretchAction = [SKAction sequence:@[squishAction, stretchAction]];
    
    return squishAndStretchAction;
}


-(void)Put_a_milk_splash:(CGPoint)point Size:(CGSize)size
{
    
    int randomHit = arc4random() % 3;//_splatSoundsArray.count;
    [_scene runAction:_splatSoundsArray[randomHit]];
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:[NSString stringWithFormat:@"MilkyHit%i", randomHit] FileType:@"m4a" volume:1];  // <<< Turn this back off!
    
    
    
    // Shockwave
    SKEmitterNode* shockwave = [_shockwaveParticle copy];
    shockwave.position = point;
    [shockwave setScale:0.5f];
    shockwave.zPosition = 2;
    [_gameBoard addChild:shockwave];
    
    SKAction* deleteShockwave = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    [shockwave runAction:deleteShockwave];
    
    // Giblets 01
    SKEmitterNode* giblets01 = [_cookieGibletsParticle01 copy];
    giblets01.position = point;
    [giblets01 setScale:0.8f];
    giblets01.zPosition = 2;
    [_gameBoard addChild:giblets01];
    
    SKAction* deleteGiblets01 = [SKAction sequence:@[[SKAction waitForDuration:giblets01.particleLifetime], [SKAction removeFromParent]]];
    [giblets01 runAction:deleteGiblets01];
    
    // Giblets 02
    SKEmitterNode* giblets02 = [_cookieGibletsParticle02 copy];
    giblets02.position = point;
    [giblets02 setScale:1.0f];
    giblets02.zPosition = 2;
    [_gameBoard addChild:giblets02];
    
    SKAction* deleteGiblets02 = [SKAction sequence:@[[SKAction waitForDuration:giblets02.particleLifetime], [SKAction removeFromParent]]];
    [giblets02 runAction:deleteGiblets02];
    
    // Giblets 03
    SKEmitterNode* giblets03 = [_cookieGibletsParticle03 copy];
    giblets03.position = point;
    [giblets03 setScale:1.0f];
    giblets03.zPosition = 2;
    [_gameBoard addChild:giblets03];
    
    SKAction* deleteGiblets03 = [SKAction sequence:@[[SKAction waitForDuration:giblets03.particleLifetime], [SKAction removeFromParent]]];
    [giblets03 runAction:deleteGiblets03];
    
    // Milk Drops
    SKEmitterNode* drops = [_milkDropsParticle copy];
    drops.position = point;
    [drops setScale:0.25f];
    drops.zPosition = 2;
    [_gameBoard addChild:drops];
    
    SKAction* deleteDrops = [SKAction sequence:@[[SKAction waitForDuration:drops.particleLifetime], [SKAction removeFromParent]]];
    [drops runAction:deleteDrops];
    
    // Milk Splat
    SKEmitterNode* milksplat = [_milkSplatParticle copy];
    milksplat.position = point;
    [milksplat setScale:0.8f];
    milksplat.zPosition = 2;
    [_gameBoard addChild:milksplat];
    
    SKAction* deleteMilkSplat = [SKAction sequence:@[[SKAction waitForDuration:1.5], [SKAction removeFromParent]]];
    [milksplat runAction:deleteMilkSplat];
}

-(void)Spatula_Wand_second_attempt{
    
    float halfTheBoardWidth = ((_numColumns * _columnWidth)*0.5) + (_columnWidth * 0.5);
    float halfTheBoardHeight = ((_numRows * _RowHeight)*0.5) + (_RowHeight * 0.5);
    
    CGPoint pointZero = [_scene convertPoint:CGPointMake(halfTheBoardWidth, halfTheBoardHeight) fromNode:_gameBoard];
    
    SKSpriteNode* theSpatulaWand = [_theSpatula copy]; // 0.01745329
    
    theSpatulaWand.alpha = 0;
    theSpatulaWand.zPosition = 0;
    
    theSpatulaWand.zRotation = 0.01745329 * -45;
    theSpatulaWand.anchorPoint = CGPointMake(0, 0);
    theSpatulaWand.position =CGPointMake(pointZero.x - (theSpatulaWand.size.width*0.5), pointZero.y);
    
    [theSpatulaWand runAction:[SKAction sequence:@[[SKAction scaleTo:0.5 duration:0.001], [SKAction fadeInWithDuration:0.5]]] completion:^{
        [[SGAudioManager audioManager] playSoundEffectWithFilename:@"SuperSpatula" FileType:@"caf" volume:1]; //@"m4a" volume:1];
        
        [theSpatulaWand runAction:[SKAction sequence:@[[SKAction group:@[
                                                                        [SKAction rotateByAngle:0.01745329 * 45 duration:0.5],
                                                                        [SKAction scaleTo:1 duration:0.5]
                                                                        ]],
                                                      [SKAction waitForDuration:0.5],
                                                      [SKAction fadeOutWithDuration:0.5],
                                                      [SKAction removeFromParent]
                                                       ]]];
    }];
    
    [_gameBoard runAction:[SKAction waitForDuration:0.75]completion:^{
        
        [self Board_Shuffle_second_attempt];
        
    }];
    
    [_scene addChild:theSpatulaWand];
    
    /*
    SKCropNode* cropNode = [SKCropNode new];
    cropNode.position = pointZero;
    cropNode.zPosition = 4;
    
    SKSpriteNode* background = [_thePowerGlove_background copy];
    background.alpha = 0;
    
    float scale = 0;
    
    if(halfTheBoardHeight > halfTheBoardWidth){
        scale = halfTheBoardHeight/background.texture.size.height;
    }else{
        scale = halfTheBoardWidth/background.texture.size.width;
    }
    
    [background runAction:[SKAction sequence:@[[SKAction waitForDuration:0.6],[SKAction scaleTo:scale duration:0],[SKAction fadeInWithDuration:0.25],[SKAction removeFromParent]]]];
    
    [cropNode addChild:background];
    
    SKSpriteNode *mask = [_thePowerGlove_CropMask copy];
  
    [mask runAction:[SKAction scaleTo:scale duration:0]];

    cropNode.maskNode = mask;
    
    [_scene addChild:cropNode];

    */
    
}


-(void)Nuke_Splode
{
    
    DebugLog(@"\n\n \t SPLODE \n\n");
    
    CGSize sceneSize = _scene.size;
    float nuke_time = 24.0f * 0.05f;
    
    SKSpriteNode* flashing_redLight = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:sceneSize];
    flashing_redLight.alpha = 0;
    flashing_redLight.position = CGPointMake(sceneSize.width*0.5, sceneSize.height*0.5);
    
    SKSpriteNode* blackout = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:sceneSize];
    blackout.alpha = 0;
    blackout.position = flashing_redLight.position;
    
    SKSpriteNode* falling_nuke = [_nuke_falling_Node copy];
    falling_nuke.size = CGSizeMake(_columnWidth, _columnWidth);
    
    falling_nuke.position = CGPointMake(sceneSize.width * 0.5 , sceneSize.height + (_columnWidth * 2));
    
    
    SKSpriteNode* nukeCloud = [_nuke_Node copy];
    nukeCloud.position = CGPointMake(sceneSize.width*0.5, _gameBoard.position.y);
    nukeCloud.alpha = 0;
    // nuke size
    {
        float targetHeight = sceneSize.width;
        
        if(sceneSize.height < targetHeight){
            targetHeight = sceneSize.height;
        }
        
        float newHeight = targetHeight;
        float newWidth = (targetHeight/_nuke_size.height) * _nuke_size.width;
        
        nukeCloud.size = CGSizeMake(newWidth, newHeight);
    }
    
    SKSpriteNode* shockwave = [_nuke_shockwave copy];
    shockwave.alpha = 0;
    // shockwave size
    {
        
        float targetwidth = nukeCloud.size.width;
        
        float newWidth = targetwidth;
        float newHeight = (targetwidth/shockwave.size.width) * shockwave.size.height;
        
        shockwave.size = CGSizeMake(newWidth, newHeight);

        shockwave.position = CGPointMake(nukeCloud.position.x, nukeCloud.position.y + (newHeight*3));
    }
    
    // actions
    
    [falling_nuke runAction:[SKAction sequence:@[[SKAction waitForDuration:4.0f],
                                                 [SKAction moveToY:nukeCloud.position.y+_columnWidth duration:0.5],
                                                 [SKAction removeFromParent]]]];
    
    [flashing_redLight runAction:[SKAction sequence:@[
                                                      [SKAction fadeAlphaTo:0.75 duration:0.1],
                                                      [SKAction fadeAlphaTo:0 duration:1],
                                                      
                                                      [SKAction waitForDuration:0.1],
                                                      
                                                      [SKAction fadeAlphaTo:0.75 duration:0.1],
                                                      [SKAction fadeAlphaTo:0 duration:1], // 2.3
                                                      
                                                      [SKAction waitForDuration:0.1],
                                                      
                                                      [SKAction fadeAlphaTo:0.75 duration:0.1],
                                                      [SKAction fadeAlphaTo:0 duration:1], // 3.5
                                                      
                                                      [SKAction waitForDuration:0.1],
                                                      
                                                      [SKAction fadeAlphaTo:0.75 duration:0.1],
                                                      [SKAction fadeAlphaTo:0 duration:1], // 4.7
                                                      
                                                      [SKAction removeFromParent]
                                                      
                                                      ]]];
    
    [shockwave runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:4.5],
                                              [SKAction scaleTo:0 duration:0.01f],[SKAction waitForDuration:0.1],
                                              [SKAction group:@[
                                                                [SKAction sequence:@[[SKAction fadeInWithDuration:0.5],[SKAction waitForDuration:0.25],[SKAction fadeOutWithDuration:0.25]]],
                                                                [SKAction scaleTo:1 duration:0.75f]
                                                                ]],
                                              [SKAction removeFromParent]
                                              ]]];
    
    [blackout runAction:[SKAction sequence:@[
                                             [SKAction waitForDuration:4.5],
                                             [SKAction fadeAlphaTo:0.5f duration:0.25],
                                             [SKAction waitForDuration:nuke_time-0.75],
                                             [SKAction fadeOutWithDuration:0.5],
                                             [SKAction removeFromParent]
                                             ]]];
    
    [nukeCloud runAction:[SKAction sequence:@[[SKAction waitForDuration:4.5],_nuke_animation]]];
    [nukeCloud runAction:[SKAction sequence:@[
                                              [SKAction waitForDuration:4.5],
                                              [SKAction fadeInWithDuration:0.25],
                                              [SKAction waitForDuration:nuke_time-0.75f],
                                              [SKAction fadeOutWithDuration:0.5],
                                              [SKAction removeFromParent]
                                              ]]];
    
    shockwave.zPosition = 54;
    nukeCloud.zPosition = 53;
    blackout.zPosition = 50;
    flashing_redLight.zPosition = 51;
    falling_nuke.zPosition = 52;
    
    [_scene addChild:shockwave];
    [_scene addChild:blackout];
    [_scene addChild:nukeCloud];
    [_scene addChild:falling_nuke];
    [_scene addChild:flashing_redLight];
    
}

-(void)LockBreak:(CDGameBoardSpriteNode*)piece{
    
    if (!piece.isLocked) {
        return;
    }
    
    piece.isLocked = NO;
    
    NSString *soundName = @"";
    switch ((int)(arc4random() % 2)) {
        case 0:
            soundName = @"MetalHit1";
            break;
        case 1:
            soundName = @"MetalHit2";
            break;
            
        default:
            soundName = @"MetalHit1";
            break;
    }
    
    [[SGAudioManager audioManager] playSoundEffectWithFilename:soundName FileType:@"m4a"];
    
    [piece removeAllChildren];
   
    SKEmitterNode* lockBreak1 = [_lockBreak_1 copy];
    SKEmitterNode* lockBreak2 = [_lockBreak_2 copy];
    SKEmitterNode* lockBreak3 = [_lockBreak_3 copy];
    
    lockBreak1.numParticlesToEmit = 4;
    lockBreak2.numParticlesToEmit = 4;
    lockBreak2.numParticlesToEmit = 4;
    
    lockBreak1.particleBirthRate = 200;
    lockBreak2.particleBirthRate = 200;
    lockBreak3.particleBirthRate = 200;
    
    CGVector posRange = CGVectorMake(_cookieWidth, _cookieHeight);
    
    lockBreak1.particlePositionRange = posRange;
    lockBreak2.particlePositionRange = posRange;
    lockBreak3.particlePositionRange = posRange;
    
    lockBreak1.particleSize = CGSizeMake(_cookieWidth * 0.49f, _cookieHeight * 0.125f);
    lockBreak2.particleSize = CGSizeMake(_cookieWidth * 0.243f, _cookieHeight * 0.319f);
    lockBreak3.particleSize = CGSizeMake(_cookieWidth * 0.118f, _cookieHeight * 0.402f);
    
    lockBreak1.particleScale = 1.0f;
    lockBreak2.particleScale = 1.0f;
    lockBreak3.particleScale = 1.0f;
    
    lockBreak1.particleScaleSpeed = -0.25f;
    lockBreak2.particleScaleSpeed = -0.25f;
    lockBreak3.particleScaleSpeed = -0.25f;
    
    lockBreak1.position = piece.position;
    lockBreak2.position = piece.position;
    lockBreak3.position = piece.position;
    
    lockBreak1.zPosition = 5;
    lockBreak2.zPosition = 5;
    lockBreak3.zPosition = 5;
    
    [_gameBoard addChild:lockBreak1];
    [_gameBoard addChild:lockBreak2];
    [_gameBoard addChild:lockBreak3];
    
    
    SKAction* delete = [SKAction sequence:@[[SKAction waitForDuration:5], [SKAction removeFromParent]]];
    [lockBreak1 runAction:delete];
    [lockBreak2 runAction:delete];
    [lockBreak3 runAction:delete];
    
}

#pragma mark - Powerup deletion

-(void)Powerup_deletion
{
    
    _isTakingInput = NO;
    
    
    // play deaths anims
    for (CDGameBoardSpriteNode* victim in _allCombos) {
        [[CDCookieAnimationManager animationManager] PlayDeleteAnimation:victim];
    }
    
    [_gameBoard runAction:[SKAction waitForDuration:0.24] completion:^{
        
        /*
        // scan through top rows first
        [_powerUpVictims addObjectsFromArray:_allCombos];
        
        for (int row=_numRows; row>-1; row--) {
            for(int i=0; i<_powerUpVictims.count; i++){
                CDGameBoardSpriteNode* piece = [_powerUpVictims objectAtIndex:i];
                if(piece.row == row){
                    [self Piece_Death:piece];
                }
            }
        }
        
        
        
        [self.powerUpVictims removeAllObjects];
        [self.allCombos removeAllObjects];
         
         */
        
        [_allCombos addObjectsFromArray:_powerUpVictims];
        
        [self Kill_Everyone_that_deserves_it];
        
    }];
}

/*
 -(void)ShowTheGrid
 {
 SKSpriteNode* redblock = [SKSpriteNode spriteNodeWithColor:[SKColor redColor] size:CGSizeMake(_cookieWidth, _cookieWidth)];
 [self.scene addChild:redblock];
 
 [redblock runAction:[SKAction sequence:@[[SKAction waitForDuration:3],[SKAction runBlock:^{
 
 for(int i=0; i<_theGrid.count; i++){
 
 CDGameBoardSpriteNode* piece = [_theGrid objectAtIndex:i];
 
 [redblock runAction:[SKAction sequence:@[[SKAction waitForDuration:i*0.25],
 [SKAction moveTo:[self.scene convertPoint:piece.position fromNode:_gameBoard] duration:0.1f]]]];
 
 
 }
 
 }]]]];
 
 }
 */

#pragma mark - Awards popup delegate
- (void)didTapScreenToDismissAwardsPopupViewController:(CDAwardPopupViewController *)awardsPopupViewController
{
    DebugLog(@"Check 1");
//    [awardsPopupViewController.view removeFromSuperview];
}

- (SKScene*)CurrentScene{
    
    return _scene;
}



#pragma mark - Dev Cheats

- (void)autoWinWithStarCount:(int)starCount {
    // Set the desired star level.
    self.scene.milkCup.starLevel = starCount;
    
    // Set the score to match the number of stars.
    switch (starCount) {
        case 1:
            if (self.score < self.scene.milkCup.bronzeLevel) {
                self.score = self.scene.milkCup.bronzeLevel;
            }
            else if (self.score > self.scene.milkCup.silverLevel) {
                self.score = self.scene.milkCup.silverLevel - 1;
            }
            break;
            
        case 2:
            if (self.score < self.scene.milkCup.silverLevel) {
                self.score = self.scene.milkCup.silverLevel;
            }
            else if (self.score > self.scene.milkCup.goldLevel) {
                self.score = self.scene.milkCup.goldLevel - 1;
            }
            break;
            
        case 3:
            if (self.score < self.scene.milkCup.goldLevel) {
                self.score = self.scene.milkCup.goldLevel;
            }
            break;
            
        default:
            DebugLog(@"Error: Unrecognized starCount. We apologize for the inconvenience. Here's a free point..");
            self.score = 1;
            break;
    }
    
    // Activate the win.
    [self GameOver_isConditionGood:YES];
}

- (void)autoLose {
    // Just lose.  Don't worry about score.
    [self GameOver_isConditionGood:NO];
}

@end
