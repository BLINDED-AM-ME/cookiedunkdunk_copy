//
//  SGCookieDunkDunkScene.h
//  CookieDD
//
//  Created by Luke McDonald on 9/18/13.
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

#import <SpriteKit/SpriteKit.h>
#import "SGGameManager.h"
#import "CDGameBoardSpriteNode.h"
#import "CDButtonSpriteNode.h"
#import "CDLabelNode.h"
#import "SGLabelNode.h"
#import "CDFillableCupNode.h"
#import "CDCommonHelpers.h"
#import "CDCookieDunkDunKViewController.h"
#import "SGButtonSpriteNode.h"

typedef enum Direction
{
    Direction_Default,
    Direction_Right,
    Direction_Left,
    Direction_Up,
    Direction_Down

}   Direction;

typedef void (^FinishSwipeCompletionHandler)(BOOL didfinishSwipe);

@protocol SGCookieDunkDunkDelegate;


@interface SGCookieDunkDunkScene : SKScene <SKPhysicsContactDelegate, CDButtonSpriteNodeDelegate, SGButtonSpriteNodeDelegate>

@property (weak, nonatomic) id<SGCookieDunkDunkDelegate> delegate;
@property (strong, nonatomic) CDCookieSpriteNode *clearTypeCookie;
@property (strong, nonatomic) CDButtonSpriteNode *throwAwayButton;

@property (strong, nonatomic) NSMutableArray *blockArray;
@property (assign, nonatomic) Direction direction;
@property (assign, nonatomic) BOOL didMoveCookie;
@property (assign, nonatomic) BOOL gameDidEnd;
@property (strong, nonatomic) SKNode *gameBoard;
@property (strong, nonatomic) SKSpriteNode *sceneryBackgroundSprite;


//////////////////////////
//here
@property (weak, nonatomic) CDCookieDunkDunKViewController *parentController;


@property (assign, nonatomic) ItemType ApplyPowerupOnCookie;

@property (strong, nonatomic) SKSpriteNode *bgFadeSpriteNode;
@property (strong, nonatomic) SKSpriteNode *topBarSpriteNode;
@property (strong, nonatomic) SKSpriteNode *circlePanelSprite;
@property (strong, nonatomic) CDFillableCupNode *milkCup;
@property (strong, nonatomic) SKSpriteNode *milkBarSprite;
@property (strong, nonatomic) SKSpriteNode *boosterSelectedObject;

@property (strong, nonatomic) SGLabelNode *scorelabelNode;
@property (strong, nonatomic) SGLabelNode *limitTitleLabelNode;
@property (strong, nonatomic) SGLabelNode *limiterLabelNode;
@property (strong, nonatomic) SGLabelNode *targetGoalLabelNode;
@property (strong, nonatomic) SGLabelNode *secondGoalLabelNode;

@property (strong, nonatomic) NSMutableArray *topBarBoostersArray;
//@property (strong, nonatomic) CDButtonSpriteNode *booster01Button;
//@property (strong, nonatomic) CDButtonSpriteNode *booster02Button;
//@property (strong, nonatomic) CDButtonSpriteNode *booster03Button;
//@property (strong, nonatomic) CDButtonSpriteNode *booster04Button;
//@property (strong, nonatomic) CDButtonSpriteNode *booster05Button;

// Dustin's stuff

@property (strong, nonatomic) CDGameBoardSpriteNode* theSelectedPiece;
@property (strong, nonatomic) CDGameBoardSpriteNode* theOtherPiece;
@property (strong, nonatomic) NSArray* theGameGrid;

- (void)createSceneContents;
- (void)SetupHUDForOrientation:(UIInterfaceOrientation)orientation;
- (void)handleThrowAwayButton;

-(void)quit:(BOOL)shouldContinue;

@end


@protocol SGCookieDunkDunkDelegate <NSObject>

@optional
- (void)cookieDunkDunkMainGameDidEnd:(SGCookieDunkDunkScene *)scene;
- (void)itemButton:(CDButtonSpriteNode*)buttonSprite wasSelectedForItemType:(ItemType)itemType;
- (void)sgCookieDunkDunkSceneDidQuit:(SGCookieDunkDunkScene*)cookieScene shouldContinue:(BOOL)shouldContinue;
- (void)cookieDunkDunkSceneWillRemoveLoadingScreen;

@end
